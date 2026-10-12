<div class="layout_box flex:11 admin_tab_content tabcontent" id="Add new admin">
  {if NOT $permission_addadmin}
    <section class="error padding">
      <i class="fas fa-exclamation-circle"></i>
      <div class="error_title">糟糕，有一个问题 (╯°□°）╯︵ ┻━┻</div>

    <div class="error_content">
      拒绝访问!
    </div>

    <div class="error_code">
      错误代码: <span class="text:bold">403 禁止访问</span>
    </div>
  </section>
  {else}
  <div class="admin_tab_content_title">
    <h2><i class="fas fa-user-plus"></i>添加新管理员</h2>
  </div>

  <div class="padding">
    <div id="msg-green" class="message message:succes margin-bottom:half" style="display: none;">
      <h3>添加了管理员</h3>
      <div>新管理员已成功添加到系统中.</div>
      <div class="text:italic">重定向回到管理员页面</div>
    </div>

    <div id="add-group">
      <div class="margin-bottom:half">
        有关更多信息或有关特定主题的帮助，将鼠标移到
        问号.
      </div>

      <form class="form">
        <div class="margin-bottom:half">
          <label for="adminname" class="form-label form-label:bottom">
            管理员登录
          </label>
          <input type="text" TABINDEX=1 class="form-input form-full" id="adminname" name="adminname" />
          <div id="name.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
          <label for="steam" class="form-label form-label:bottom">
            管理员 Steam ID
          </label>
          <input type="text" TABINDEX=2 value="STEAM_0:" class="form-input form-full" id="steam" name="steam" />
          <div id="steam.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
          <label for="email" class="form-label form-label:bottom">
            管理员邮箱
          </label>

          <input type="text" TABINDEX=3 class="form-input form-full" id="email" name="email" />
          <div id="email.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
          <label for="password" class="form-label form-label:bottom">
            管理员密码
          </label>

          <input type="password" TABINDEX=4 class="form-input form-full" id="password" name="password" />

          <div class="flex margin-top:half">
            <button id="password_generate" class="button button-light button:line flex:11 margin-right:half">
              <i class="fas fa-sync"></i>生成随机密码
            </button>

            <button id="password_show" class="button button-light button:line flex:11">
              <i class="fas fa-eye"></i> 显示密码
            </button>
          </div>

          <div id="password.msg" class="message message:error margin-top:half" style="display: none;">
          </div>

          {literal}
          <script>
            document.querySelector('#password_generate').addEventListener('click', el => {
              el.preventDefault();
              xajax_generatePassword();
            });

            document.querySelector('#password_show').addEventListener('click', el => {
              el.preventDefault();
              $('password').type = 'text';
            });
          </script>
          {/literal}
        </div>

        <div class="margin-bottom:half">
          <label for="password2" class="form-label form-label:bottom">
            管理员密码（确认）
          </label>

          <input type="password" TABINDEX=5 class="form-input form-full" id="password2" name="password2" />
          <div id="password2.msg" class="message message:error margin-top:half" style="display: none;">
          </div>
        </div>

        <div class="margin-bottom:half">
          <label for="a_serverpass" class="form-label form-label:bottom">
            服务器密码
          </label>

          <input type="checkbox" id="a_useserverpass" class="form-check" name="a_useserverpass" TABINDEX=6
            onclick="$('a_serverpass').disabled = !$(this).checked;" />

          <input type="password" TABINDEX=7 class="form-input form-full" name="a_serverpass" id="a_serverpass"
            disabled="disabled" />
          <div class="form-desc">
            如果已选中此框，则需要在游戏服务器中指定此密码
            可以使用您的管理员权利.
            <a href="http://wiki.alliedmods.net/Adding_Admins_%28SourceMod%29#Passwords" rel="noopener" target="_blank"
              class="text:bold">Sourcemod密码信息</a>
          </div>

          <div id="a_serverpass.msg" class="message message:error margin-top:half" style="display: none;">
          </div>
        </div>

        <div class="margin-bottom:half">
          <h4 class="form-label">Steam 组服务器访问</h4>

          <ul class="list-reset">
            {foreach from=$group_list item="group"}
            <li class="margin-bottom:half">
              <input type="checkbox" id="group[{$group.gid}]" class="form-check" name="group[]" value="g{$group.gid}" />
              <label for="group[{$group.gid}]" class="form-label form-label:left">
                {$group.name} <span class="text:bold text:italic">(组)</span>
              </label>
            </li>
            {/foreach}
          </ul>

          <h4 class="form-label">服务器访问</h4>

          <ul class="list-reset">
            {foreach from=$server_list item="server"}
            <li class="margin-bottom:half">
              <input type="checkbox" name="servers[]" id="servers[{$server.sid}]" class="form-check"
                value="s{$server.sid}" />
              <label for="servers[{$server.sid}]" id="sa{$server.sid}" class="form-label form-label:left">
                检索主机名... {$server.ip}:{$server.port}
              </label>
            </li>
            {/foreach}
          </ul>
        </div>

        <div class="margin-bottom:half">
          <label for="serverg" class="form-label form-label:bottom">
            服务器管理员组
          </label>

          <select TABINDEX=8 onchange="update_server()" name="serverg" id="serverg" class="form-select form-full">
            <option value="-2">请选择...</option>
            <option value="-3">无权限</option>
            <option value="c">自定义权限</option>
            <option value="n">新建管理员组</option>
            <optgroup label="组" style="font-weight:bold;">
              {foreach from=$server_admin_group_list item="server_wg"}
              <option value='{$server_wg.id}'>{$server_wg.name}</option>
              {/foreach}
            </optgroup>
          </select>
          <div id="server.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
          <label for="webg" class="form-label form-label:bottom">
            网页管理员组
          </label>

          <select TABINDEX=9 onchange="update_web()" name="webg" id="webg" class="form-select form-full">
            <option value="-2">请选择...</option>
            <option value="-3">无权限</option>
            <option value="c">自定义权限</option>
            <option value="n">新建管理员组</option>
            <optgroup label="组" style="font-weight:bold;">
              {foreach from=$server_group_list item="server_g"}
              <option value='{$server_g.gid}'>{$server_g.name}</option>
              {/foreach}
            </optgroup>
          </select>
          <div id="web.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <table width="90%" border="0" style="border-collapse:collapse;" id="group.details" cellpadding="3">
          <tr>
            <td colspan="2" id="serverperm" valign="top" style="height:5px;overflow:hidden;"></td>
          </tr>
          <tr>
            <td colspan="2" id="webperm" valign="top" style="height:5px;overflow:hidden;"></td>
          </tr>
        </table>

        <div class="flex flex-jc:space-between flex-ai:center margin-top">
          {sb_button text="添加管理员" onclick="ProcessAddAdmin();" class="button button-success" id="aadmin" submit=false}
          {sb_button text="返回" onclick="history.go(-1)" class="button button-light" id="aback"}
        </div>
      </form>
      {$server_script}
    </div>
  </div>
  {/if}
</div>