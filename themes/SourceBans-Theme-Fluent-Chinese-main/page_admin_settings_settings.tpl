<form action="" method="post">
    <input type="hidden" name="settingsGroup" value="mainsettings" />
    <div class="admin_tab_content_title">
        <h2><i class="fas fa-cogs"></i> 主要设置</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom">
            如需了解特定主题的更多信息或帮助，请将鼠标悬停在问号上。
        </div>

        <div class="margin-bottom:half">
            <label for="template_title" class="form-label form-label:bottom">
                标题
            </label>

            <input type="text" TABINDEX=1 class="form-input form-full" id="template_title" name="template_title"
                value="{$config_title}" />

            <div class="form-desc">
                定义浏览器标题栏中显示的标题。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="template_logo" class="form-label form-label:bottom">
                标志路径
            </label>

            <input type="text" TABINDEX=2 class="form-input form-full" id="template_logo" name="template_logo"
                value="{$config_logo}" />

            <div class="form-desc">
                在此可定义新标志位置，以便使用自定义图片。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="config_password_minlength" class="form-label form-label:bottom">
                密码最小长度
            </label>

            <input type="text" TABINDEX=3 class="form-input form-full" id="config_password_minlength"
                name="config_password_minlength" value="{$config_min_password}" />

            <div class="form-desc">
                定义密码的最短长度。
            </div>

            <div id="minpasslength.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="config_dateformat" class="form-label form-label:bottom">
                日期格式 <a href="http://www.php.net/date" target="_blank" rel="noopener">参见：PHP date()</a>
            </label>

            <input type="text" TABINDEX=4 class="form-input form-full" id="config_dateformat" name="config_dateformat"
                value="{$config_dateformat}" />

            <div class="form-desc">
                在此可更改封禁列表及其他页面中显示的日期格式。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="auth_maxlife" class="form-label form-label:bottom">
                验证令牌最大有效期 <span class="text:italic">（分钟）</span>
            </label>

            <input type="text" TABINDEX=4 class="form-input form-full" id="auth_maxlife" name="auth_maxlife"
                value="{$auth_maxlife}" />

            <div class="form-desc">
                验证令牌的最大有效期。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="auth_maxlife_remember" class="form-label form-label:bottom">
                验证令牌最大有效期（记住我） <span class="text:italic">（分钟）</span>
            </label>

            <input type="text" TABINDEX=4 class="form-input form-full" id="auth_maxlife_remember"
                name="auth_maxlife_remember" value="{$auth_maxlife_remember}" />

            <div class="form-desc">
                启用"记住我"功能时验证令牌的最大有效期。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="auth_maxlife_steam" class="form-label form-label:bottom">
                验证令牌最大有效期（Steam 登录） <span class="text:italic">（分钟）</span>
            </label>


            <input type="text" TABINDEX=4 class="form-input form-full" id="auth_maxlife_steam" name="auth_maxlife_steam"
                value="{$auth_maxlife_steam}" />

            <div class="form-desc">
                <!-- Max lifetime for auth tokens via steam login. -->
                通过 steam 登录的验证令牌的最长有效时间
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=6 name="config_debug" class="form-check" id="config_debug" />

            <label for="config_debug" class="form-label form-label:left">
                <!-- Debugmode -->
                调试模式
            </label>

            <div class="form-desc">
                <!-- Check this box to enable the debugmode permanently. -->
                选中此框可永久启用调试模式
            </div>
        </div>
    </div>

    <div class="admin_tab_content_title">
        <h2><i class="fas fa-home"></i> 概览页设置</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom:half">
            <label for="dash_intro_title" class="form-label form-label:bottom">
                介绍标题
            </label>

            <input type="text" TABINDEX=7 class="form-input form-full" id="dash_intro_title" name="dash_intro_title"
                value="{$config_dash_title}" />

            <div class="form-desc">
                <!-- Set the title for the dashboard introduction. -->
                设置概览页介绍的标题
            </div>

            <div id="dash.intro.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="dash_intro_text" class="form-label form-label:bottom">
                <!-- Intro Text -->
                介绍文本
            </label>

            <textarea TABINDEX=6 cols="80" rows="20" class="form-text" id="dash_intro_text"
                name="dash_intro_text">{$config_dash_text}</textarea>

            <div class="form-desc">
                <!-- Set the text for the dashboard introduction. -->
                设置概览页介绍的文本
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=8 name="dash_nopopup" class="form-check" id="dash_nopopup" />

            <label for="dash_nopopup" class="form-label form-label:left">
                <!-- Disable Log Popup -->
                禁用日志弹出
            </label>

            <div class="form-desc">
                <!-- Check this box to disable the log info popup and use direct link. -->
                选中此框可禁用日志信息弹出，并使用直接链接
            </div>
        </div>
    </div>

    <div class="admin_tab_content_title">
        <h2><i class="fas fa-sliders-h"></i> 页面设置</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=9 name="enable_protest" class="form-check" id="enable_protest" />

            <label for="enable_protest" class="form-label form-label:left">
                启用抗议封禁
            </label>

            <div class="form-desc">
                <!-- Check this box to enable the protest ban page. -->
                选中此框以启用抗议封禁页面
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=10 name="enable_submit" class="form-check" id="enable_submit" />

            <label for="enable_submit" class="form-label form-label:left">
                <!-- Enable Submit Ban -->
                启用申请封禁
            </label>

            <div class="form-desc">
                <!-- Check this box to enable the submit ban page. -->
                选中此框以启用申请封禁玩家页面
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=10 name="enable_commslist" class="form-check" id="enable_commslist" />

            <label for="enable_commslist" class="form-label form-label:left">
                启用禁言名单
            </label>

            <div class="form-desc">
                <!-- Check this box to enable the commslist page. -->
                选中此框以启用禁言名单页面
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=9 name="protest_emailonlyinvolved" class="form-check"
                id="protest_emailonlyinvolved" />

            <label for="protest_emailonlyinvolved" class="form-label form-label:left">
                仅发送一封邮件
            </label>

            <div class="form-desc">
                选中此框仅向封禁申诉玩家的管理员发送申诉通知邮件。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="default_page" class="form-label form-label:bottom">
                默认页面
            </label>

            <select class="form-select form-full" TABINDEX=11 name="default_page" id="default_page">
                <option value="0">首页</option>
                <option value="1">封禁名单</option>
                <option value="2">服务器列表</option>
                <option value="3">提交封禁</option>
                <option value="4">解除封禁</option>
            </select>

            <div class="form-desc">
                选择用户首次访问时显示的页面。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="clearcache" class="form-label form-label:bottom">
                清除缓存
            </label>

            {sb_button text="清除缓存" onclick="xajax_ClearCache();" class="button button-light" id="clearcache" submit=false}

            <div class="form-desc">
                点击此按钮可清理缓存文件夹。
            </div>

            <div id="clearcache.msg"></div>
        </div>
    </div>

    <div class="admin_tab_content_title">
        <h2><i class="fas fa-ban"></i> 封禁列表设置</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom:half">
            <label for="banlist_bansperpage" class="form-label form-label:bottom">
                每页项目数
            </label>

            <input type="text" TABINDEX=12 class="form-input form-full" id="banlist_bansperpage"
                name="banlist_bansperpage" value="{$config_bans_per_page}" />

            <div class="form-desc">
                选择每页显示的项目数量。
            </div>

            <div id="bansperpage.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=13 name="banlist_hideadmname" class="form-check" id="banlist_hideadmname" />

            <label for="banlist_hideadmname" class="form-label form-label:left">
                隐藏管理员姓名
            </label>

            <div class="form-desc">
                选中此框可在封禁信息中隐藏管理员姓名。
            </div>

            <div id="banlist_hideadmname.msg" class="message message:error margin-top:half" style="display: none;">
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=14 name="banlist_nocountryfetch" class="form-check"
                id="banlist_nocountryfetch" />

            <label for="banlist_nocountryfetch" class="form-label form-label:left">
                不查询国家信息
            </label>

            <div class="form-desc">
                选中此框可在封禁列表中不显示 IP 对应的国家。如果遇到显示问题可使用此选项。
            </div>

            <div id="banlist_nocountryfetch.msg" class="message message:error margin-top:half" style="display: none;">
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=15 name="banlist_hideplayerips" class="form-check"
                id="banlist_hideplayerips" />

            <label for="banlist_hideplayerips" class="form-label form-label:left">
                隐藏玩家 IP
            </label>

            <div class="form-desc">
                选中此可从公众视野中隐藏玩家 IP。
            </div>

            <div id="banlist_hideplayerips.msg" class="message message:error margin-top:half" style="display: none;">
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="banlist_hideplayerips" class="form-label form-label:right">
                自定义封禁原因
            </label>

            <table width="100%" border="0" style="border-collapse:collapse;" id="custom.reasons" name="custom.reasons">
                {foreach from=$bans_customreason item="creason"}
                    <tr>
                        <td><input type="text" class="textbox" name="bans_customreason[]" id="bans_customreason[]"
                                value="{$creason}" /></td>
                    </tr>
                {/foreach}
                <tr>
                    <td><input type="text" class="textbox" name="bans_customreason[]" id="bans_customreason[]" /></td>
                </tr>
                <tr>
                    <td><input type="text" class="textbox" name="bans_customreason[]" id="bans_customreason[]" /></td>
                </tr>
            </table>
            <a href="javascript:void(0)" onclick="MoreFields();" title="添加更多字段">[+]</a>

            <div class="form-desc">
                输入您希望在下拉菜单中显示的自定义封禁原因。
            </div>

            <div id="bans_customreason.msg" class="message message:error margin-top:half" style="display: none;">
            </div>
        </div>
    </div>

	<div class="admin_tab_content_title">
        <h2><i class="fa-solid fa-paper-plane"></i></i> 邮件设置</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom">
            如果留空，邮件功能将无法工作并返回错误 500。
        </div>

        <div class="margin-bottom:half">
            <label for="mail_host" class="form-label form-label:bottom">
                主机
            </label>

            <input type="text" TABINDEX=16 class="form-input form-full" id="mail_host" name="mail_host"
                value="{$config_smtp[0]}" />

            <div class="form-desc">
                输入您的主机地址。
            </div>

			<div id="mailhost.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="mail_user" class="form-label form-label:bottom">
                用户名
            </label>

            <input type="text" TABINDEX=17 class="form-input form-full" id="mail_user" name="mail_user"
                value="{$config_smtp[1]}" />

            <div class="form-desc">
                输入您的用户名。
            </div>

			<div id="mail_user.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="mail_pass" class="form-label form-label:bottom">
                密码
            </label>

            <input type="text" TABINDEX=18 class="form-input form-full" id="mail_pass"
                name="mail_pass" placeholder="*******" />

            <div class="form-desc">
                输入您的密码。
            </div>

            <div id="mail_pass.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

		<div class="margin-bottom:half">
            <label for="mail_port" class="form-label form-label:bottom">
                端口
            </label>

            <input type="text" TABINDEX=19 class="form-input form-full" id="mail_port"
                name="mail_port" value="{$config_smtp[2]}" />

            <div class="form-desc">
                输入使用的端口。
            </div>

            <div id="mail_port.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

		<div class="margin-bottom:half">
			<input type="checkbox" TABINDEX=20 name="mail_verify_peer" class="form-check" id="mail_verify_peer" />

            <label for="mail_verify_peer" class="form-label form-label:bottom">
                验证 SSL 证书
            </label>

            <div class="form-desc">
                需要验证所使用的 SSL 证书。
            </div>

            <div id="mail_verify_peer.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

    </div>

    <div class="padding flex flex-ai:center flex-jc:space-between">
        {sb_button text="保存更改" class="button button-success" id="asettings" submit=true}
        {sb_button text="返回" class="button button-light" id="aback"}
    </div>
</form>
<script type="text/javascript" src="./includes/tinymce/tinymce.min.js"></script>
{literal}
    <script language="javascript" type="text/javascript">
        tinyMCE.init({
            selector: "textarea",
            height: 500,
            theme : "silver",
            plugins : "advlist, autolink, lists, link, image, charmap, print, preview, hr, anchor, pagebreak, searchreplace, wordcount, visualblocks, visualchars, code, fullscreen, insertdatetime, media, nonbreaking, save, table, directionality, emoticons, template, paste, textpattern, imagetools, codesample, toc",
            extended_valid_elements : "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
        });
    </script>
{/literal}
