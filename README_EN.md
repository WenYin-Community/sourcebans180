# SourceBans++ — WenYin Community Edition

[![License: CC BY-NC-SA 3.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%203.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/3.0/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![PHP](https://img.shields.io/badge/PHP-%3E%3D8.1-8892bf.svg)](https://www.php.net/)

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
| Admin backend | Admin, admin-group, server-access, and mod management |
| Public frontend | Multi-criteria ban-list search, player profiles, Steam quick login, account and password recovery |
| Notifications | Email delivery (ban notices, protest replies) with SMTP support |
| Misc | Demo upload/download, map thumbnails, game icons, GeoIP country lookup, audit logging |

## Requirements

- **PHP >= 8.1** (8.2+ recommended) with extensions: `pdo_mysql`, `openssl`, `mbstring`, `json`
- **MySQL / MariaDB** (5.7+ / 10.2+)
- **Composer 2.x**
- Web server: Nginx / Apache (PHP-FPM or mod_php)
- The **SourceBans++ SourceMod plugin** installed on your game servers (companion to this web panel)

## Installation

### 1. Clone and install dependencies

```bash
git clone https://github.com/WenYin-Community/sourcebans180.git
cd sourcebans180
composer install
```

> Dependencies are installed into `includes/vendor/` — the `vendor-dir` is customized in `composer.json`, not the default location.

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
define('STEAMAPIKEY', '');                 // Steam Web API key (for player profiles)
define('SB_NEW_SALT', '$5$');              // Password salt — change this in production
define('SB_SECRET_KEY', '');               // JWT signing secret — use a long random string
```

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
│   ├── auth/               #   JWT sessions + Steam OpenID login
│   ├── security/           #   Crypto utilities
│   ├── SteamID/            #   SteamID conversion and parsing
│   ├── Mail/               #   Mail delivery wrapper
│   ├── Database.php        #   PDO wrapper (preferred for new code)
│   ├── CUserManager.php    #   User and permission management
│   ├── Config.php          #   Site settings storage
│   ├── Log.php             #   Audit logging
│   ├── sb-callback.php     #   xajax AJAX callback registration
│   └── page-builder.php    #   Routing and page assembly
├── pages/                  # Page controllers (page.* public / admin.* backend)
├── themes/                 # Smarty template themes
├── configs/                # Version info and permission definitions
├── scripts/                # Front-end JS
├── images/                 # Maps, game icons, flags, static assets
├── data/                   # GeoIP database (GeoLite2)
├── demos/                  # Uploaded demo recordings
├── sourcebans-pp-1.8.0.sourcemod_plugin/   # Bundled game-server SourceMod plugin pack
│   └── common/addons/sourcemod/            #   Plugins, translations, configs (see above)
├── cache/                  # Smarty cache (must be writable)
└── templates_c/            # Smarty compiled templates (must be writable)
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
- `SourceBans-Theme-Fluent-Chinese-main` — Chinese-localized Fluent-style theme

If template edits don't take effect, clear the `templates_c/` directory.

## Security Recommendations

- Keep `config.php` safe and ensure it is never downloadable from a public web path.
- `SB_SECRET_KEY` must be a long random string; change `SB_NEW_SALT` (password salt) in production.
- Always serve the panel over **HTTPS** — JWT tokens and login credentials must not travel in plaintext.
- Keep PHP and dependencies up to date and watch for upstream security advisories.
- Restrict backend access to trusted administrators only; avoid exposing the admin area publicly.

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
