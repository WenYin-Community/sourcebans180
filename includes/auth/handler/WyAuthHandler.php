<?php

if (!defined('IN_SB')) {
    echo 'You should not be here. Only follow links!';
    die();
}

use Lcobucci\JWT\Token;

/**
 * 玟茵社区统一认证（wenyinos 认证中心）接入处理器。
 *
 * bootstrap() 在 init.php 早期调用：
 * - 本地未登录且持有 wy_auth 跨域票据时静默兑换，成功即建本地会话（JWT 携带票据指纹 claim wyt）；
 * - 本地已登录的 SSO 会话每次请求与中心登录态比对（指纹存于 JWT，与会话同生共死）：
 *   票据未变零开销；中心换号→重兑并按需切换本地账号；中心登出/票据失效→本地登出并回中心；
 *   中心不可达→保持现状静默降级（对齐 BBS/禅道单点登出一致性语义）。
 * - 无 wyt 指纹的会话为本地密码登录，不受中心登录态影响。
 */
class WyAuthHandler
{
    private const NEG_COOKIE = 'sbpp_wyauth_neg';
    private const NEG_TTL = 300;

    public static function bootstrap(): void
    {
        if (!defined('WYAUTH_ENABLED') || !WYAUTH_ENABLED) {
            return;
        }

        $ticket = self::ticketFromCookie();
        $token = Auth::verify();

        if ($token !== null) {
            self::syncLoggedIn($token, $ticket);
            return;
        }

        if ($ticket === '' || self::negativeCacheHit($ticket)) {
            return;
        }

        $resp = self::exchange($ticket);
        if ($resp === null) {
            self::markNegative($ticket, 'api_down');
            return;
        }
        if (intval($resp['code'] ?? -1) !== 0) {
            self::markNegative($ticket, intval($resp['code'] ?? 0) === 1004 ? 'not_open' : 'invalid');
            return;
        }

        $aid = self::findOrProvision(is_array($resp['data'] ?? null) ? $resp['data'] : []);
        if ($aid <= 0) {
            self::markNegative($ticket, 'provision_fail');
            return;
        }

        self::clearNegative();
        self::login($aid, $ticket);
    }

    // 已登录会话与中心票据持续比对：换号即同步、中心登出即掉线、中心不可达静默降级
    private static function syncLoggedIn(Token $token, string $ticket): void
    {
        $recorded = (string)($token->claims()->get('wyt') ?? '');
        if ($recorded === '') {
            return;
        }

        if ($ticket !== '' && hash_equals($recorded, hash('sha256', $ticket))) {
            return;
        }

        if ($ticket === '') {
            self::forceLogout();
            return;
        }

        if (self::negativeCacheHit($ticket)) {
            return;
        }

        $resp = self::exchange($ticket);
        if ($resp === null) {
            self::markNegative($ticket, 'api_down');
            return;
        }
        if (intval($resp['code'] ?? -1) !== 0) {
            self::markNegative($ticket, intval($resp['code'] ?? 0) === 1004 ? 'not_open' : 'invalid');
            self::forceLogout();
            return;
        }

        $aid = self::findOrProvision(is_array($resp['data'] ?? null) ? $resp['data'] : []);
        if ($aid <= 0) {
            self::markNegative($ticket, 'provision_fail');
            return;
        }

        self::clearNegative();
        self::login($aid, $ticket, $aid !== (int)$token->claims()->get('aid'));
    }

    // 建/续本地会话；$reload 仅在身份变化（切换账号）时为 true——Cookie 本请求内不可见，需重载生效
    private static function login(int $aid, string $ticket, bool $reload = true): void
    {
        $maxlife = intval(Config::get('auth.maxlife')) * 60;
        Auth::login($aid, $maxlife > 0 ? $maxlife : 86400, hash('sha256', $ticket));

        if ($reload && ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET' && !isset($_GET['_wy'])) {
            header('Location: ' . self::reloadUrl());
            exit();
        }
    }

    // 中心态已失效（登出/票据无效/未开通）：清本地会话并回中心
    private static function forceLogout(): void
    {
        Auth::logout();
        header('Location: ' . rtrim(dirname(WYAUTH_LOGIN), '/') . '/login.php');
        exit();
    }

    // login/lostpassword 页展示状态：guide=正常引导 / not_open=未开通 / api_down=服务不可用
    public static function pageState(): string
    {
        $neg = self::readNegative();
        $reason = $neg['reason'] ?? '';
        if ($reason === 'not_open') {
            return 'not_open';
        }
        if ($reason === 'api_down') {
            return 'api_down';
        }
        return 'guide';
    }

    // SSO 模式登出：本地会话已清，跳中心 logout.php 撤销票据并清 wy_auth Cookie
    public static function logoutRedirect(): void
    {
        header('Location: ' . rtrim(dirname(WYAUTH_LOGIN), '/') . '/logout.php');
        exit();
    }

