# AGENTS.md

> 本文件面向在本仓库工作的 AI Agent 与人类协作者，描述项目结构、运行方式与必须遵守的约定。

## 项目概述

- **项目**：SourceBans++ Web 面板（sbpp/sourcebans-pp），Source 引擎游戏服务器的管理员 / 封禁 / 通讯封禁管理系统。
- **版本**：1.8.0-dev（见 `configs/version.json`；`composer.json` 仍标注 1.7.0）。
- **上游**：https://github.com/sbpp/sourcebans-pp （v1.x 分支）
- **许可证**：CC BY-NC-SA 3.0 + GPL-3.0 双许可。**禁止商用**。
- **本地用途**：基于生产库 `ban_wenyinos_com` 的备份（`db/*.sql.gz`）做本地二次开发 / 调试。

## 技术栈

| 层 | 技术 |
|---|---|
| 语言 | **PHP >= 8.4**（已完整适配 8.4 / 8.5，**不兼容 8.3 及以下**；本机与容器均为 PHP 8.5） |
| 模板 | **Smarty 5.8**（`\Smarty` 命名空间；编译产物固定在项目根 `templates_c/`，缓存目录 `cache/`） |
| 数据库 | MySQL / MariaDB，**双数据访问层并存**：ADOdb 5.22（`$GLOBALS['db']`，历史代码）+ 自研 PDO 封装（`includes/Database.php`，`$GLOBALS['PDO']`，新代码优先使用） |
| AJAX | xajax 0.5（`includes/sb-callback.php` 注册回调，前端 `scripts/xajax.js`） |
| 前端 | mootools + 原生 JS（`scripts/sourcebans.js`），SCSS 源码在 `themes/<主题>/css/` |
| 国际化 | 自研轻量 i18n（`includes/i18n/Lang.php` + `zh_CN.php` / `en_US.php`，键数须保持一致） |
| 依赖管理 | Composer，**vendor 目录定制为 `includes/vendor`（不入库，`.gitignore` 第 4 行）** |
| 关键库 | lcobucci/jwt **5.6**（会话）、symfony/mailer **7.x**（邮件）、maxmind-db/reader（GeoIP）、xpaw/php-source-query-class（RCON/服务器查询） |

**PHP 8.4+ 移植要点（勿回退）**
- 运行环境必须为 PHP 8.4+；**不得**为此添加向后兼容层或屏蔽报错（用户明确要求）。
- Smarty 5：分隔符属性已私有化，须用 `setLeftDelimiter()` / `setRightDelimiter()`；`compile_dir` 默认是**相对路径**，会随 CWD 漂移，故 `init.php` 显式 `setCompileDir(ROOT.'templates_c/')`。
- lcobucci/jwt 5.x：`Builder` / `Parser` / `ValidationData` 已移除；`Token` 变接口，`Token\Plain` **不再实现 `__toString()`**，须用 `->toString()`；所有 JWT 异常实现 `Lcobucci\JWT\Exception` 标记接口，是统一 catch 点。
- `SB_SECRET_KEY` 走 `InMemory::base64Encoded()`，jwt 5.x 严格校验**标准 Base64**（URL-safe 的 `-`/`_` 会抛异常导致登录 500）。
- 排查用 `.local-test/php-overrides.ini` 的 `error_reporting` 已设为纯 `E_ALL`，**不得**重新加回 `~E_DEPRECATED` 之类的抑制。

## 环境准备

```bash
composer install                              # 依赖装到 includes/vendor（必需！vendor 不入库）
cp config.php.template config.php             # 然后填入 DB_*、STEAMAPIKEY、SB_SECRET_KEY 等
gunzip -c db/<备份>.sql.gz | mysql -u root sourcebans   # 可选：导入生产数据快照
chmod -R a+w cache templates_c demos images/maps images/games   # 运行期可写目录
```

