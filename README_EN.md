# SourceBans++ — WenYin Community Edition

[![License: CC BY-NC-SA 3.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%203.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/3.0/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![PHP](https://img.shields.io/badge/PHP-%3E%3D8.4-8892bf.svg)](https://www.php.net/)
[![Smarty](https://img.shields.io/badge/Smarty-5.8-yellow.svg)](https://www.smarty.net/)

**English** | [简体中文](README.md)

An **admin, ban, and communications-block management system** for Source engine game servers (CS:S, CS:GO/CS2, TF2, L4D2, etc.). This repository is a fork of SourceBans++ v1.x focused on Chinese localization and community deployment.

- Upstream project: <https://github.com/sbpp/sourcebans-pp>
- Upstream website / docs: <https://sbpp.dev>
- This repository: <https://github.com/WenYin-Community/sourcebans180>

> ⚠️ **License notice**: This project is dual-licensed under CC BY-NC-SA 3.0 and GPL-3.0. **Commercial use is prohibited.** Redistributions must retain the original copyright notices and license texts.

---

## Features

| Module | Description |
|---|---|
| Ban management | IP / SteamID / player-name bans, permanent and temporary, ban protests, self-service submissions |
| Communications blocks | Mute / gag management sharing the same permission model as bans |
| Server management | Server CRUD, live status and player queries, **RCON remote console** |
| Permissions | Two-layer model: web group permissions + SourceMod flags, granular down to individual admin actions |
| Unified sign-in (optional) | Optional community SSO center integration: silent cross-subdomain ticket sign-in, per-site admission control, auto-provisioning of newly approved accounts; switch off to fall back to local credentials entirely |
| Admin backend | Admin, admin-group, server-access, and mod management |
| Public frontend | Multi-criteria ban-list search, player profiles, account and password recovery |
| Notifications | Email delivery (ban notices, protest replies) with SMTP support |
| Internationalization | Built-in lightweight i18n subsystem; UI strings switchable between Chinese and English |
| Misc | Demo upload/download, map thumbnails, game icons, GeoIP country lookup, audit logging |

> 🔐 **Security note**: This fork has **completely removed Steam OpenID login** (it relied on an external redirect and represented a potential attack surface). Administrators sign in with local credentials by default, and sessions use JWT tokens; an optional **community unified sign-in (SSO)** integration is also supported (see "Unified Sign-in Center" below). The Steam Web API is used only to **read** player profiles and Steam group info — it plays no part in authentication.

## Requirements

- **PHP >= 8.4** (this branch is fully ported to PHP 8.4 / 8.5 and is **incompatible with PHP 8.3 and below**)
  - Required extensions: `pdo_mysql`, `openssl`, `mbstring`, `json`, `sodium`, `xml`, `iconv`
  - ⚠️ `sodium` is a hard requirement of the JWT library `lcobucci/jwt 5.x`
- **MySQL / MariaDB** (5.7+ / 10.2+)
- **Composer 2.x** (for installing dependencies)
- Web server: Nginx / Apache (PHP-FPM or mod_php)
- The **SourceBans++ SourceMod plugin** installed on your game servers (companion to this web panel)

> 📌 **No backward compatibility**: This fork runs on PHP 8.4+ only. PHP 8.3 and earlier are no longer supported, and no legacy compatibility layer is retained in the codebase.

## Key Dependencies

| Component | Version | Purpose |
|---|---|---|
| [Smarty](https://www.smarty.net/) | 5.8 | Template engine (migrated to the `\Smarty` namespace) |
| [lcobucci/jwt](https://github.com/lcobucci/jwt) | 5.6 | JWT session tokens |
| [ADOdb](https://adodb.org/) | 5.22 | Data-access layer used by legacy code |
| [Symfony Mailer](https://symfony.com/doc/current/mailer.html) | 7.x | Email delivery |
| [MaxMind DB Reader](https://github.com/maxmind/MaxMind-DB-Reader-php) | 1.14 | GeoIP country lookup |
| [xPaw SourceQuery](https://github.com/xPaw/PHP-Source-Query) | dev-master | Game-server queries and RCON |

## Installation

### 1. Clone and install dependencies

```bash
git clone https://github.com/WenYin-Community/sourcebans180.git
cd sourcebans180
composer install
```

> ⚠️ **`composer install` is mandatory and cannot be skipped.**
> `includes/vendor/` is not tracked in version control — the repository ships no third-party dependencies. If you skip this step, the application aborts at startup with `Compose autoload not found!`.
>
> Dependencies are installed into `includes/vendor/` — the `vendor-dir` is customized in `composer.json`, not the default location.
>
> If the target machine cannot reach Packagist, run `composer install` on a networked machine first, then copy the whole `includes/vendor/` directory over.

### Upgrading from an older version

When moving from an older release (PHP 8.1 / Smarty 4) to this branch, you **must reinstall dependencies** and clear the template compile cache:

```bash
composer install                # upgrades Smarty 4 -> 5, jwt 4 -> 5, etc.
rm -f templates_c/*.php         # old compiled artifacts come from Smarty 4 and are incompatible
```

> Environments running PHP below 8.4 **cannot** run this branch — upgrade the runtime first.

### 2. Configure the database connection

```bash
cp config.php.template config.php
```

Edit `config.php` and fill in the required values:

```php
define('DB_HOST', 'localhost');            // Database host
define('DB_USER', 'root');                 // Database user
define('DB_PASS', '');                     // Database password
define('DB_NAME', 'sourcebans');           // Database name
define('DB_PREFIX', 'sb');                 // Table prefix
define('DB_PORT', '3306');                 // Port
define('STEAMAPIKEY', '');                 // Steam Web API key (player profiles & Steam group bans)
define('SB_NEW_SALT', '$5$');              // Password salt — change this in production
define('SB_SECRET_KEY', '');               // JWT signing secret — must be Base64-encoded
```

> ⚠️ **`SB_SECRET_KEY` must be a valid standard Base64 string.**
> The JWT library (`lcobucci/jwt 5.x`) validates it **strictly**: only `A-Z a-z 0-9 + /` are allowed, padding with `=` is required, and the decoded value must not be empty.
> A URL-safe variant (containing `-` or `_`) or an invalid length will cause a **500 error on login**.
>
> Generate a 32-byte key with:
>
> ```bash
> php -r 'echo base64_encode(random_bytes(32)), PHP_EOL;'
> ```


> 🔒 `config.php` is ignored by `.gitignore`. **Never commit it to any repository.**

### 3. Import the database

Use the database created by the official installer, or import an existing SQL dump:

```bash
gunzip -c your_backup.sql.gz | mysql -u root -p sourcebans
```

### 4. Set directory permissions

The following directories must be **writable** by the web server process:

```bash
chmod -R a+w cache templates_c demos images/maps images/games
```

### 5. Finish the installation

Open the site root in a browser and complete the setup wizard. **After installation, delete the `install/` and `updater/` directories** — the application refuses to start while they exist.

### 6. (Optional) Unified sign-in center

This branch ships an **optional SSO integration**: once the application is registered at the authentication center, add the following constants to `config.php` to enable it — sign-in then goes through the center's cross-subdomain ticket (`wy_auth` cookie) which is silently exchanged for a local JWT session. With `WYAUTH_ENABLED=false` (or the block omitted), the panel uses local credentials exclusively.

```php
define('WYAUTH_ENABLED', true);                                    // SSO switch
define('WYAUTH_API', 'https://auth.example.com/auth/api.php');     // auth-center API endpoint
define('WYAUTH_LOGIN', 'https://auth.example.com/auth/login.php'); // auth-center login page
define('WYAUTH_APP_ID', 'ban');                                    // application id (registered in the center's apps table)
define('WYAUTH_SECRET', '');                                       // application secret (must match apps.secret; never expose)
define('WYAUTH_COOKIE_NAME', 'wy_auth');                           // ticket cookie name
```

Behavior notes:

- **Admission control**: the center grants site access per group; accounts without access are not silently signed in, and the login page shows a "not enabled" notice.
- **Auto-provisioning**: an account approved at the center is **auto-provisioned on first sign-in** into the "server admin" group (kick/ban rights, no admin-panel access); its local password is random and unusable.
- **Account binding**: matched by username against existing admins; existing permission groups are **never overwritten**.
- **Entry consolidation**: once enabled, the local login form and password-recovery flow are closed; logout is global (also signs out of the center).
- **Degradation**: when the center is unreachable the login page shows a notice — there is no local-password bypass; set `WYAUTH_ENABLED` back to `false` for an emergency fallback.

> Deployment of the authentication center and the site-integration protocol are documented in its own project (register the application in `apps` + HMAC-signed API).

## Installing the Game-Server Plugin (SourceMod)

The web panel only manages data. **Your game servers need the companion SourceMod plugin installed** to talk to the panel (writing bans, syncing admins, reporting comms blocks, etc.).

This repository **ships pre-compiled plugins** under `sourcebans-pp-1.8.0.sourcemod_plugin/` — no compilation required.

### Prerequisites

Install these on the game server first:

- **MetaMod: Source** — <https://www.sourcemm.net/>
- **SourceMod >= 1.10** — <https://www.sourcemod.net/>

### Installation

1. **Copy the plugin files to the game server**

   Merge the entire `sourcebans-pp-1.8.0.sourcemod_plugin/common/addons/` directory into the game server's `addons/` directory (alongside MetaMod):

   ```bash
   # Example for CS:GO — adjust the path to your setup
   cp -r sourcebans-pp-1.8.0.sourcemod_plugin/common/addons/* \
         /path/to/game-server/csgo/addons/
   ```

   The resulting layout should be:

   ```
   addons/sourcemod/
   ├── plugins/       # sbpp_*.smx plugins
   ├── translations/  # Plugin localization strings
   └── configs/sourcebans/
       ├── sourcebans.cfg              # Core configuration
       ├── sourcecomms.cfg             # Communications-block configuration
       ├── sb_admins.cfg               # Admin accounts (generated from DB — do not edit)
       ├── sb_admin_groups.cfg         # Admin groups (generated from DB — do not edit)
       └── sourcesleuth_whitelist.cfg  # Alt-account detection whitelist
   ```

2. **Edit `sourcebans.cfg`**

   At minimum, change these two values:

   ```
   "Website"     "https://your-panel-url/"   // Site players visit to protest / view bans
   "ServerID"    "1"                         // This server's ID in the panel (see Servers page)
   ```

   Key options:

   | Option | Description |
   |---|---|
   | `Website` | Panel URL, shown to players in `sm_ban` messages |
   | `ServerID` | Server ID — **must match the server's ID in the panel**, or data won't line up |
   | `DatabasePrefix` | Table prefix; must match `DB_PREFIX` in `config.php` (default `sb`) |
   | `AutoAddServer` | Auto-register this server in the panel (`2` with RCON / `1` without RCON / `0` disabled) |
   | `EnableAdmins` | Enable the plugin's admin part (sync admins from the DB) |
   | `RequireSiteLogin` | Require admins to log into the website once |
   | `PrintCheckOnConnect` | Notify admins when a player with ban/comms history joins |
   | `BanTime` / `BanReasons` / `HackingReasons` | Ban duration presets and reason menus (localize as needed) |

3. **Provide the database credentials**

   The plugin connects to the database **directly** (not through the web panel). Edit `addons/sourcemod/configs/databases.cfg` and add:

   ```
   "sourcebans"
   {
       "driver"    "mysql"
       "host"      "your-db-host"
       "database"  "sourcebans"
       "user"      "db-user"
       "pass"      "db-password"
   }
   ```

   > ⚠️ This connection is configured **separately** from the panel's `config.php`. Both must point to the same database and table prefix.

4. **Restart the game server**, or run `sm plugins reload sbpp_main`.

### Plugin Overview

| Plugin | Purpose |
|---|---|
| `sbpp_main.smx` | Core plugin — ban DB read/write and admin sync. **Required** |
| `sbpp_comms.smx` | Communications blocks (mute/gag) backing the panel's Comms module |
| `sbpp_checker.smx` | Checks a connecting player's ban and comms-block history |
| `sbpp_admcfg.smx` | Syncs admin configuration from the database to the server |
| `sbpp_report.smx` | In-game player reporting |
| `sbpp_sleuth.smx` | Alt-account / smurf detection (uses `sourcesleuth_whitelist.cfg`) |

### Common Commands

| Command | Description |
|---|---|
| `sm_ban <player> <minutes> <reason>` | Ban a player (`0` = permanent) |
| `sm_unban <SteamID>` | Remove a ban |
| `sm_addban <minutes> <SteamID> <reason>` | Pre-ban an offline player |
| `sm_banlist` | Show the ban list |
| `sm_gag <player> <minutes> <reason>` | Gag |
| `sm_mute <player> <minutes> <reason>` | Mute |
| `sm_silence <player> <minutes> <reason>` | Gag + mute |
| `sm_ungag` / `sm_unmute` / `sm_unsilence` | Lift the corresponding block |
| `sm_rehashadmins` | Re-fetch admin config from the database |
| `sm_plugins` | Check plugin load status |

> Command access is governed by SourceMod admin flags on the server together with the panel's permission model. See the panel's Admin and Group Management pages.

### Compiling the Plugins (Optional)

The bundled `.smx` files are pre-compiled, so this is normally unnecessary. To build them yourself, see the official SourceMod guide [Compiling SourceMod Plugins](https://wiki.alliedmods.net/Compiling_SourceMod_Plugins).

## Directory Layout

```
sourcebans180/
├── index.php               # Single entry point
├── init.php                # Bootstrap: input filtering → constants → config → autoload → DB → auth → templates
├── upgrade.php             # Version upgrade entry point
├── exportbans.php          # Ban data export endpoint
├── getdemo.php             # Demo download endpoint
├── config.php.template     # Database configuration template
├── includes/               # Core libraries
│   ├── auth/               #   Session auth: JWT (lcobucci/jwt 5.x) + SSO handler (handler/)
│   ├── i18n/               #   Internationalization: Lang.php + zh_CN / en_US packs
│   ├── security/           #   Crypto utilities
│   ├── SteamID/            #   SteamID conversion and parsing
│   ├── Mail/               #   Mail delivery wrapper (Symfony Mailer)
│   ├── vendor/             #   Composer dependencies (not tracked; run composer install)
│   ├── Database.php        #   PDO wrapper (preferred for new code)
│   ├── CUserManager.php    #   User and permission management
│   ├── Config.php          #   Site settings storage
│   ├── Log.php             #   Audit logging
│   ├── sb-callback.php     #   xajax AJAX callback registration
│   └── page-builder.php    #   Routing and page assembly
├── pages/                  # Page controllers (page.* public / admin.* backend)
├── themes/                 # Smarty 5 template themes
├── configs/                # Version info and permission definitions
├── scripts/                # Front-end JS
├── images/                 # Maps, game icons, flags, static assets
├── data/                   # GeoIP database (GeoLite2)
├── demos/                  # Uploaded demo recordings
├── sourcebans-pp-1.8.0.sourcemod_plugin/   # Bundled game-server SourceMod plugin pack
│   └── common/addons/sourcemod/            #   Plugins, translations, configs (see above)
├── cache/                  # Smarty cache directory (must be writable)
└── templates_c/            # Smarty compiled templates (must be writable; clear after upgrades)
```

**Request lifecycle**:

```
index.php → init.php → includes/page-builder.php::route()
          → dispatched by ?p=<page>&c=<category>&o=<option> to a controller in pages/
          → rendered with Smarty using themes/<active-theme>/*.tpl
```

## Themes

Two themes ship with the panel; switch between them via `config.theme` in the backend settings:

- `default` — upstream default theme
- `SourceBans-Theme-Fluent-Chinese-main` — Chinese-localized Fluent-style theme (purple design system)

### Purple Design System

The Chinese theme has been reworked from the upstream blue Fluent palette into a **purple** system. All colors are centralized as CSS variables in the root token block of `style/scss/global.scss`:

| Token | Value | Usage |
|---|---|---|
| `--brand--base` | `#6f42c1` | Primary color |
| `--brand--gradient` | 3-stop purple gradient at `160deg` | Top bar, card headers, primary buttons |
| `--brand--deep` / `--brand--deepest` | `#3b2266` / `#1e1033` | Heading text, dark outlines |
| `--brand--tint` ~ `--brand--tint-3` | Light purple scale | Table headers, hover states, dividers |
| `--theme-background` | `#fcfafd` | Page background |
| `--border--radius` / `--border--radius-pill` | `8px` / `46px` | Corner radius scale |

**Dark mode** is implemented by redefining the same set of CSS variables under the `[data-theme='dark']` attribute selector, so any style that reads those variables adapts automatically — no separate override rules needed.

**Stylesheet layout** (`style/scss/`): `global.scss` is the entry point and token definition; `framework/` holds base components (buttons, tables, inputs, etc.); `__*.scss` are region-specific modules; `_*.scss` are standalone additions (context menu, messages, social icons).

### Front-end Structural Changes

- **Single merged top bar**: the `<header>` block in `core/header.tpl` has been removed. The logo, search boxes, tool icons and login state are now all rendered by `.layout_topBar` in `core/navbar.tpl` (purple gradient background).
- **Site logo**: stored in `images/logos/`, path configured via the `template.logo` setting; currently a transparent PNG with white lettering, deep-purple outline and a TF2 badge.

> After editing SCSS you must **compile manually** (see below) and clear `templates_c/`.

### Compiling Theme Styles

No system `sass` is required — compilation runs in a container:

```bash
cd themes/SourceBans-Theme-Fluent-Chinese-main/style
podman run --rm --network host -v "$PWD":/src -w /src docker.io/library/node:24-alpine \
  sh -c "npx --yes sass@1.77.8 global.scss global.css --style=expanded"
```

> ⚠️ Do **not** add `--no-source-map`: `style/global.css.map` is tracked by git, and that flag would delete it without regenerating.

If template edits don't take effect, clear the `templates_c/` directory.

## Security Recommendations

- Keep `config.php` safe and ensure it is never downloadable from a public web path.
- `SB_SECRET_KEY` must be a long random string in **standard Base64**; change `SB_NEW_SALT` (password salt) in production.
- Always serve the panel over **HTTPS** — JWT tokens and login credentials must not travel in plaintext.
- Keep PHP and dependencies up to date and watch for upstream security advisories.
- Restrict backend access to trusted administrators only; avoid exposing the admin area publicly.
- In production, disable `DEBUG_MODE`, keep `display_errors` set to `Off` and `log_errors` set to `On`.

## License

This project is a fork of SourceBans++ and retains the upstream dual license:

- **CC BY-NC-SA 3.0** — Attribution · NonCommercial · ShareAlike
- **GPL-3.0** — GNU General Public License v3

Original copyright:

- SourceBans++ (c) 2014-2023 SourceBans++ Dev Team
- SourceBans 1.4.11 (c) 2007-2014 SourceBans Team / GameConnect

## Credits

Thanks to the SourceBans++ development team and all upstream contributors. Localization and community maintenance for this fork are handled by **WenYin Community**.

For questions or bug reports, please open an [issue](https://github.com/WenYin-Community/sourcebans180/issues).
