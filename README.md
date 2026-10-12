# SourceBans++ 中文社区版（WenYin Community）

[![License: CC BY-NC-SA 3.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%203.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/3.0/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![PHP](https://img.shields.io/badge/PHP-%3E%3D8.1-8892bf.svg)](https://www.php.net/)

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
| 权限体系 | 基于组的 Web 权限 + SourceMod 权限双层模型，细粒度到单个后台操作 |
| 管理员后台 | 管理员 / 管理员组 / 服务器访问权限 / 模块（Mod）管理 |
| 用户前台 | 封禁列表多条件检索、玩家资料、Steam 快捷登录、个人账户与密码找回 |
| 通知 | 邮件发送（封禁通知、申诉回复），支持 SMTP |
| 其他 | 演示录像（demo）上传与下载、地图缩略图、游戏图标、GeoIP 国家定位、操作日志审计 |

## 环境要求

- **PHP >= 8.1**（推荐 8.2+），需启用扩展：`pdo_mysql`、`openssl`、`mbstring`、`json`
- **MySQL / MariaDB**（5.7+ / 10.2+）
- **Composer 2.x**
- Web 服务器：Nginx / Apache（需支持 PHP-FPM 或 mod_php）
- 游戏服务端需安装 **SourceBans++ SourceMod 插件**（与本 Web 面板配套）

## 安装部署

### 1. 获取代码并安装依赖

```bash
git clone https://github.com/WenYin-Community/sourcebans180.git
cd sourcebans180
composer install
```

> 依赖会被安装到 `includes/vendor/`（`composer.json` 中已通过 `vendor-dir` 定制，非默认路径）。

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
define('STEAMAPIKEY', '');                 // Steam Web API Key（用于玩家资料）
define('SB_NEW_SALT', '$5$');              // 密码盐，生产环境务必修改
define('SB_SECRET_KEY', '');               // JWT 签名密钥，务必填写足够长的随机串
```

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
│   ├── auth/               #   JWT 会话 + Steam OpenID 登录
│   ├── security/           #   Crypto 加密工具
│   ├── SteamID/            #   SteamID 转换与解析
│   ├── Mail/               #   邮件发送封装
│   ├── Database.php        #   PDO 封装（新代码推荐使用）
│   ├── CUserManager.php    #   用户与权限管理
│   ├── Config.php          #   站点设置存取
│   ├── Log.php             #   操作日志
│   ├── sb-callback.php     #   xajax AJAX 回调注册
│   └── page-builder.php    #   路由与页面构建
├── pages/                  # 页面控制器（page.* 前台 / admin.* 后台）
├── themes/                 # Smarty 模板主题
├── configs/                # 版本信息与权限定义
├── scripts/                # 前端 JS
├── images/                 # 地图、游戏图标、国旗等静态资源
├── data/                   # GeoIP 数据库（GeoLite2）
├── demos/                  # 上传的演示录像
├── cache/                  # Smarty 缓存（需可写）
└── templates_c/            # Smarty 编译产物（需可写）
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
- `SourceBans-Theme-Fluent-Chinese-main` —— 中文本地化 Fluent 风格主题

修改模板后若未生效，请清空 `templates_c/` 目录。

## 安全建议

- 妥善保管 `config.php`，确保其不在 Web 可直接下载的路径中泄露。
- `SB_SECRET_KEY` 必须为长随机字符串；`SB_NEW_SALT`（密码盐）生产环境必须修改。
- 站点务必启用 **HTTPS**，JWT 令牌与登录凭据不可走明文。
- 定期更新 PHP 与依赖，关注上游安全公告。
- 后台仅对可信管理员开放，避免将管理入口暴露于公网。

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
