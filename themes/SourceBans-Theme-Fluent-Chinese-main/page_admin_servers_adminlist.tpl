<div class="admin_tab_content_title">
    <h2><i class="fas fa-user-shield"></i> 此服务器上的管理员 ({$admin_count})</h2>
</div>

<div class="padding">
    <div class="table table_box">
        <table>
            <thead>
                <tr>
                    <th class="text:left">管理员名称</th>
                    <th class="text:left">管理员 SteamID</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$admin_list item="admin"}
                    <tr class="collapse">
                        <td>
                            {$admin.user|escape:'html'}
                        </td>
                        <td>
                            {$admin.authid}
                        </td>
                    </tr>

                    {if $admin.ingame}
                        <tr class="table_hide">
                            <td colspan="8">
                                <div class="collapse_content">
                                    <h3>游戏内管理员详情</h3>
                                    <div class="table table_box">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th class="text:left">名称</th>
                                                    <th class="text:left">Steam ID</th>
                                                    <th class="text:left">IP</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        {$admin.iname|escape:'html'}
                                                    </td>
                                                    <td>
                                                        {$admin.authid}
                                                    </td>
                                                    <td>
                                                        {$admin.iip}
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    {/if}
                {/foreach}
            </tbody>
        </table>

        <script type="text/javascript" src="themes/{$theme}/scripts/collapse.js"></script>
    </div>
</div>
</div>