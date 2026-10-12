<div class="layout_box flex:11 admin_tab_content tabcontent" id="Overrides">
    {if NOT $permission_addadmin}
        <section class="error padding">
            <i class="fas fa-exclamation-circle"></i>
            <div class="error_title">哎呀，出了点问题 (╯°□°）╯︵ ┻━┻</div>

            <div class="error_content">
                拒绝访问！
            </div>

            <div class="error_code">
                错误代码: <span class="text:bold">403 禁止访问</span>
            </div>
        </section>
    {else}
        <div class="admin_tab_content_title">
            <h2><i class="fas fa-cogs"></i> 覆盖设置</h2>
        </div>

        <div class="padding">
            {if $overrides_error != ""}
                <script type="text/javascript">
                    ShowBox("Error", "{$overrides_error}", "red");
                </script>
            {/if}
            {if $overrides_save_success}
                <script type="text/javascript">
                    ShowBox("覆盖设置已更新", "更改已成功保存。", "green",
                        "index.php?p=admin&c=admins");
                </script>
            {/if}

            <div>
                通过覆盖设置，您可以全局或为特定组更改任何命令的标志或权限，而无需编辑插件源代码。
            </div>
            <div>
                在 AlliedModders Wiki 中阅读相关内容：<a href="http://wiki.alliedmods.net/Overriding_Command_Access_%28SourceMod%29"
                    title="Overriding Command Access (SourceMod)" target="_blank" class="text:bold text:italic"
                    rel="noopener">覆盖命令访问</a>！
            </div>
            <p class="text:italic">清空覆盖设置的名称将删除它。</p>

            <form action="" method="post">
                <div class="table table_box">
                    <table>
                        <thead>
                            <tr>
                                <th>类型</th>
                                <th>名称</th>
                                <th>标志</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$overrides_list item="override"}
                                <tr>
                                    <td>
                                        <select class="form-select form-full" name="override_type[]">
                                            <option{if $override.type == "command"} selected="selected" {/if} value="command">
                                                命令</option>
                                                <option{if $override.type == "group"} selected="selected" {/if} value="group">
                                                    组</option>
                                        </select>
                                        <input type="hidden" name="override_id[]" value="{$override.id}" />
                                    </td>
                                    <td>
                                        <input name="override_name[]" value="{$override.name|smarty_htmlspecialchars}"
                                            class="form-input form-full" />
                                    </td>
                                    <td>
                                        <input name="override_flags[]" value="{$override.flags|smarty_htmlspecialchars}"
                                            class="form-input form-full" />
                                    </td>
                                </tr>
                            {/foreach}
                            <tr>
                                <td>
                                    <select class="form-select form-full" name="new_override_type">
                                        <option value="command">命令</option>
                                        <option value="group">组</option>
                                    </select>
                                </td>
                                <td>
                                    <input class="form-input form-full" name="new_override_name" />
                                </td>
                                <td>
                                    <input class="form-input form-full" name="new_override_flags" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="flex flex-ai:center flex-jc:space-between margin-top">
                    <button type="submit" name="oversave" class="button button-success"
                        onmouseover="ButtonOver(&quot;oversave&quot;)" onmouseout="ButtonOver(&quot;oversave&quot;)"
                        id="oversave">保存</button>
                    <button onclick="history.go(-1)" name="oback" class="button button-light"
                        onmouseover="ButtonOver(&quot;oback&quot;)" onmouseout="ButtonOver(&quot;oback&quot;)"
                        id="oback">返回</button>
                </div>
            </form>
        </div>
    {/if}
</div>
</div>