- `config.php` 被 `.gitignore` 忽略，**绝不提交**（含数据库口令与 JWT 密钥）。
- **本机已卸载 PHP / nginx / composer**，统一用容器运行：`sbpp-nginx`（host 网络，监听 **8082**）、`sbpp-php`（`wenyinos-php:8.5-fpm`，PHP 8.5，9000）、`sbpp-mysql`。项目目录挂载到容器 `/var/www/html`。
  - 跑 `composer` 需借官方镜像：`podman run --rm --network host -v <proj>:/app -w /app docker.io/library/composer:latest <子命令>`（容器内无 composer）。
- 本地调试也可用 `php -S localhost:8080` 起服务（需自备 PHP）；`init.php` 仅对非 localhost 强制检查 install/updater 目录。
- `sb_debug_connection.php` 是本地自加的数据库连通性调试脚本，非上游文件。

### 本地验证清单（改完代码后跑）

```bash
# 1) 语法
podman exec sbpp-php php -l /var/www/html/<文件>
# 2) 全路由冒烟（18 条 p=/p=&c= 路由，检查非 5xx 且响应体无 PHP 报错）
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1:8082/index.php?p=home"
# 3) 查看诊断（E_ALL 全开，应零 Deprecated / Warning）
podman logs --tail 50 sbpp-php
# 4) 改了模板后清编译缓存
podman exec sbpp-php sh -c 'rm -f /var/www/html/templates_c/*.php'
```

> ⚠️ `podman logs` 在容器 restart 后仍返回**完整历史缓冲**。要判断"本次"是否产生告警，请用 `grep -n` 定位最后一条 PHP 诊断的行号，再用 `tail -n +N` 切其后内容。时间过滤（`--since`）不可靠 —— 容器是 UTC，宿主是 GMT+8。

## 目录结构与请求生命周期

```
index.php → init.php（引导：输入过滤→常量→config.php→autoload→DB→Auth→Smarty）
          → includes/sb-callback.php（xajax 请求在此分流处理）
          → includes/page-builder.php（route() 按 ?p=&c=&o= 分发到 pages/ 下页面）
```

| 路径 | 作用 |
|---|---|
| `pages/` | 页面控制器。命名：`page.<名>.php`（前台）、`admin.<名>.php`（后台）、`pages/core/` 为页头/导航/页尾 |
| `themes/` | Smarty 模板。现有 `default` 与 `SourceBans-Theme-Fluent-Chinese-main`（中文主题）。主题由设置项 `config.theme` 切换 |
| `includes/` | 核心类库：`CUserManager.php`（用户/权限）、`Config.php`（设置存取）、`Log.php`、`auth/`（JWT 会话）、`security/Crypto.php`、`SteamID/` |
| `configs/` | `version.json`；`permissions/web.json` 与 `sourcemod.json` 在引导时被展开为 `ADMIN_*` 常量 |
| `scripts/` | 前端 JS（mootools、xajax、sourcebans.js） |
| `data/` | GeoLite2-Country.mmdb（GeoIP 库） |
| `demos/`、`images/maps`、`images/games` | 上传的录像、地图图、游戏图标，运行期可写 |
| `db/` | 数据库备份，已被 gitignore，**勿提交** |
| `templates_c/`、`cache/` | Smarty 编译/缓存产物，已被 gitignore，可随时清空 |

## 必须遵守的约定

