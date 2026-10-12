<?php

/**
 * @param $fallback
 * @return array
 * @throws ErrorException
 */
function route($fallback)
{
    $page = filter_input(INPUT_GET, 'p', FILTER_SANITIZE_SPECIAL_CHARS);
    $categorie = filter_input(INPUT_GET, 'c', FILTER_SANITIZE_SPECIAL_CHARS);
    $option = filter_input(INPUT_GET, 'o', FILTER_SANITIZE_SPECIAL_CHARS);

    switch ($page) {
        case 'login':
            return [Lang::get('page.login'), '/page.login.php'];
        case 'logout':
            Auth::logout();
            if (defined('WYAUTH_ENABLED') && WYAUTH_ENABLED) {
                // 统一认证模式：跳中心 logout（撤销票据 + 清 wy_auth Cookie）
                WyAuthHandler::logoutRedirect();
            }
            header('Location: index.php?p=home');
            exit();
        case 'submit':
            return [Lang::get('page.submit'), '/page.submit.php'];
        case 'banlist':
            return [Lang::get('page.banlist'), '/page.banlist.php'];
        case 'commslist':
            return [Lang::get('page.commslist'), '/page.commslist.php'];
        case 'servers':
            return [Lang::get('page.servers'), '/page.servers.php'];
        case 'protest':
            return [Lang::get('page.protest'), '/page.protest.php'];
        case 'account':
            return [Lang::get('page.account'), '/page.youraccount.php'];
        case 'lostpassword':
            return [Lang::get('page.lostpassword'), '/page.lostpassword.php'];
        case 'home':
            return [Lang::get('page.dashboard'), '/page.home.php'];
        case 'admin':
            // 管理面板只对"网页管理组"开放；服务器管理组不得进入
            CheckWebAdminAccess();
            switch ($categorie) {
                case 'groups':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_LIST_GROUPS|ADMIN_ADD_GROUP|ADMIN_EDIT_GROUPS|ADMIN_DELETE_GROUPS);
                    switch ($option) {
                        case 'edit':
                            return [Lang::get('admin.groups.edit'), '/admin.edit.group.php'];
                        default:
                            return [Lang::get('admin.groups.manage'), '/admin.groups.php'];
                    }
                case 'admins':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_LIST_ADMINS|ADMIN_ADD_ADMINS|ADMIN_EDIT_ADMINS|ADMIN_DELETE_ADMINS);
                    switch ($option) {
                        case 'editgroup':
                            return [Lang::get('admin.admins.editgroup'), '/admin.edit.admingroup.php'];
                        case 'editdetails':
                            return [Lang::get('admin.admins.editdetails'), '/admin.edit.admindetails.php'];
                        case 'editpermissions':
                            return [Lang::get('admin.admins.editperms'), '/admin.edit.adminperms.php'];
                        case 'editservers':
                            return [Lang::get('admin.admins.editservers'), '/admin.edit.adminservers.php'];
                        default:
                            return [Lang::get('admin.admins.manage'), '/admin.admins.php'];
                    }
                case 'servers':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_LIST_SERVERS|ADMIN_ADD_SERVER|ADMIN_EDIT_SERVERS|ADMIN_DELETE_SERVERS);
                    switch ($option) {
                        case 'edit':
                            return [Lang::get('admin.servers.edit'), '/admin.edit.server.php'];
                        case 'rcon':
                            return [Lang::get('admin.servers.rcon'), '/admin.rcon.php'];
                        case 'admincheck':
                            return [Lang::get('admin.servers.admins'), '/admin.srvadmins.php'];
                        default:
                            return [Lang::get('admin.servers.manage'), '/admin.servers.php'];
                    }
                case 'bans':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_ADD_BAN|ADMIN_EDIT_OWN_BANS|ADMIN_EDIT_GROUP_BANS|ADMIN_EDIT_ALL_BANS|ADMIN_BAN_PROTESTS|ADMIN_BAN_SUBMISSIONS);
                    switch ($option) {
                        case 'edit':
                            return [Lang::get('admin.bans.edit'), '/admin.edit.ban.php'];
                        case 'email':
                            return [Lang::get('admin.bans.email'), '/admin.email.php'];
                        default:
                            return [Lang::get('admin.bans.manage'), '/admin.bans.php'];
                    }
                case 'comms':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_ADD_BAN|ADMIN_EDIT_OWN_BANS|ADMIN_EDIT_ALL_BANS);
                    switch ($option) {
                        case 'edit':
                            return [Lang::get('admin.comms.edit'), '/admin.edit.comms.php'];
                        default:
                            return [Lang::get('admin.comms.manage'), '/admin.comms.php'];
                    }
                case 'mods':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_LIST_MODS|ADMIN_ADD_MODS|ADMIN_EDIT_MODS|ADMIN_DELETE_MODS);
                    switch ($option) {
                        case 'edit':
                            return [Lang::get('admin.mods.edit'), '/admin.edit.mod.php'];
                        default:
                            return [Lang::get('admin.mods.manage'), '/admin.mods.php'];
                    }
                case 'settings':
                    CheckAdminAccess(ADMIN_OWNER|ADMIN_WEB_SETTINGS);
                    return [Lang::get('admin.settings'), '/admin.settings.php'];
                default:
                    CheckAdminAccess(ALL_WEB);
                    return [Lang::get('admin.administration'), '/page.admin.php'];
        }
        default:
            switch ($fallback) {
                case 1:
                    $_GET['p'] = 'banlist';
                    return [Lang::get('page.banlist'), '/page.banlist.php'];
                case 2:
                    $_GET['p'] = 'servers';
                    return [Lang::get('page.serverinfo'), '/page.servers.php'];
                case 3:
                    $_GET['p'] = 'submit';
                    return [Lang::get('page.submit'), '/page.submit.php'];
                case 4:
                    $_GET['p'] = 'protest';
                    return [Lang::get('page.protest'), '/page.protest.php'];
                default:
                    $_GET['p'] = 'home';
                    return [Lang::get('page.dashboard'), '/page.home.php'];
            }
    }
}

/**
 * @param null $title Unused
 * @param string $page
 */
function build(string $title, string $page)
{
    require_once(TEMPLATES_PATH.'/core/header.php');
    require_once(TEMPLATES_PATH.'/core/navbar.php');
    require_once(TEMPLATES_PATH.'/core/title.php');
    require_once(TEMPLATES_PATH.$page);
    require_once(TEMPLATES_PATH.'/core/footer.php');
}
