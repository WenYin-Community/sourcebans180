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
    <div class="admin_tab_content_title">
        <h2><i class="fas fa-file-import"></i> 导入封禁</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom">
            如需了解特定主题的更多信息或帮助，请将鼠标悬停在问号上。
        </div>
        <form action="" method="post" enctype="multipart/form-data">
            <div class="margin-bottom:half">
                <label for="importFile" class="form-label form-label:bottom">
                    文件
                </label>

                <input type="file" TABINDEX=1 class="form-input form-full" id="importFile" name="importFile" />
                <div class="form-desc">
                    选择 <span class="text:bold">banned_users.cfg</span> 或 <span
                        class="text:bold">banned_ip.cfg</span>
                    文件以上传并添加封禁。
                </div>

                <div id="file.msg" class="message message:error margin-top:half" style="display: none;"></div>
            </div>

            <div class="margin-bottom:half">
                <input type="checkbox" class="form-check" name="friendsname" id="friendsname" />
                <label for="friendsname" class="form-label form-label:left">
                    获取名称
                </label>

                <div class="form-desc">
                    选中此框可从玩家的 Steam 社区资料获取玩家名称。<span
                        class="text:italic">（仅适用于 banned_users.cfg）</span>。
                </div>

                <div id="friendsname.msg" class="message message:error margin-top:half" style="display: none;"></div>
            </div>

            <div class="flex flex-ai:center flex-jc:space-between margin-top">
                {sb_button text="导入" class="button button-success" id="iban" submit=true}
                {sb_button text="返回" onclick="history.go(-1)" class="button button-light" id="iback"}
            </div>
        </form>
    </div>
    {if !$extreq}
        <script type="text/javascript">
            $('friendsname').disabled = true;
        </script>
    {/if}
{/if}