1. **入口防护**：所有被 include 的 PHP 文件以 `if (!defined('IN_SB')) { die(); }` 开头（`init.php` 定义 `IN_SB`）。新增页面/库文件必须照做。
2. **权限检查**：后台页面在路由层调用 `CheckAdminAccess(ADMIN_OWNER|ADMIN_xxx)`；权限常量来自 `configs/permissions/*.json`，新增权限需同步改 JSON 而非硬编码数字。
3. **数据库访问**：新代码用 `$GLOBALS['PDO']`（`includes/Database.php`，预处理语句）；表名必须带前缀，用 `{prefix}` 占位或拼接 `DB_PREFIX`。旧代码里的 ADOdb 调用（`$GLOBALS['db']->Execute`）只维护不扩散。
4. **输入过滤**：`init.php` 已对 `$_GET/$_POST/$_COOKIE` 做 `FILTER_SANITIZE_SPECIAL_CHARS` 全局过滤；输出到模板仍需转义，SQL 一律走预处理，严禁拼接用户输入。
5. **AJAX**：新增异步动作在 `includes/sb-callback.php` 注册 xajax 函数，前端经 `scripts/sourcebans.js` 调用；不要另起 REST 端点。
6. **模板**：改页面优先改 `themes/default` 下的 `.tpl`；中文主题需同步检查。`templates_c/` 是产物，改模板不生效时先清空它。
7. **日志**：业务操作日志走 `Log::add()`（写库），不要 `var_dump`/`echo` 调试到生产页面。

## 测试与验证

- 仓库**没有**单元测试、CI、linter 配置。改动后的最低验证见上文「本地验证清单」（容器语法检查 + 全路由冒烟 + `podman logs` 查诊断）。
- **诊断基线为「零」**：`.local-test/php-overrides.ini` 已设 `error_reporting = E_ALL`，任何 Deprecated / Warning / Notice 都应视为新引入的问题。
- **不要用静态扫描替代实测**：曾用 token 扫描在 Smarty 5 中找出 20 处「隐式 nullable」，但实测零告警 —— 该告警仅在参数类型所属类**尚未定义**时触发。
- 涉及权限/封禁写入的改动，用非 owner 账号回归验证越权防护。
- 前端无构建链：`scripts/*.js` 直接编辑；主题 SCSS 需手动编译为 CSS 后才生效。

## 安全红线

- 不提交 `config.php`、`db/`、`data/*.mmdb`、任何含 Steam API Key / JWT 密钥的文件。
- 不改数据库表结构（`sb_*` 表）除非明确授权；schema 变更须与线上 SourceMod 插件侧兼容。
- 认证（`includes/auth/`）、密码哈希（`SB_NEW_SALT`）、`security/Crypto.php` 属高危区，改动前必须与主人确认。
- `exportbans.php`、`getdemo.php` 是公开入口，改动时注意未授权访问面。
- **Steam OpenID 登录已彻底移除**，不得重新引入（属已知攻击面）。Steam API 仅用于读取玩家资料 / Steam 组信息。
- 排查代码时**禁止**用 `error_reporting` 抑制（`~E_DEPRECATED` 等）掩盖问题；反例见本次移植中暴露的 3 个真 Bug（畸形 JWT 致 500、`CheckVersion()` 在 null 上取下标、Smarty 编译目录随 CWD 漂移）。

## Git 现状

- 远程：`https://github.com/WenYin-Community/sourcebans180`（origin，默认分支 `main`，走 https，`gh` CLI 已登录 `wenyinos`）。
- `includes/vendor`、`config.php`、`db/`、`data/*.mmdb`、`.workbuddy/`、`.local-test/` 均被 gitignore，**不入库**。
- 提交约定：一次一件事，信息简洁；**按逻辑域拆分而非按目录机械切分**（同一目录可能混两类改动，需 `git reset -q` 后精确 `git add <文件>`）。
- 推送前敏感信息闸门（两道）：
  ```bash
  git diff origin/main..HEAD --name-only | grep -E 'config\.php$|\.env|local-test|\.workbuddy|db/|\.mmdb'
  git diff origin/main..HEAD --unified=0 | grep '^+' | grep -iE 'password\s*=|secret\s*=|api[_-]?key\s*='
  ```
- 改动历史：i18n 汉化、Steam OpenID 移除、PHP 8.4+ 完整移植（详见 `.workbuddy/memory/` 日志）。
- ⚠️ `.gitignore` 曾漏掉 `.local-test/`（内含本地 MySQL 口令与生产库名），已补至第 8 行；**新增任何本地脚手架前先确认忽略规则**。
