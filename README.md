# SourceBans++ 中文社区版（WenYin Community）

[![License: CC BY-NC-SA 3.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%203.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/3.0/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![PHP](https://img.shields.io/badge/PHP-%3E%3D8.4-8892bf.svg)](https://www.php.net/)
[![Smarty](https://img.shields.io/badge/Smarty-5.8-yellow.svg)](https://www.smarty.net/)

[English](README_EN.md) | **简体中文**

面向 Source 引擎游戏服务器（CS:S、CS:GO/CS2、TF2、L4D2 等）的**管理员 / 封禁 / 通讯封禁**管理系统。本仓库是 SourceBans++ v1.x 的二次开发分支，聚焦中文本地化与社区化部署。

- 上游项目：<https://github.com/sbpp/sourcebans-pp>
- 上游官网 / 文档：<https://sbpp.dev>
- 本仓库：<https://github.com/WenYin-Community/sourcebans180>

> ⚠️ **授权提示**：本项目采用 CC BY-NC-SA 3.0 + GPL-3.0 双许可，**禁止商业用途**。二次分发必须保留原始版权声明与许可证。

---

## 功能特性

| 模块 | 说明 |
|---|---|
| 封禁管理 | IP / SteamID / 玩家名封禁，支持永久与临时封禁、封禁申诉、自助提交 |
| 通讯封禁 | 禁言 / 禁语音管理，与封禁共用权限模型 |
| 服务器管理 | 服务器增删改查、在线状态与玩家查询、**RCON 远程控制台** |
| 权限体系 | 三类组（网页管理组 / 服务器管理组 / 服务器组）构成的双层权限模型：**网页管理组**掌管后台，**服务器管理组**可踢人封禁但进不了后台，两层权限可叠加 |
| 统一认证（可选） | 可接入社区统一认证中心：跨子域票据静默登录（SSO）、站点级准入、新开通账号首登自动建号；开关关闭即 100% 回到本地账号密码登录 |
| 管理员后台 | 管理员 / 管理员组 / 服务器访问权限 / 模块（Mod）管理 |
| 用户前台 | 封禁列表多条件检索、玩家资料、个人账户与密码找回 |
| 通知 | 邮件发送（封禁通知、申诉回复），支持 SMTP |
| 国际化 | 内置轻量 i18n 子系统，界面文案支持中 / 英双语切换 |
| 其他 | 演示录像（demo）上传与下载、地图缩略图、游戏图标、GeoIP 国家定位、操作日志审计 |

> 🔐 **安全说明**：本分支**已彻底移除 Steam OpenID 快捷登录**（该功能依赖外部重定向，属潜在攻击面）。管理员默认通过本地账号密码登录，会话使用 JWT 令牌；亦支持可选的**社区统一认证（SSO）**接入（见下文「接入统一认证中心」）。Steam Web API 仅用于**读取**玩家资料与 Steam 组信息，不参与任何身份认证流程。

> 🔑 **管理面板入口**：只有被分配到「**网页管理组**」（`sb_groups.type != 3`）的账号才能进入管理面板。
> 「**服务器管理组**」可在网页服务器页右键踢人 / 封禁，并在游戏内行使 SourceMod 权限，但访问 `index.php?p=admin` 会被重定向拒绝；
> 这两类组的区分由 `CUserManager::is_web_admin()` 单独判定，与"是否持有网页权限位"的 `is_admin()` **刻意分离**，
> 因此服务器管理组为了踢人而持有的"添加封禁"权限不会顺带打开后台。

## 环境要求

- **PHP >= 8.4**（本分支已完整适配 PHP 8.4 / 8.5，**不兼容 PHP 8.3 及以下**）
  - 需启用扩展：`pdo_mysql`、`openssl`、`mbstring`、`json`、`sodium`、`xml`、`iconv`
  - ⚠️ `sodium` 为 JWT 依赖 `lcobucci/jwt 5.x` 的硬性要求
- **MySQL / MariaDB**（5.7+ / 10.2+）
- **Composer 2.x**（用于安装依赖）
- Web 服务器：Nginx / Apache（需支持 PHP-FPM 或 mod_php）
- 游戏服务端需安装 **SourceBans++ SourceMod 插件**（与本 Web 面板配套）

> 📌 **本项目已放弃向后兼容**：可运行于 PHP 8.4+，不再支持 8.3 及更早版本，代码中未保留任何旧版兼容层。

## 主要依赖

| 组件 | 版本 | 用途 |
|---|---|---|
| [Smarty](https://www.smarty.net/) | 5.8 | 模板引擎（已迁移至 `\Smarty` 命名空间） |
| [lcobucci/jwt](https://github.com/lcobucci/jwt) | 5.6 | JWT 会话令牌 |
| [ADOdb](https://adodb.org/) | 5.22 | 历史代码使用的数据访问层 |
| [Symfony Mailer](https://symfony.com/doc/current/mailer.html) | 7.x | 邮件发送 |
| [MaxMind DB Reader](https://github.com/maxmind/MaxMind-DB-Reader-php) | 1.14 | GeoIP 国家定位 |
| [xPaw SourceQuery](https://github.com/xPaw/PHP-Source-Query) | dev-master | 游戏服务器查询与 RCON |


## 安装部署

### 1. 获取代码并安装依赖

```bash
git clone https://github.com/WenYin-Community/sourcebans180.git
cd sourcebans180
composer install
```

> ⚠️ **`composer install` 是必需的，不能跳过。**
> `includes/vendor/` 未纳入版本控制，仓库中不包含任何第三方依赖。若跳过此步，程序会在启动时直接报错终止（`Compose autoload not found!`）。
>
> 依赖会被安装到 `includes/vendor/`（`composer.json` 中已通过 `vendor-dir` 定制，非默认路径）。
>
> 若目标机无法访问 Packagist，可先在联网机器执行 `composer install`，再将整个 `includes/vendor/` 目录拷贝过去。

### 版本升级须知（旧版 → 本分支）

从旧版本（PHP 8.1 / Smarty 4）升级到本分支时，**必须重新安装依赖**，并清空模板编译缓存：

```bash
composer install                # 升级 Smarty 4 → 5、jwt 4 → 5 等
rm -f templates_c/*.php         # 旧编译产物由 Smarty 4 生成，与新版本不兼容
```

> PHP 版本低于 8.4 的环境**无法运行**本分支，请先升级运行时。


### 2. 配置数据库连接

```bash
cp config.php.template config.php
```

编辑 `config.php`，填写以下必填项：

```php
define('DB_HOST', 'localhost');            // 数据库主机
define('DB_USER', 'root');                 // 数据库用户名
define('DB_PASS', '');                     // 数据库口令
define('DB_NAME', 'sourcebans');           // 数据库名
define('DB_PREFIX', 'sb');                 // 表前缀
define('DB_PORT', '3306');                 // 端口
define('STEAMAPIKEY', '');                 // Steam Web API Key（用于玩家资料与 Steam 组封禁）
define('SB_NEW_SALT', '$5$');              // 密码盐，生产环境务必修改
define('SB_SECRET_KEY', '');               // JWT 签名密钥，必须是 Base64 编码的随机串
```

> ⚠️ **`SB_SECRET_KEY` 必须是合法的标准 Base64 字符串。**
> JWT 库（`lcobucci/jwt 5.x`）会**严格校验**该值：字符集仅允许 `A-Z a-z 0-9 + /`，须以 `=` 正确补齐，解码后不得为空。
> 若使用了 URL-safe 变体（含 `-` 或 `_`）或长度不合法，**登录时会出现 500 错误**。
>
> 推荐用下面的命令生成一个 32 字节密钥：
>
> ```bash
> php -r 'echo base64_encode(random_bytes(32)), PHP_EOL;'
> ```


> 🔒 `config.php` 已被 `.gitignore` 忽略，**切勿提交到任何仓库**。

### 3. 导入数据库

使用官方安装向导创建的库，或导入已有 SQL 备份：

```bash
gunzip -c your_backup.sql.gz | mysql -u root -p sourcebans
```

### 4. 设置目录权限

以下目录需对 Web 服务进程**可写**：

```bash
chmod -R a+w cache templates_c demos images/maps images/games
```

### 5. 完成安装

浏览器访问站点根目录，按安装向导完成初始化。**安装完成后必须删除 `install/` 与 `updater/` 目录**，否则程序会拒绝启动。

### 6. （可选）接入统一认证中心

本分支预留**统一认证（SSO）接入能力**：在认证中心完成应用注册后，向 `config.php` 增加以下常量即启用——登录改经认证中心的跨子域票据（`wy_auth` Cookie）静默兑换，成功即签发本地 JWT 会话；`WYAUTH_ENABLED=false` 或整段省略即完全使用本地账号密码登录。

```php
define('WYAUTH_ENABLED', true);                                    // 统一认证开关
define('WYAUTH_API', 'https://auth.example.com/auth/api.php');     // 认证中心 API
define('WYAUTH_LOGIN', 'https://auth.example.com/auth/login.php'); // 认证中心登录页
define('WYAUTH_APP_ID', 'ban');                                    // 应用 ID（认证中心 apps 表注册值）
define('WYAUTH_SECRET', '');                                       // 应用密钥（与 apps.secret 一致，切勿泄露）
define('WYAUTH_COOKIE_NAME', 'wy_auth');                           // 票据 Cookie 名
```

行为要点：

- **准入控制**：认证中心按「组」控制站点准入；未开通的账号访问本面板不会自动登录，登录页显示「未开通」提示。
- **自动建号**：经认证中心开通的账号**首次登录本面板时自动建号**，并归入「服务器管理」组（可踢人/封禁、不进管理后台），本地密码为随机值不可用于本地登录。
- **账号绑定**：按用户名与面板既有管理员唯一匹配，**不覆盖**其既有权限组。
- **入口收敛**：启用后本地登录表单与找回密码入口一并关闭；登出为全域登出（同时退出认证中心）。
- **降级**：认证中心不可达时登录页显示提示，不提供本地密码旁路；应急可临时将 `WYAUTH_ENABLED` 置回 `false`。

> 认证中心的部署方式与站点接入协议，参见其所在项目文档（`apps` 表登记应用 + HMAC 签名 API）。

## 安装游戏服务端插件（SourceMod）

Web 面板只负责管理数据，**游戏服务器需要安装配套的 SourceMod 插件**才能与面板通信（写入封禁、同步管理员、上报通讯封禁等）。

本仓库已在 `sourcebans-pp-1.8.0.sourcemod_plugin/` 内**附赠预编译好的插件包**，无需自行编译。

### 前置依赖

游戏服务器需先安装：

- **MetaMod: Source** —— <https://www.sourcemm.net/>
- **SourceMod >= 1.10** —— <https://www.sourcemod.net/>

### 安装步骤

1. **复制插件文件到游戏服务端**

   将 `sourcebans-pp-1.8.0.sourcemod_plugin/common/addons/` 目录**整个合并**到游戏服务端的 `addons/` 目录（与 MetaMod 同级），即：

   ```bash
   # 以 CS:GO 为例，路径按实际服务端调整
   cp -r sourcebans-pp-1.8.0.sourcemod_plugin/common/addons/* \
         /path/to/game-server/csgo/addons/
   ```

   合并后的目录结构应为：

   ```
   addons/sourcemod/
   ├── plugins/       # sbpp_*.smx 插件
   ├── translations/  # 插件多语言文本
   └── configs/sourcebans/
       ├── sourcebans.cfg              # 核心配置
       ├── sourcecomms.cfg             # 通讯封禁配置
       ├── sb_admins.cfg               # 管理员账号（插件从数据库拉取后生成，勿手改）
       ├── sb_admin_groups.cfg         # 管理员组（同上，自动生成）
       └── sourcesleuth_whitelist.cfg  # 多账号检测白名单
   ```

2. **编辑 `sourcebans.cfg`**

   至少修改以下两项，其余按需调整：

   ```
   "Website"     "https://你的面板地址/"   // 玩家跳转申诉/查看封禁的站点地址
   "ServerID"    "1"                       // 本服务器在面板中的 ID（后台「服务器」页可查）
   ```

   关键配置项说明：

   | 配置项 | 说明 |
   |---|---|
   | `Website` | 面板地址，用于 `sm_ban` 提示玩家去何处申诉 |
   | `ServerID` | 服务器 ID，**必须与面板中该服务器的 ID 一致**，否则数据无法对应 |
   | `DatabasePrefix` | 数据库表前缀，需与 `config.php` 中 `DB_PREFIX` 一致（默认 `sb`） |
   | `AutoAddServer` | 是否自动在面板注册本服务器（`2` 含 RCON / `1` 不含 RCON / `0` 不自动添加） |
   | `EnableAdmins` | 是否启用插件管理员部分（从数据库同步管理员） |
   | `RequireSiteLogin` | 是否要求管理员先登录一次网站 |
   | `PrintCheckOnConnect` | 有封禁/通讯封禁历史的玩家进服时是否提示管理员 |
   | `BanTime` / `BanReasons` / `HackingReasons` | 封禁时长档位、封禁理由菜单（请按需本地化） |

3. **填写数据库连接信息**

   插件需要自行连接数据库（**不是**通过 Web 面板中转）。编辑 `addons/sourcemod/configs/databases.cfg`，新增：

   ```
   "sourcebans"
   {
       "driver"    "mysql"
       "host"      "你的数据库地址"
       "database"  "sourcebans"
       "user"      "数据库用户名"
       "pass"      "数据库口令"
   }
   ```

   > ⚠️ 该连接信息与 Web 面板 `config.php` 是**两套独立配置**，请确保两者指向同一数据库、同一表前缀。

4. **重启游戏服务器**，或使用 `sm plugins reload sbpp_main` 重载。

### 插件说明

| 插件 | 作用 |
|---|---|
| `sbpp_main.smx` | 核心插件，负责封禁数据库读写、管理员同步，**必装** |
| `sbpp_comms.smx` | 通讯封禁（禁言 / 禁语音），对应面板的「通讯封禁」模块 |
| `sbpp_checker.smx` | 玩家进服时检查其封禁与通讯封禁记录 |
| `sbpp_admcfg.smx` | 从数据库同步管理员配置到服务端 |
| `sbpp_report.smx` | 游戏内玩家举报功能 |
| `sbpp_sleuth.smx` | 多账号 / 小号检测（配合 `sourcesleuth_whitelist.cfg` 白名单） |

### 常用指令

| 指令 | 说明 |
|---|---|
| `sm_ban <玩家> <时长分钟> <理由>` | 封禁玩家（时长 `0` 为永久） |
| `sm_unban <SteamID>` | 解除封禁 |
| `sm_addban <时长> <SteamID> <理由>` | 对离线玩家预先封禁 |
| `sm_banlist` | 查看封禁列表 |
| `sm_gag <玩家> <时长> <理由>` | 禁言 |
| `sm_mute <玩家> <时长> <理由>` | 禁麦 |
| `sm_silence <玩家> <时长> <理由>` | 同时禁言 + 禁麦 |
| `sm_ungag` / `sm_unmute` / `sm_unsilence` | 解除对应通讯封禁 |
| `sm_rehashadmins` | 重新从数据库拉取管理员配置 |
| `sm_plugins` | 查看插件加载状态 |

> 指令权限由服务端 SourceMod 管理员标志与面板权限体系共同控制，详见面板后台「管理员」与「组管理」。

### 编译插件（可选）

本仓库附带的为预编译 `.smx`，一般无需编译。若需自行编译，详见 SourceMod 官方指南 [Compiling SourceMod Plugins](https://wiki.alliedmods.net/Compiling_SourceMod_Plugins)。

## 目录结构

```
sourcebans180/
├── index.php               # 唯一入口
├── init.php                # 引导：输入过滤 → 常量 → 配置 → 自动加载 → 数据库 → 认证 → 模板
├── upgrade.php             # 版本升级入口
├── exportbans.php          # 封禁数据导出接口
├── getdemo.php             # 演示录像下载接口
├── config.php.template     # 数据库配置模板
├── includes/               # 核心类库
│   ├── auth/               #   会话认证：JWT（lcobucci/jwt 5.x）+ 统一认证处理器（handler/）
│   ├── i18n/               #   国际化：Lang.php + zh_CN / en_US 语言包
│   ├── security/           #   Crypto 加密工具
│   ├── SteamID/            #   SteamID 转换与解析
│   ├── Mail/               #   邮件发送封装（Symfony Mailer）
│   ├── vendor/             #   Composer 依赖（不入库，需 composer install）
│   ├── Database.php        #   PDO 封装（新代码推荐使用）
│   ├── CUserManager.php    #   用户与权限管理
│   ├── Config.php          #   站点设置存取
│   ├── Log.php             #   操作日志
│   ├── sb-callback.php     #   xajax AJAX 回调注册
│   └── page-builder.php    #   路由与页面构建
├── pages/                  # 页面控制器（page.* 前台 / admin.* 后台）
├── themes/                 # Smarty 5 模板主题
├── configs/                # 版本信息与权限定义
├── scripts/                # 前端 JS
├── images/                 # 地图、游戏图标、国旗等静态资源
├── data/                   # GeoIP 数据库（GeoLite2）
├── demos/                  # 上传的演示录像
├── sourcebans-pp-1.8.0.sourcemod_plugin/   # 附赠的游戏服务端 SourceMod 插件包
│   └── common/addons/sourcemod/            #   插件、翻译、配置（安装方式见上文）
├── cache/                  # Smarty 缓存目录（需可写）
└── templates_c/            # Smarty 编译产物（需可写；升级后须清空）
```

**请求生命周期**：

```
index.php → init.php → includes/page-builder.php::route()
          → 按 ?p=<page>&c=<category>&o=<option> 分发到 pages/ 下对应控制器
          → Smarty 渲染 themes/<当前主题>/*.tpl
```

## 主题

内置两套主题，后台「设置」中通过 `config.theme` 切换：

- `default` —— 上游默认主题
- `SourceBans-Theme-Fluent-Chinese-main` —— 中文本地化 Fluent 风格主题（紫色设计系统）

### 中文主题的紫色设计系统

`SourceBans-Theme-Fluent-Chinese-main` 已从上游蓝色 Fluent 改造为**紫色主题**，全部配色收敛到 CSS 变量（`style/scss/global.scss` 根令牌块）：

| 令牌 | 值 | 用途 |
|---|---|---|
| `--brand--base` | `#6f42c1` | 主色 |
| `--brand--gradient` | `160deg` 三段紫渐变 | 顶栏、卡片头、主按钮 |
| `--brand--deep` / `--brand--deepest` | `#3b2266` / `#1e1033` | 标题字、深色描边 |
| `--brand--tint` ~ `--brand--tint-3` | 浅紫阶 | 表头、悬停、分隔 |
| `--theme-background` | `#fcfafd` | 页面底色 |
| `--border--radius` / `--border--radius-pill` | `8px` / `46px` | 圆角规范 |

**深色模式**通过 `[data-theme='dark']` 属性选择器**重定义同一批 CSS 变量**实现，因此样式只要取值走变量即自动适配，无需另写覆盖规则。

**样式组织结构**（`style/scss/`）：`global.scss` 为主入口与令牌定义，`framework/` 为基础组件（按钮、表格、输入框等），`__*.scss` 为按区域划分的模块，`_*.scss` 为独立补充（右键菜单、消息、社交图标）。

### 前端结构调整

- **顶栏合并为一栏**：原 `core/header.tpl` 的 `<header>` 已移除，logo / 搜索框 / 工具图标 / 登录态统一由 `core/navbar.tpl` 的 `.layout_topBar` 渲染（紫色渐变底）。
- **站点 logo**：位于 `images/logos/`，路径由设置项 `template.logo` 指定；当前为白字 + 深紫描边 + TF2 徽标的透明 PNG。

> 修改 SCSS 后需**手动编译**（见下方），并清空 `templates_c/`。

### 编译主题样式

本机不依赖系统 sass，统一借容器编译：

```bash
cd themes/SourceBans-Theme-Fluent-Chinese-main/style
podman run --rm --network host -v "$PWD":/src -w /src docker.io/library/node:24-alpine \
  sh -c "npx --yes sass@1.77.8 global.scss global.css --style=expanded"
```

> ⚠️ 不要加 `--no-source-map`：`style/global.css.map` 已被 git 跟踪，用该参数会导致 map 被删除且不再生成。

修改模板后若未生效，请清空 `templates_c/` 目录。

## 安全建议

- 妥善保管 `config.php`，确保其不在 Web 可直接下载的路径中泄露。
- `SB_SECRET_KEY` 必须为**标准 Base64 编码**的长随机串；`SB_NEW_SALT`（密码盐）生产环境必须修改。
- 站点务必启用 **HTTPS**，JWT 令牌与登录凭据不可走明文。
- 定期更新 PHP 与依赖，关注上游安全公告。
- 后台仅对可信管理员开放，避免将管理入口暴露于公网。
- 生产环境请关闭 `DEBUG_MODE`，并确保 `display_errors` 为 `Off`、`log_errors` 为 `On`。

## 许可证

本项目基于上游 SourceBans++ 二次开发，沿用原项目双许可：

- **CC BY-NC-SA 3.0** —— 署名 · 非商业性使用 · 相同方式共享
- **GPL-3.0** —— GNU 通用公共许可证第 3 版

原始版权归属：

- SourceBans++ (c) 2014-2023 SourceBans++ Dev Team
- SourceBans 1.4.11 (c) 2007-2014 SourceBans Team / GameConnect

## 致谢

感谢 SourceBans++ 开发团队及所有上游贡献者。本分支的本地化与社区化工作由 **WenYin Community** 维护。

问题反馈与交流请提交 [Issue](https://github.com/WenYin-Community/sourcebans180/issues)。
