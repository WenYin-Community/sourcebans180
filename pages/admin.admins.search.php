<?php
/*************************************************************************
This file is part of SourceBans++

SourceBans++ (c) 2014-2023 by SourceBans++ Dev Team

The SourceBans++ Web panel is licensed under a
Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

You should have received a copy of the license along with this
work.  If not, see <http://creativecommons.org/licenses/by-nc-sa/3.0/>.

This program is based off work covered by the following copyright(s):
SourceBans 1.4.11
Copyright © 2007-2014 SourceBans Team - Part of GameConnect
Licensed under CC-BY-NC-SA 3.0
Page: <http://www.sourcebans.net/> - <http://www.gameconnect.net/>
*************************************************************************/

global $userbank, $theme;

//serverlist
$server_list  = $GLOBALS['db']->Execute("SELECT sid, ip, port FROM `" . DB_PREFIX . "_servers` WHERE enabled = 1");
$servers      = [];
$serverscript = "<script type=\"text/javascript\">";
while (!$server_list->EOF) {
    $info = [];
    $serverscript .= "xajax_ServerHostPlayers('" . $server_list->fields[0] . "', 'id', 'ss" . $server_list->fields[0] . "', '', '', false, 200);";
    $info['sid']  = $server_list->fields[0];
    $info['ip']   = $server_list->fields[1];
    $info['port'] = $server_list->fields[2];
    array_push($servers, $info);
    $server_list->MoveNext();
}
$serverscript .= "</script>";

//webgrouplist
$webgroup_list = $GLOBALS['db']->Execute("SELECT gid, name FROM " . DB_PREFIX . "_groups WHERE type = '1'");
$webgroups     = [];
while (!$webgroup_list->EOF) {
    $data         = [];
    $data['gid']  = $webgroup_list->fields['gid'];
    $data['name'] = $webgroup_list->fields['name'];

    array_push($webgroups, $data);
    $webgroup_list->MoveNext();
}

//serveradmingrouplist
$srvadmgroup_list = $GLOBALS['db']->Execute("SELECT name FROM " . DB_PREFIX . "_srvgroups ORDER BY name ASC");
$srvadmgroups     = [];
while (!$srvadmgroup_list->EOF) {
    $data         = [];
    $data['name'] = $srvadmgroup_list->fields['name'];

    array_push($srvadmgroups, $data);
    $srvadmgroup_list->MoveNext();
}

//servergroup
$srvgroup_list = $GLOBALS['db']->Execute("SELECT gid, name FROM " . DB_PREFIX . "_groups WHERE type = '3'");
$srvgroups     = [];
while (!$srvgroup_list->EOF) {
    $data         = [];
    $data['gid']  = $srvgroup_list->fields['gid'];
    $data['name'] = $srvgroup_list->fields['name'];

    array_push($srvgroups, $data);
    $srvgroup_list->MoveNext();
}

//webpermissions
$webflag[] = array(
    "name" => "Root Admin",
    "flag" => "ADMIN_OWNER"
);
$webflag[] = array(
    "name" => "View admins",
    "flag" => "ADMIN_LIST_ADMINS"
);
$webflag[] = array(
    "name" => "添加管理员",
    "flag" => "ADMIN_ADD_ADMINS"
);
$webflag[] = array(
    "name" => "编辑管理员",
    "flag" => "ADMIN_EDIT_ADMINS"
);
$webflag[] = array(
    "name" => "删除管理员",
    "flag" => "ADMIN_DELETE_ADMINS"
);
$webflag[] = array(
    "name" => "查看服务器",
    "flag" => "ADMIN_LIST_SERVERS"
);
$webflag[] = array(
    "name" => "添加服务器",
    "flag" => "ADMIN_ADD_SERVER"
);
$webflag[] = array(
    "name" => "编辑服务器",
    "flag" => "ADMIN_EDIT_SERVERS"
);
$webflag[] = array(
    "name" => "删除服务器",
    "flag" => "ADMIN_DELETE_SERVERS"
);
$webflag[] = array(
    "name" => "添加封禁",
    "flag" => "ADMIN_ADD_BAN"
);
$webflag[] = array(
    "name" => "编辑自己的封禁",
    "flag" => "ADMIN_EDIT_OWN_BANS"
);
$webflag[] = array(
    "name" => "编辑用户组的封禁",
    "flag" => "ADMIN_EDIT_GROUP_BANS"
);
$webflag[] = array(
    "name" => "编辑所有封禁",
    "flag" => "ADMIN_EDIT_ALL_BANS"
);
$webflag[] = array(
    "name" => "封禁申诉",
    "flag" => "ADMIN_BAN_PROTESTS"
);
$webflag[] = array(
    "name" => "封禁提交",
    "flag" => "ADMIN_BAN_SUBMISSIONS"
);
$webflag[] = array(
    "name" => "删除封禁",
    "flag" => "ADMIN_DELETE_BAN"
);
$webflag[] = array(
    "name" => "解除自己的封禁",
    "flag" => "ADMIN_UNBAN_OWN_BANS"
);
$webflag[] = array(
    "name" => "解除用户组的封禁",
    "flag" => "ADMIN_UNBAN_GROUP_BANS"
);
$webflag[] = array(
    "name" => "解除所有封禁",
    "flag" => "ADMIN_UNBAN"
);
$webflag[] = array(
    "name" => "导入封禁",
    "flag" => "ADMIN_BAN_IMPORT"
);
$webflag[] = array(
    "name" => "提交邮件通知",
    "flag" => "ADMIN_NOTIFY_SUB"
);
$webflag[] = array(
    "name" => "申诉邮件通知",
    "flag" => "ADMIN_NOTIFY_PROTEST"
);
$webflag[] = array(
    "name" => "查看用户组",
    "flag" => "ADMIN_LIST_GROUPS"
);
$webflag[] = array(
    "name" => "添加用户组",
    "flag" => "ADMIN_ADD_GROUP"
);
$webflag[] = array(
    "name" => "编辑用户组",
    "flag" => "ADMIN_EDIT_GROUPS"
);
$webflag[] = array(
    "name" => "删除用户组",
    "flag" => "ADMIN_DELETE_GROUPS"
);
$webflag[] = array(
    "name" => "网页设置",
    "flag" => "ADMIN_WEB_SETTINGS"
);
$webflag[] = array(
    "name" => "查看模组",
    "flag" => "ADMIN_LIST_MODS"
);
$webflag[] = array(
    "name" => "添加模组",
    "flag" => "ADMIN_ADD_MODS"
);
$webflag[] = array(
    "name" => "编辑模组",
    "flag" => "ADMIN_EDIT_MODS"
);
$webflag[] = array(
    "name" => "删除模组",
    "flag" => "ADMIN_DELETE_MODS"
);
$webflags  = [];
foreach ($webflag as $flag) {
    $data['name'] = $flag["name"];
    $data['flag'] = $flag["flag"];

    array_push($webflags, $data);
}

