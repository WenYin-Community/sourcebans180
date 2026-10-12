{if NOT $permission_import}
    <section class="error padding">
        <i class="fas fa-exclamation-circle"></i>
        <div class="error_title">哎呀，出了点问题 (╯°□°）╯︵ ┻━┻</div>

        <div class="error_content">
            拒绝访问！
        </div>

        <div class="error_code">
            错误代码：<span class="text:bold">403 禁止访问</span>
        </div>
    </section>
{else}
    {if NOT $groupbanning_enabled}
        <section class="error padding">
            <i class="fas fa-exclamation-circle"></i>
            <div class="error_title">哎呀，出了点问题 (╯°□°）╯︵ ┻━┻</div>

            <div class="error_content">
                此功能已禁用！<br />
                拒绝访问！
            </div>

            <div class="error_code">
                错误代码：<span class="text:bold">423 已锁定</span>
            </div>
        </section>
    {else}
        <div class="admin_tab_content_title">
            <h2><i class="fa-solid fa-people-group"></i> 添加组封禁</h2>
        </div>

        <div class="padding">
            <div class="margin-bottom">
                {if NOT $list_steam_groups}
                    <div class="margin-bottom">
                        在此您可以为整个 Steam 社区组添加封禁。<br />
                        例如：<code>http://steamcommunity.com/groups/interwavestudios</code>
                    </div>
                    <table width="90%" style="border-collapse:collapse;" id="group.details" cellpadding="3">
                        <tr>
                            <td valign="top" width="35%">
                                <div class="rowdesc">
                                    {help_icon title="组链接" message="输入 Steam 社区组的链接。"}组链接
                                </div>
                            </td>
                            <td>
                                <div align="left">
                                    <input type="text" TABINDEX=1 class="textbox" id="groupurl" name="groupurl" style="width: 229px" />
                                </div>
                                <div id="groupurl.msg" class="badentry"></div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" width="35%">
                                <div class="rowdesc">
                                    {help_icon title="组封禁原因" message="输入您要封禁此 Steam 社区组的原因。"}组
                                    封禁原因
                                </div>
                            </td>
                            <td>
                                <div align="left">
                                    <textarea class="textbox" TABINDEX=2 cols="30" rows="5" id="groupreason"
                                        name="groupreason" /></textarea>
                                </div>
                                <div id="groupreason.msg" class="badentry"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                {sb_button text="添加组封禁" onclick="ProcessGroupBan();" class="ok" id="agban" submit=false}
                                &nbsp;
                                {sb_button text="返回" onclick="history.go(-1)" class="cancel" id="aback"}
                            </td>
                        </tr>
                    </table>
                    {else}
                        玩家 {$player_name} 所属的所有组都列在这里。<br />
                        选择您要封禁的 Steam 组。<br /><br />
                        <div id="steamGroupsText" name="steamGroupsText">正在加载组...</div>
                        <div id="steamGroups" name="steamGroups" style="display:none;">
                            <table id="steamGroupsTable" name="steamGroupsTable" border="0" width="500px">
                                <tr>
                                    <td height="16" class="listtable_1" style="padding:0px;width:3px;" align="center">
                                        <div class="ok" style="height:16px;width:16px;cursor:pointer;" id="tickswitch" name="tickswitch"
                                            onclick="TickSelectAll();"></div>
                                    </td>
                                    <td height="16" class="listtable_top" align="center"><b>组</b></td>
                                </tr>
                            </table>
                            &nbsp;&nbsp;L&nbsp;&nbsp;<a href="#" onclick="TickSelectAll();return false;" title="全选"
                                name="tickswitchlink" id="tickswitchlink">全选</a><br /><br />
                            <table width="90%" style="border-collapse:collapse;" id="group.details" cellpadding="3">
                                <tr>
                                    <td valign="top" width="35%">
                                        <div class="rowdesc">
                                            {help_icon title="组封禁理由" message="输入您要对这个 Steam 社区群组进行封禁的理由。"}组
                                            封禁理由
                                        </div>
                                    </td>
                                    <td>
                                        <div align="left">
                                            <textarea class="submit-fields" TABINDEX=2 cols="30" rows="5" id="groupreason"
                                                name="groupreason" /></textarea>
                                        </div>
                                        <div id="groupreason.msg" class="badentry"></div>
                                    </td>
                                </tr>
                            </table>
                            <input type="button" class="btn ok" onclick="CheckGroupBan();" name="gban" id="gban"
                                onmouseover="ButtonOver('gban');" onmouseout="ButtonOver('gban');" value="添加组封禁">
                        </div>
                        <div id="steamGroupStatus" name="steamGroupStatus" width="100%"></div>
                        <script type="text/javascript">
                            $('tickswitch').value = 0;xajax_GetGroups('{$list_steam_groups}');
                        </script>
                {/if}
            </div>
        </div>
    {/if}
{/if}
