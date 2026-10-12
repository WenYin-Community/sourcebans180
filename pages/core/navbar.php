<?php
global $userbank, $theme;

$navbar = [
     [
        'title' => Lang::get('nav.dashboard'),
        'endpoint' => 'home',
        'description' => Lang::get('nav.dashboard.desc'),
        'permission' => true
    ],
    [
        'title' => Lang::get('nav.servers'),
        'endpoint' => 'servers',
        'description' => Lang::get('nav.servers.desc'),
        'permission' => true
    ],
    [
        'title' => Lang::get('nav.bans'),
        'endpoint' => 'banlist',
        'description' => Lang::get('nav.bans.desc'),
        'permission' => true
    ],
    [
        'title' => Lang::get('nav.comms'),
        'endpoint' => 'commslist',
        'description' => Lang::get('nav.comms.desc'),
        'permission' => Config::getBool('config.enablecomms')
    ],
    [
        'title' => Lang::get('nav.report'),
        'endpoint' => 'submit',
        'description' => Lang::get('nav.report.desc'),
        'permission' => Config::getBool('config.enablesubmit')
    ],
    [
        'title' => Lang::get('nav.appeal'),
        'endpoint' => 'protest',
        'description' => Lang::get('nav.appeal.desc'),
        'permission' => Config::getBool('config.enableprotest')
    ],
    [
        'title' => Lang::get('nav.admin'),
        'endpoint' => 'admin',
        'description' => Lang::get('nav.admin.desc'),
        'permission' => $userbank->is_admin()
    ]
];

$admin = [
    [
        'title' => Lang::get('nav.admins'),
        'endpoint' => 'admins',
        'permission' => ADMIN_OWNER|ADMIN_LIST_ADMINS|ADMIN_ADD_ADMINS|ADMIN_EDIT_ADMINS|ADMIN_DELETE_ADMINS
    ],
    [
        'title' => Lang::get('nav.servers'),
        'endpoint' => 'servers',
        'permission' => ADMIN_OWNER|ADMIN_LIST_SERVERS|ADMIN_ADD_SERVER|ADMIN_EDIT_SERVERS|ADMIN_DELETE_SERVERS
    ],
    [
        'title' => Lang::get('nav.bans'),
        'endpoint' => 'bans',
        'permission' => ADMIN_OWNER|ADMIN_ADD_BAN|ADMIN_EDIT_OWN_BANS|ADMIN_EDIT_GROUP_BANS|ADMIN_EDIT_ALL_BANS|ADMIN_BAN_PROTESTS|ADMIN_BAN_SUBMISSIONS
    ],
    [
        'title' => Lang::get('nav.comms'),
        'endpoint' => 'comms',
        'permission' => ADMIN_OWNER|ADMIN_ADD_BAN|ADMIN_EDIT_OWN_BANS|ADMIN_EDIT_ALL_BANS
    ],
    [
        'title' => Lang::get('nav.groups'),
        'endpoint' => 'groups',
        'permission' => ADMIN_OWNER|ADMIN_LIST_GROUPS|ADMIN_ADD_GROUP|ADMIN_EDIT_GROUPS|ADMIN_DELETE_GROUPS
    ],
    [
        'title' => Lang::get('nav.settings'),
        'endpoint' => 'settings',
        'permission' => ADMIN_OWNER|ADMIN_WEB_SETTINGS
    ],
    [
        'title' => Lang::get('nav.mods'),
        'endpoint' => 'mods',
        'permission' => ADMIN_OWNER|ADMIN_LIST_MODS|ADMIN_ADD_MODS|ADMIN_EDIT_MODS|ADMIN_DELETE_MODS
    ]
];

$active = filter_input(INPUT_GET, 'p', FILTER_SANITIZE_SPECIAL_CHARS);
foreach ($navbar as $key => $tab) {
    $navbar[$key]['state'] = ($active === $tab['endpoint']) ? 'active' : 'nonactive';

    if (!$tab['permission']) {
        unset($navbar[$key]);
    }
}

if ($userbank->is_admin()) {
    $cat = filter_input(INPUT_GET, 'c', FILTER_SANITIZE_SPECIAL_CHARS);
    foreach ($admin as $key => $tab) {
        $admin[$key]['state'] = ($cat === $tab['endpoint']) ? 'active' : '';

        if (!$userbank->HasAccess($tab['permission'])) {
            unset($admin[$key]);
        }
    }
}

$theme->assign('navbar', array_values($navbar));
$theme->assign('adminbar', array_values($admin));
$theme->assign('isAdmin', $userbank->is_admin());
$theme->assign('login', $userbank->is_logged_in());
$theme->assign('username', $userbank->GetProperty("user"));
$theme->display('core/navbar.tpl');