//server permissions
$serverflag[] = array(
    "name" => "完全管理员",
    "flag" => "SM_ROOT"
);
$serverflag[] = array(
    "name" => "保留通道",
    "flag" => "SM_RESERVED_SLOT"
);
$serverflag[] = array(
    "name" => "通用管理",
    "flag" => "SM_GENERIC"
);
$serverflag[] = array(
    "name" => "Kick",
    "flag" => "SM_KICK"
);
$serverflag[] = array(
    "name" => "Ban",
    "flag" => "SM_BAN"
);
$serverflag[] = array(
    "name" => "解封",
    "flag" => "SM_UNBAN"
);
$serverflag[] = array(
    "name" => "Slay",
    "flag" => "SM_SLAY"
);
$serverflag[] = array(
    "name" => "更换地图",
    "flag" => "SM_MAP"
);
$serverflag[] = array(
    "name" => "修改 ConVar",
    "flag" => "SM_CVAR"
);
$serverflag[] = array(
    "name" => "执行配置文件",
    "flag" => "SM_CONFIG"
);
$serverflag[] = array(
    "name" => "管理员聊天",
    "flag" => "SM_CHAT"
);
$serverflag[] = array(
    "name" => "发起投票",
    "flag" => "SM_VOTE"
);
$serverflag[] = array(
    "name" => "服务器加密码",
    "flag" => "SM_PASSWORD"
);
$serverflag[] = array(
    "name" => "RCON",
    "flag" => "SM_RCON"
);
$serverflag[] = array(
    "name" => "启用作弊",
    "flag" => "SM_CHEATS"
);
$serverflag[] = array(
    "name" => "自定义标志位 1",
    "flag" => "SM_CUSTOM1"
);
$serverflag[] = array(
    "name" => "自定义标志位 2",
    "flag" => "SM_CUSTOM2"
);
$serverflag[] = array(
    "name" => "自定义标志位 3",
    "flag" => "SM_CUSTOM3"
);
$serverflag[] = array(
    "name" => "自定义标志位 4",
    "flag" => "SM_CUSTOM4"
);
$serverflag[] = array(
    "name" => "自定义标志位 5",
    "flag" => "SM_CUSTOM5"
);
$serverflag[] = array(
    "name" => "自定义标志位 6",
    "flag" => "SM_CUSTOM6"
);
$serverflags  = [];
foreach ($serverflag as $flag) {
    $data['name'] = $flag["name"];
    $data['flag'] = $flag["flag"];

    array_push($serverflags, $data);
}


$theme->assign('server_list', $servers);
$theme->assign('server_script', $serverscript);
$theme->assign('webgroup_list', $webgroups);
$theme->assign('srvadmgroup_list', $srvadmgroups);
$theme->assign('srvgroup_list', $srvgroups);
$theme->assign('admwebflag_list', $webflags);
$theme->assign('admsrvflag_list', $serverflags);
$theme->assign('can_editadmin', $userbank->HasAccess(ADMIN_EDIT_ADMINS | ADMIN_OWNER));

$theme->display('box_admin_admins_search.tpl');
