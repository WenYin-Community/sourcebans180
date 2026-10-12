{if NOT $permission_protests}
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
    <div class="admin_tab_content_title">
        <h2><i class="fas fa-gavel"></i> 封禁举报 (<span id="subcount">{$submission_count}</span>)</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom">
            点击玩家昵称可查看举报详细信息。
        </div>

        <div class="pagination">
            <span>{$submission_nav}</span>
        </div>

        <div class="table table_box">
            <table>
                <thead>
                    <tr>
                        <th class="text:left">昵称</th>
                        <th class="text:left">Steam ID</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$submission_list item="sub"}
                        <tr class="collapse" {if $sub.hostname == ""}
                            onclick="xajax_ServerHostPlayers('{$sub.server}', 'id', 'sub{$sub.subid}');" {/if}>
                            <td>
                                {$sub.name}
                            </td>
                            <td>
                                {if $sub.SteamId!=""}
                                    {$sub.SteamId}
                                {else}
                                    {$sub.sip}
                                {/if}
                            </td>
                            <td class="flex flex-jc:center flex-ai:center">
                                <button class="button button-important margin-right:half"
                                    onclick="xajax_SetupBan({$sub.subid});return false;">
                                    封禁
                                </button>

                                <a href="index.php?p=admin&c=bans&o=email&type=s&id={$sub.subid}"
                                    class="button button-primary margin-right:half">
                                    联系
                                </a>

                                {if $permissions_editsub}
                                    <button class="button button-success margin-right:half"
                                        onclick="RemoveSubmission({$sub.subid}, '{$sub.name|smarty_stripslashes}', '1');return false;">
                                        归档
                                    </button>
                                {/if}

                            </td>
                        </tr>

                        <tr class="table_hide">
                            <td colspan="3">
                                <div class="collapse_content">
                                    <div class="padding flex flex-jc:start">
                                        <ul class="ban_action">
                                            <li class="button button-light">
                                                {$sub.demo}
                                            </li>
                                            <li class="button button-success">
                                                {$sub.subaddcomment}
                                            </li>
                                        </ul>

                                        <ul class="ban_list_detal">
                                            <li>
                                                <span><i class="fa-solid fa-user"></i> 玩家</span>
                                                <span>
                                                    {$sub.name}
                                                </span>
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-play"></i> 提交时间</span>
                                                <span>
                                                    {$sub.submitted}
                                                </span>
                                            </li>

                                            <li>
                                                <span><i class="fa-brands fa-steam"></i> Steam ID</span>
                                                {if $sub.SteamId == ""}
                                                    <span class="text:italic">无 Steam ID</span>
                                                {else}
                                                    <a href="https://www.steamidfinder.com/lookup/{$sub.SteamId}" target="_blank" rel="noopener">{$sub.SteamId}</a>
                                                {/if}
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-network-wired"></i> IP 地址</span>
                                                {if $sub.sip == ""}
                                                    <span class="text:italic">无 IP 地址</span>
                                                {else}
                                                    <a href="http://geoiplookup.net/ip/{$sub.sip}" target="_blank" rel="noopener">{$sub.sip}</a>
                                                {/if}
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-server"></i> 服务器</span>
                                                <div id="sub{$sub.subid}">
                                                    {if $sub.hostname == ""}
                                                        <span class="text:italic">正在获取主机名</span>
                                                    {else}
                                                        <span>{$sub.hostname}</span>
                                                    {/if}
                                                </div>
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-gamepad"></i> 游戏模组</span>
                                                <span>{$sub.mod}</span>
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-user"></i> 举报人姓名</span>
                                                {if $sub.subname == ""}
                                                    <span class="text:italic">无姓名</span>
                                                {else}
                                                    <span>{$sub.subname}</span>
                                                {/if}
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-network-wired"></i> 举报人 IP</span>
                                                <a href="http://geoiplookup.net/ip/{$sub.ip}" target="_blank" rel="noopener">{$sub.ip}</a>
                                            </li>

                                        </ul>
                                    </div>

                                    <div class="ban_list_comments margin-bottom">
                                        <div class="layout_box_title">
                                            <h2><i class="fa-solid fa-pen-to-square"></i> 原因</h2>
                                        </div>

                                        <div class="layout_box-child padding margin:half">
                                            <div class="ban_list_comments_header">
                                                {$sub.reason}
                                            </div>
                                        </div>
                                    </div>

                                    <div class="ban_list_comments">
                                        <div class="layout_box_title">
                                            <h2><i class="fa-regular fa-comments"></i> 评论区</h2>
                                        </div>

                                        {if $sub.commentdata != "None"}
                                            <ul>
                                                {foreach from=$sub.commentdata item="commenta"}
                                                    <li>
                                                        <div class="layout_box-child padding">
                                                            <div class="ban_list_comments_header">
                                                                {if !empty($commenta.comname)}
                                                                    <span class="text:bold">{$commenta.comname|escape:'html'}</span>
                                                                {else}
                                                                    <span class="text:italic">管理员已删除</span>
                                                                {/if}
                                                                <span>{$commenta.added}</span>
                                                                {if $commenta.editcomlink != ""}
                                                                    {$commenta.editcomlink} {$commenta.delcomlink}
                                                                {/if}
                                                            </div>

                                                            <div class="margin-top flex flex-fd:column">
                                                                {$commenta.commenttxt}

                                                                {if !empty($commenta.edittime)}
                                                                    <span class="margin-top:half text:italic">
                                                                        <i class="fas fa-pencil-alt"></i> 最后编辑
                                                                        {$commenta.edittime} 由 {$commenta.editname}
                                                                    </span>
                                                                {/if}
                                                            </div>
                                                        </div>
                                                    </li>
                                                {/foreach}
                                            </ul>
                                        {else}
                                            <div class="padding">
                                                {$sub.commentdata}
                                            </div>
                                        {/if}
                                    </div>

                                </div>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
        <script>
            document.querySelectorAll('.button').forEach(e => e.addEventListener('click', el => el.stopPropagation()));
        </script>
    </div>
{/if}
