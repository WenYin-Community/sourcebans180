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
