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
| 前端 | mootools + 原生 JS（`scripts/sourcebans.js`），SCSS 源码在 `themes/<主题>/style/scss/`，编译产物为同目录 `global.css` |
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
   - **管理面板入口**另由 `CheckWebAdminAccess()` / `CUserManager::is_web_admin()` 把关（按"是否属于网页管理组"判定），与权限位判定**刻意分离** —— 见「权限模型」章节，别改回 `is_admin()`。
3. **数据库访问**：新代码用 `$GLOBALS['PDO']`（`includes/Database.php`，预处理语句）；表名必须带前缀，用 `{prefix}` 占位或拼接 `DB_PREFIX`。旧代码里的 ADOdb 调用（`$GLOBALS['db']->Execute`）只维护不扩散。
4. **输入过滤**：`init.php` 已对 `$_GET/$_POST/$_COOKIE` 做 `FILTER_SANITIZE_SPECIAL_CHARS` 全局过滤；输出到模板仍需转义，SQL 一律走预处理，严禁拼接用户输入。
5. **AJAX**：新增异步动作在 `includes/sb-callback.php` 注册 xajax 函数，前端经 `scripts/sourcebans.js` 调用；不要另起 REST 端点。
6. **模板**：改页面优先改 `themes/default` 下的 `.tpl`；中文主题需同步检查。`templates_c/` 是产物，改模板不生效时先清空它。
7. **国际化**：新增界面文案一律走 `Lang::get()` / 模板 `{$lang.xxx}` 或 `{"xxx"|lang}`，**不硬编码中英文字面量**。
   - 语言键须在 `zh_CN.php` 与 `en_US.php` **同时补齐**（键数保持一致）。
   - 需要嵌进 JS 单引号字面量时用 **`Lang::js()`**（只转义 `\`、`\r`、`\n`、`'`，中文与已有 HTML 标签原样保留）——典型场景是 `includes/sb-callback.php` 里拼接的 xajax 脚本。
8. **日志**：业务操作日志走 `Log::add()`（写库），不要 `var_dump`/`echo` 调试到生产页面。

## 权限模型（网页管理组 / 服务器管理组 / 服务器组）

三类组（由 `includes/sb-callback.php` 的 `AddGroup` 按 `type` 决定落表）：

| 类别 | type | 落表 | flags 形式 | 权限列表模板 |
|---|---|---|---|---|
| 网页管理组 | 1 | `sb_groups` | 整数位掩码 | `pages/groups.web.perm.php` |
| 服务器管理组 | 2 | `sb_srvgroups` | SourceMod 字母串 | `pages/groups.server.perm.php` |
| 服务器组 | 3 | `sb_groups` | 固定 `0` | 无（纯服务器打包） |

`sb_admins` 一行里两条线彼此独立、可叠加：

| 列 | 来源 | 参与 |
|---|---|---|
| `gid` | 网页管理组 id（`-1` / `0` = 不属于任何网页组） | 面板入口 + 网页权限 |
| `extraflags` | 个人网页权限位掩码 | 网页权限 |
| `srv_group` | 服务器管理组**名字**字符串 | 游戏内权限 |
| `srv_flags` | 个人 SourceMod 权限字母串 | 游戏内权限 |

解析见 `includes/CUserManager.php::GetUserArray()`：

- 有效网页权限 `extraflags = admins.extraflags | sb_groups.flags`（经 `gid` LEFT JOIN）
- 有效服务器权限 `srv_flags = admins.srv_flags . sb_srvgroups.flags`（经 `srv_group = sg.name` JOIN）

### 两个判定，别用错

| 方法 | 含义 | 用途 |
|---|---|---|
| `is_admin($aid)` | 持有**任意**网页权限位（`extraflags & ALL_WEB`） | 公开页 IP / 管理员名显示、封禁评论、`?p=servers` 右键菜单中的评论 / RCON / 私信、`canedit` |
| `is_web_admin($aid)` | **属于网页管理组**：`gid` 指向 `sb_groups.type != 3` 的组 | 管理面板入口（唯一判据） |

**为什么必须分开**：`ALL_WEB = 0xFFFFFDFF`，而服务器管理组为了在网页上踢人 / 封禁必须持 `ADMIN_ADD_BAN`(256)，
于是 `is_admin()` 必然为真 —— 用它当面板门禁就无法区分两类组（这是重构前的真实越权点）。

### 管理面板的三道门（全部用 `is_web_admin()`）

| 位置 | 作用 |
|---|---|
| `pages/core/navbar.php:45` | 顶层「管理面板」菜单项 |
| `pages/core/navbar.php:96` / `:109` | 后台子菜单渲染 / 模板变量 `$isAdmin` |
| `includes/page-builder.php` `case 'admin':` 顶部 `CheckWebAdminAccess()` | `?p=admin` 及**全部**后台子路由 |

> ⚠️ 顶部总门禁不可省：各子分支自己的 `CheckAdminAccess(ADMIN_OWNER|ADMIN_ADD_BAN|…)` 只校验权限位，
> 服务器管理组持 `ADMIN_ADD_BAN` 时 `?p=admin&c=bans` 会被直接放行（重构前实测返回 200）。

### 踢人 / 封禁的两条独立路径

- **游戏内**：SourceMod `srv_flags`（导出 admins.cfg），不需要任何网页权限。
- **网页界面**：`pages/page.servers.php:54` 的 `access_bans = HasAccess(ADMIN_OWNER|ADMIN_ADD_BAN)`（公共服务器页右键菜单）。

### 当前账号配置

