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

if (!defined("IN_SB")) {
    echo "You should not be here. Only follow links!";
    die();
}

global $userbank, $theme;
if (isset($_GET['m'])) {
    $lostpassword_url = Host::complete() . '/index.php?p=lostpassword';

    // 提示文案统一走 i18n；Lang::js() 会自动转义，保证嵌入 JS 单引号字面量不截断
    $restore_link = '<a href="' . $lostpassword_url . '">' . Lang::get('login.empty_pwd.restore') . '</a>';
    $lost_link    = '<a href="' . $lostpassword_url . '">' . Lang::get('login.failed.lost') . '</a>';

    $boxes = [
        'no_access' => [
            'title' => Lang::js('login.title.no_access'),
            'text'  => Lang::js('login.no_access'),
            'color' => 'red',
            'html'  => 'false',
        ],
        'empty_pwd' => [
            'title' => Lang::js('login.title.info'),
            'text'  => Lang::js('login.empty_pwd', ['restore' => $restore_link]),
            'color' => 'blue',
            'html'  => 'true',
        ],
        'failed' => [
            'title' => Lang::js('login.title.error'),
            'text'  => Lang::js('login.failed', ['lost' => $lost_link]),
            'color' => 'red',
            'html'  => 'false',
        ],
    ];

    if (isset($boxes[$_GET['m']])) {
        $box    = $boxes[$_GET['m']];
        $title  = $box['title'];
        $text   = $box['text'];
        $color  = $box['color'];
        $parsed = $box['html'];
        echo <<<HTML
				<script>
					ShowBox(
						'{$title}',
						'{$text}',
						'{$color}', '', {$parsed}
					);
				</script>
HTML;
    }
}

$theme->assign('redir', "DoLogin('');");
$theme->setLeftDelimiter("-{");
$theme->setRightDelimiter("}-");
$theme->display('page_login.tpl');
$theme->setLeftDelimiter("{");
$theme->setRightDelimiter("}");
