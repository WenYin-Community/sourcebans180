<?php

use Lcobucci\JWT\Configuration;
use Lcobucci\JWT\Signer\Hmac\Sha256;
use Lcobucci\JWT\Signer\Key\InMemory;
use Lcobucci\JWT\Token;
use Lcobucci\JWT\Validation\Constraint\IdentifiedBy;
use Lcobucci\JWT\Validation\Constraint\IssuedBy;
use Lcobucci\JWT\Validation\Constraint\PermittedFor;
use Lcobucci\JWT\Validation\Constraint\SignedWith;
use Lcobucci\JWT\Validation\Constraint\StrictValidAt;
use Psr\Clock\ClockInterface;

class JWT
{
    public static function create(string $jti, int $maxLife, int $aid, string $wyt = ''): Token\Plain
    {
        $config = static::getConfig();
        $date = new DateTimeImmutable();

        $builder = $config->builder()
            ->identifiedBy($jti)
            ->issuedBy(Host::domain())
            ->permittedFor(Host::domain())
            ->canOnlyBeUsedAfter($date)
            ->issuedAt($date)
            ->expiresAt($date->setTimestamp($date->getTimestamp() + $maxLife))
            ->withClaim('aid', $aid);

        // 统一认证会话：记录签发时的中心票据指纹（sha256），供后续请求持续比对中心登录态
        if ($wyt !== '') {
            $builder = $builder->withClaim('wyt', $wyt);
        }

        return $builder->getToken($config->signer(), $config->signingKey());
    }

    public static function parse(string $jwt): Token
    {
        $config = self::getConfig();

        return $config->parser()->parse($jwt);
    }

    public static function validate(Token $token): bool
    {
        $config = self::getConfig();

        $constrains = [
            new SignedWith($config->signer(), $config->signingKey()),
            new IssuedBy(Host::domain()),
            new PermittedFor(Host::domain()),
            new IdentifiedBy($token->claims()->get('jti')),
            // 校验 exp / nbf / iat。缺少这一项时过期令牌会被永久接受：
            // Auth::verify() 通过后直接按 claims['aid'] 授权，不再查库。
            new StrictValidAt(new class implements ClockInterface {
                public function now(): DateTimeImmutable
                {
                    return new DateTimeImmutable();
                }
            })
        ];

        return $config->validator()->validate($token, ...$constrains);
    }

    private static function getConfig(): Configuration
    {
        return Configuration::forSymmetricSigner(new Sha256(), InMemory::base64Encoded(static::validateSecretKey()));
    }

    /**
     * 校验 JWT 密钥并返回原始 Base64 字符串。
     *
     * InMemory::base64Encoded() 接收的是 **Base64 字符串**（它内部会再解码一次），
     * 所以这里只做校验、不改写返回值。它对非法 Base64 的行为是静默截断，会让
     * "配置写错" 和 "密钥被轮换/篡改" 都表现为签名验证失败，难以定位；显式校验
     * 可以让配置错误在第一次签发/验证时就带着明确信息炸出来。
     */
    private static function validateSecretKey(): string
    {
        if (!defined('SB_SECRET_KEY') || SB_SECRET_KEY === '') {
            throw new RuntimeException(
                'JWT 密钥未配置：请在 config.php 中设置 SB_SECRET_KEY（可访问 upgrade.php 自动生成）。'
            );
        }

        $key = base64_decode(SB_SECRET_KEY, true);

        if ($key === false) {
            throw new RuntimeException(
                'JWT 密钥非法：SB_SECRET_KEY 必须是合法的 Base64 字符串，请检查 config.php。'
            );
        }

        if (strlen($key) < 32) {
            throw new RuntimeException(
                'JWT 密钥过弱：SB_SECRET_KEY 解码后至少需要 32 字节，当前为 '.strlen($key).' 字节。'
            );
        }

        return SB_SECRET_KEY;
    }
}
