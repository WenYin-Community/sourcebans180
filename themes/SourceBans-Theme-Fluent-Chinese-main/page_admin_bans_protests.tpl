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
        <h2><i class="fas fa-gavel"></i> 封禁申诉 (<span id="protcount">{$protest_count}</span>)</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom">
            点击玩家昵称可查看封禁详细信息。
        </div>

        <div class="pagination">
            <span>{$protest_nav}</span>
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
                    {foreach from=$protest_list item="protest"}
                        <tr class="collapse">
                            <td>
                                {$protest.name}
                            </td>
                            <td>
                                {if $protest.authid!=""}
                                    {$protest.authid}
                                {else}
                                    {$protest.ip}
                                {/if}
                            </td>
                            <td class="flex flex-jc:center flex-ai:center">

                                <a href="index.php?p=admin&c=bans&o=email&type=p&id={$protest.pid}"
                                    class="button button-primary margin-right:half">
                                    联系
                                </a>

                                {if $permission_editban}
                                    <button class="button button-success margin-right:half"
                                        onclick="RemoveProtest('{$protest.pid}', '{if $protest.authid!=""}{$protest.authid}{else}{$protest.ip}{/if}', '1');">
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
                                            <li class="button button-success">
                                                {$protest.protaddcomment}
                                            </li>
                                        </ul>

                                        <ul class="ban_list_detal">
                                            <li>
                                                <span><i class="fa-solid fa-user"></i> 玩家</span>
                                                <span>
                                                    <a href="./index.php?p=banlist&advSearch={$protest.authid}&advType=steamid"
                                                        title="查看封禁">
                                                        {$protest.name}
                                                    </a>
                                                </span>
                                            </li>

                                            <li>
                                                <span><i class="fa-brands fa-steam"></i> Steam ID</span>
                                                {if $protest.authid == ""}
                                                    <span class="text:italic">无 Steam ID</span>
                                                {else}
                                                    <a href="https://www.steamidfinder.com/lookup/{$protest.authid}" target="_blank" rel="noopener">{$protest.authid}</a>
                                                {/if}
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-network-wired"></i> IP 地址</span>
                                                {if $protest.ip == 'none' || $protest.ip == ''}
                                                    <span class="text:italic">无 IP 地址</span>
                                                {else}
                                                    <a href="http://geoiplookup.net/ip/{$protest.ip}" target="_blank" rel="noopener">{$protest.ip}</a>
                                                {/if}
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-play"></i> 执行时间</span>
                                                <span>{$protest.date}</span>
                                            </li>

                                            <li>
                                                <span><i class="fas fa-clock"></i> 结束时间</span>
                                                {if $protest.ends == 'never'}
                                                    <span class="text:italic">永久封禁</span>
                                                {else}
                                                    <span>{$protest.ends}</span>
                                                {/if}
                                            </li>

                                            <li>
                                                <span><i class="fas fa-question"></i> 原因</span>
                                                <span>{$protest.ban_reason}</span>
                                            </li>

                                            <li>
                                                <span><i class="fas fa-ban"></i> 封禁管理员</span>
                                                <span>{$protest.admin}</span>
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-server"></i> 封禁服务器</span>
                                                <span>{$protest.server}</span>
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-network-wired"></i> 申诉者 IP</span>
                                                <a href="http://geoiplookup.net/ip/{$protest.pip}" target="_blank" rel="noopener">{$protest.pip}</a>
                                            </li>

                                            <li>
                                                <span><i class="fa-solid fa-calendar-days"></i> 申诉时间</span>
                                                <span>{$protest.datesubmitted}</span>
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="ban_list_comments margin-bottom">
                                        <div class="layout_box_title">
                                            <h2><i class="fa-solid fa-pen-to-square"></i> 申诉信息</h2>
                                        </div>

                                        <div class="layout_box-child padding margin:half">
                                            <div class="ban_list_comments_header">
                                                {$protest.reason}
                                            </div>
                                        </div>
                                    </div>

                                    <div class="ban_list_comments">
                                        <div class="layout_box_title">
                                            <h2><i class="fa-regular fa-comments"></i> 评论区</h2>
                                        </div>

                                        {if $protest.commentdata != "None"}
                                            <ul>
                                                {foreach from=$protest.commentdata item=commenta}
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
                                                {$protest.commentdata}
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
