<?php
/*************************************************************************
This file is part of SourceBans++ (WenYin Community Edition)

简体中文 / 英文国际化（i18n）支持

用法：
    Lang::get('nav.dashboard')                 // 直接取翻译
    Lang::get('ban.permanent')                 // 支持占位符
    Lang::get('pagination.displaying', ['start'=>1,'end'=>20,'total'=>20])

模板中：
    {$lang.nav.dashboard}                       // 由 Smarty 修饰符注入
    {"nav.dashboard"|lang}                      // 或使用修饰符
*************************************************************************/

if (!defined('IN_SB')) {
    echo 'You should not be here. Only follow links!';
    die();
}

class Lang
{
    /** @var string 当前语言代码 */
    private static string $locale = 'zh_CN';

    /** @var array<string,string> 当前语言包 */
    private static array $strings = [];

    /** @var array<string,string> 语言代码 => 显示名称 */
    public const AVAILABLE = [
        'zh_CN' => '简体中文',
        'en_US' => 'English',
    ];

    private static bool $initialized = false;

    /**
     * 初始化语言环境
     *
     * @param string|null $locale 强制指定语言；null 时自动探测
     */
    public static function init(?string $locale = null): void
    {
        if ($locale === null) {
            $locale = self::detectLocale();
        }
        if (!isset(self::AVAILABLE[$locale])) {
            $locale = 'zh_CN';
        }
        self::$locale  = $locale;
        self::$strings = self::load($locale);
        self::$initialized = true;
    }

    /**
     * 探测应使用的语言：优先用户会话/配置，其次浏览器 Accept-Language，最后默认中文
     */
    private static function detectLocale(): string
    {
        // 1. URL 参数显式指定（?lang=en_US），并写入会话
        $requested = $_GET['lang'] ?? null;
        if (is_string($requested) && isset(self::AVAILABLE[$requested])) {
            $_SESSION['sbpp_locale'] = $requested;
            return $requested;
        }

        // 2. 会话中已保存的偏好
        if (isset($_SESSION['sbpp_locale']) && isset(self::AVAILABLE[$_SESSION['sbpp_locale']])) {
            return $_SESSION['sbpp_locale'];
        }

        // 3. 浏览器 Accept-Language
        $accept = $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? '';
        if (stripos($accept, 'zh') === 0 || stripos($accept, 'zh') !== false) {
            return 'zh_CN';
        }

        // 4. 默认：中文（本分支以中文为默认语言）
        return 'zh_CN';
    }

    /**
     * 加载指定语言包，失败时回退到中文
     *
     * @return array<string,string>
     */
    private static function load(string $locale): array
    {
        $file = __DIR__ . '/' . $locale . '.php';
        if (!is_file($file)) {
            $file = __DIR__ . '/zh_CN.php';
        }
        $strings = include $file;
        return is_array($strings) ? $strings : [];
    }

    /**
     * 取翻译。缺失时返回 key 本身（并可将 key 记录到日志）
     *
     * @param string                $key    语言键，形如 "nav.dashboard"
     * @param array<string,scalar>  $params 占位符替换，如 ['total' => 20]
     */
    public static function get(string $key, array $params = []): string
    {
        if (!self::$initialized) {
            self::init();
        }

        $text = self::$strings[$key] ?? $key;

        foreach ($params as $name => $value) {
            $text = str_replace('{' . $name . '}', (string) $value, $text);
        }

        return $text;
    }

    /**
     * 取文案并转义为可安全嵌入 JS 单引号字面量的形式。
     *
     * 文案中已写的 HTML 标签（<br />、<a href="...">）原样保留，
     * 只把反斜杠与单引号转义，这样 ShowBox('...', '{$js}', ...) 不会截断字符串。
     *
     * @param string                $key    语言键
     * @param array<string,scalar>  $params 占位符替换（值不转义，由调用方保证安全）
     */
    public static function js(string $key, array $params = []): string
    {
        $text = self::get($key, $params);

        // 文案自带的 <br /> 等标签无需转义；仅处理会破坏 JS 单引号字面量的字符
        return str_replace(['\\', "\r", "\n", "'"], ['\\\\', '', '', "\\'"], $text);
    }

    /**
     * 当前语言代码
     */
    public static function locale(): string
    {
        if (!self::$initialized) {
            self::init();
        }
        return self::$locale;
    }

    /**
     * 是否已初始化
     */
    public static function isInitialized(): bool
    {
        return self::$initialized;
    }

    /**
     * 注册到 Smarty：
     *   - 变量 {$lang.xxx}  （扁平点号键也可用 {$lang['nav.dashboard']}）
     *   - 修饰符 |lang
     *
     * @param \Smarty $theme
     * @param string  $varName 注入的模板变量名，默认 lang
     */
    public static function registerSmarty($theme, string $varName = 'lang'): void
    {
        if (!self::$initialized) {
            self::init();
        }

        // 挂载 {$lang.xxx}：把整份语言包以关联数组注入
        if (!isset($theme->tpl_vars[$varName])) {
            $theme->assign($varName, self::$strings);
        }

        // 挂载 {$tr.xxx}：同样内容，便于区分（兼容两种习惯）
        if (!isset($theme->tpl_vars['tr'])) {
            $theme->assign('tr', self::$strings);
        }

        // 注册修饰符：{"nav.dashboard"|lang}
        $theme->registerPlugin('modifier', 'lang', static function ($key, $params = []) {
            return Lang::get((string) $key, is_array($params) ? $params : []);
        });

        // 注册函数：{lang key="nav.dashboard"}
        $theme->registerPlugin('function', 'lang', static function ($params, $template) {
            $key = $params['key'] ?? '';
            unset($params['key']);
            return Lang::get((string) $key, $params);
        });
    }
}