对已部署库执行以下 SQL 即可（表前缀按 `DB_PREFIX` 调整；本仓库交付的全库 SQL 已含该配置）：

```sql
-- ruojiner → 网页管理组（gid 指向 type=1 的组）
UPDATE `sb_admins` SET `gid` = 2, `extraflags` = 0 WHERE `user` = 'ruojiner';

-- banuser / kekao → 服务器管理组：无网页组 + 仅"添加封禁"位（网页踢人/封禁）
UPDATE `sb_admins` SET `gid` = 0, `extraflags` = 256, `srv_group` = '服务器管理'
 WHERE `user` IN ('banuser', 'kekao');
```

| 账号 | gid | extraflags | srv_group | 效果 |
|---|---|---|---|---|
| ruojiner | 2（网页管理，type=1） | 0 | — | 可进管理面板 |
| banuser / kekao | 0（无网页组） | 256（添加封禁） | 服务器管理 | 不进面板；网页可踢人 / 封禁 |

### 语义边界

- `gid = -1` 或 `0`（即 AddAdmin 的「无权限」/「自定义权限」）→ **不进管理面板**。
  若日后要给「自定义权限」账号开面板，需引入一个专用权限位（bit 9 / `512` 是当前唯一空闲位）。
- 登录 `includes/auth/handler/NormalAuthHandler.php` **只校验用户名 + 密码**，不要求网页权限，
  因此"无网页权限"的服务器管理组照样能登录。

## 统一认证（SSO，可选）

由 `config.php` 的 `WYAUTH_*` 常量控制（**未定义或 `WYAUTH_ENABLED=false` = 纯本地认证**，原代码路径完整保留）：

- **登录流程**：`init.php` 在 `Auth::init()` 后调用 `WyAuthHandler::bootstrap()` —— 本地未登录且持有认证中心 `wy_auth` 票据时静默兑换（HMAC-SHA256 签名调中心 `api.php action=ticket`），成功即 `Auth::login()` 建本地 JWT 会话，并 302 重载一次使其生效（GET；POST 不重载防丢数据）。兑换失败按票据值负缓存 5 分钟（`sbpp_wyauth_neg` Cookie，含 `not_open`/`api_down` 原因），登录页据此显示提示。
- **账号绑定**：按 `sb_admins.user` 唯一匹配（排除 `aid=0`/CONSOLE）；未命中**自动建号** —— `gid=0`、`extraflags=-33522432`（0xFE007D00）、`srv_group='服务器管理'`、写 `sb_admins_servers_groups` 关联全部服务器、随机本地密码（不可本地登录）。该配置与存量服务器管理账号逐字段一致，**调整前先读「权限模型」**。
- **入口收敛**（开关开启时）：本地登录表单、找回密码页及其 xajax 端点（`Plogin`/`LostPassword`）一并关闭；登出清本地会话后 302 中心 `logout.php`（全域登出）。
- **运维**：`WYAUTH_*` 仅存 `config.php`（不入库），模板见 `config.php.template`；改模板后清 `templates_c/`；应急回退 = 开关置 `false`。
- ⚠️ 新增任何绕过 SSO 的本地登录入口前必须与主人确认。

## 测试与验证

- 仓库**没有**单元测试、CI、linter 配置。改动后的最低验证见上文「本地验证清单」（容器语法检查 + 全路由冒烟 + `podman logs` 查诊断）。
- **诊断基线为「零」**：`.local-test/php-overrides.ini` 已设 `error_reporting = E_ALL`，任何 Deprecated / Warning / Notice 都应视为新引入的问题。
- **不要用静态扫描替代实测**：曾用 token 扫描在 Smarty 5 中找出 20 处「隐式 nullable」，但实测零告警 —— 该告警仅在参数类型所属类**尚未定义**时触发。
- 涉及权限/封禁写入的改动，用非 owner 账号回归验证越权防护。
- **权限模型回归**：改动权限后必须验证三态 —— 匿名 / 网页管理组成员 / 服务器管理组成员。
  期望：`?p=admin` 与 `?p=admin&c=bans` 对前两态以外的服务器管理组返回 **302**（跳 `?p=login&m=no_access`），
  同时该账号在 `?p=servers` 仍能看到右键踢人菜单。可用临时探针脚本断言 `is_admin()` / `is_web_admin()`（用完即删，`git status` 复核）。
- 前端无构建链：`scripts/*.js` 直接编辑；主题 SCSS 需手动编译为 CSS 后才生效。

### 主题 SCSS 编译

本机未安装 sass，统一借容器编译（**必须带 `--style=expanded`**）：

```bash
cd themes/<主题>/style
podman run --rm --network host -v "$PWD":/src -w /src docker.io/library/node:24-alpine \
  sh -c "npx --yes sass@1.77.8 global.scss global.css --style=expanded"
```

> ⚠️ 不要加 `--no-source-map`：`style/global.css.map` 是 git 跟踪文件，
> 一旦用该参数编译，map 会被删除且不再生成。`--style=expanded` 同时保证产物为可读的展开 CSS。
> 编译后记得清 `templates_c/`。

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
- 改动历史：i18n 汉化、Steam OpenID 移除、PHP 8.4+ 完整移植、**权限模型重构（管理面板入口与权限位解耦，见「权限模型」章节）**、**统一认证（SSO）接入（见「统一认证」章节）**（详见 `.workbuddy/memory/` 日志）。
- ⚠️ `.gitignore` 曾漏掉 `.local-test/`（内含本地 MySQL 口令与生产库名），已补至第 8 行；**新增任何本地脚手架前先确认忽略规则**。