    // 按认证中心 API 协议兑换票据（HMAC-SHA256 签名）；网络失败返回 null
    private static function exchange(string $ticket): ?array
    {
        $body = json_encode(['action' => 'ticket', 'data' => ['ticket' => $ticket]], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

        $ts = (string)time();
        $nonce = bin2hex(random_bytes(16));
        $sign = hash_hmac('sha256', WYAUTH_APP_ID . '|ticket|' . md5($body) . '|' . $ts . '|' . $nonce, WYAUTH_SECRET);

        $context = stream_context_create([
            'http' => [
                'method' => 'POST',
                'header' => "Content-Type: application/json\r\n"
                    . 'X-WY-APP: ' . WYAUTH_APP_ID . "\r\n"
                    . 'X-WY-TIMESTAMP: ' . $ts . "\r\n"
                    . 'X-WY-NONCE: ' . $nonce . "\r\n"
                    . 'X-WY-SIGN: ' . $sign,
                'content' => $body,
                'timeout' => 5,
                'ignore_errors' => true,
            ],
        ]);

        $raw = @file_get_contents(WYAUTH_API, false, $context);
        if ($raw === false) {
            return null;
        }
        $resp = json_decode($raw, true);
        return is_array($resp) ? $resp : null;
    }

    private static function findOrProvision(array $payload): int
    {
        $username = trim((string)($payload['username'] ?? ''));
        if ($username === '') {
            return 0;
        }

        $GLOBALS['PDO']->query('SELECT aid FROM `:prefix_admins` WHERE `user` = :user AND aid > 0');
        $GLOBALS['PDO']->bind(':user', $username);
        $row = $GLOBALS['PDO']->single();
        if (is_array($row) && !empty($row['aid'])) {
            return (int)$row['aid'];
        }

        return self::provisionAdmin($username, (string)($payload['email'] ?? ''));
    }

    // 自动建号：与现有服务器管理账号一致（gid=0、0xFE007D00、服务器管理组），本地密码为随机值。
    // 注意：不走 CUserManager::AddAdmin —— 其依赖的 MIN_PASS_LENGTH 常量在 init 后段才定义，
    // 而本处理器运行于该定义之前。
    private static function provisionAdmin(string $username, string $email): int
    {
        try {
            $GLOBALS['PDO']->query(
                'INSERT INTO `:prefix_admins` (`user`, `authid`, `password`, `gid`, `email`, `extraflags`, `immunity`, `srv_group`, `srv_flags`, `srv_password`)
                 VALUES (:user, :authid, :pass, :gid, :email, :extraflags, :immunity, :srv_group, :srv_flags, :srv_password)'
            );
            $GLOBALS['PDO']->bind(':user', $username);
            $GLOBALS['PDO']->bind(':authid', '');
            $GLOBALS['PDO']->bind(':pass', password_hash(bin2hex(random_bytes(16)), PASSWORD_BCRYPT));
            $GLOBALS['PDO']->bind(':gid', 0, PDO::PARAM_INT);
            $GLOBALS['PDO']->bind(':email', $email);
            $GLOBALS['PDO']->bind(':extraflags', -33522432, PDO::PARAM_INT);
            $GLOBALS['PDO']->bind(':immunity', 100, PDO::PARAM_INT);
            $GLOBALS['PDO']->bind(':srv_group', '服务器管理');
            $GLOBALS['PDO']->bind(':srv_flags', '');
            $GLOBALS['PDO']->bind(':srv_password', '');
            $GLOBALS['PDO']->execute();

            $aid = (int)$GLOBALS['PDO']->lastInsertId();
            if ($aid <= 0) {
                return 0;
            }

            $GLOBALS['PDO']->query(
                'INSERT INTO `:prefix_admins_servers_groups` (admin_id, group_id, srv_group_id, server_id)
                 SELECT :aid, sg.id, -1, s.sid
                 FROM `:prefix_srvgroups` sg, `:prefix_servers` s
                 WHERE sg.name = :name'
            );
            $GLOBALS['PDO']->bind(':aid', $aid, PDO::PARAM_INT);
            $GLOBALS['PDO']->bind(':name', '服务器管理');
            $GLOBALS['PDO']->execute();
        } catch (Throwable $e) {
            error_log('WyAuthHandler provision failed: ' . $e->getMessage());
            return 0;
        }

        error_log("WyAuthHandler auto-provisioned admin '{$username}' (aid={$aid}) via unified auth");
        return $aid;
    }

    private static function ticketFromCookie(): string
    {
        $name = defined('WYAUTH_COOKIE_NAME') ? WYAUTH_COOKIE_NAME : 'wy_auth';
        $ticket = $_COOKIE[$name] ?? '';
        if (!is_string($ticket) || strlen($ticket) < 20 || strpos($ticket, '.') === false) {
            return '';
        }
        return $ticket;
    }

    private static function negativeCacheHit(string $ticket): bool
    {
        $neg = self::readNegative();
        if ($neg === null || !hash_equals($neg['hash'], hash('sha256', $ticket))) {
            return false;
        }
        return $neg['time'] > time();
    }

    private static function markNegative(string $ticket, string $reason): void
    {
        setcookie(
            self::NEG_COOKIE,
            hash('sha256', $ticket) . '|' . $reason . '|' . (time() + self::NEG_TTL),
            [
                'expires' => time() + self::NEG_TTL,
                'path' => '/',
                'secure' => Host::isSecure(),
                'httponly' => true,
                'samesite' => 'Lax',
            ]
        );
    }

    private static function clearNegative(): void
    {
        if (isset($_COOKIE[self::NEG_COOKIE])) {
            setcookie(self::NEG_COOKIE, '', ['expires' => time() - 86400, 'path' => '/']);
        }
    }

    private static function readNegative(): ?array
    {
        $raw = $_COOKIE[self::NEG_COOKIE] ?? '';
        if (!is_string($raw)) {
            return null;
        }
        $parts = explode('|', $raw);
        if (count($parts) !== 3) {
            return null;
        }
        return ['hash' => $parts[0], 'reason' => $parts[1], 'time' => (int)$parts[2]];
    }

    private static function reloadUrl(): string
    {
        $parts = parse_url($_SERVER['REQUEST_URI'] ?? '/index.php');
        $path = $parts['path'] ?? '/index.php';
        $query = [];
        if (!empty($parts['query'])) {
            parse_str($parts['query'], $query);
        }
        $query['_wy'] = '1';
        return $path . '?' . http_build_query($query);
    }
}
