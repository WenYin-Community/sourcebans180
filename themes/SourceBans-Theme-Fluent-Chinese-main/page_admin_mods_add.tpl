{if NOT $permission_add}
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
        <h2><i class="fas fa-plus"></i> 添加模组</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom">
            如需了解特定主题的更多信息或帮助，请将鼠标悬停在问号上。
        </div>

        <div class="margin-bottom:half">
            <label for="name" class="form-label form-label:bottom">
                模组名称
            </label>

            <input type="hidden" id="fromsub" value="" />
            <input type="text" TABINDEX=1 class="form-input form-full" id="name" name="name" />

            <div class="form-desc">
                输入您要添加的模组的名称。
            </div>

            <div id="name.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="folder" class="form-label form-label:bottom">
                模组文件夹
            </label>

            <input type="text" TABINDEX=2 class="form-input form-full" id="folder" name="folder" />

            <div class="form-desc">
                输入此模组的文件夹名称。例如，Counter-Strike: Source 的模组文件夹是 'cstrike'。
            </div>

            <div id="folder.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="steam_universe" class="form-label form-label:bottom">
                Steam Universe 数字
            </label>

            <input type="text" TABINDEX=3 class="form-input form-full" id="steam_universe" name="steam_universe"
                value="0" />

            <div class="form-desc">
                (STEAM_<span class="text:bold">X</span>:Y:Z) 某些游戏的 steamid 显示方式不同。请输入 SteamID 中的第一个数字
                (<span class="text:bold">X</span>)，具体取决于此模组的显示方式。（默认值：0）。
            </div>
        </div>

        <div class="margin-bottom:half">
            <input type="checkbox" TABINDEX=4 id="enabled" name="enabled" class="form-check" value="1" checked="checked" />

            <label for="enabled" class="form-label form-label:left">
                模组启用状态
            </label>

            <div class="form-desc">
                选择此模组是否启用并可分配给封禁和服务器。
            </div>
        </div>

        <div class="margin-bottom:half">
            <label for="upload" class="form-label form-label:button">
                上传图标
            </label>

            {sb_button text="上传模组图标" onclick="childWindow=open('pages/admin.uploadicon.php','upload','resizable=yes,width=300,height=130');" class="button button-primary" id="upload"}

            <div class="form-desc">
                点击此处可上传与此模组关联的图标。
            </div>

            <div id="icon.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="padding flex flex-ai:center flex-jc:space-between">
            {sb_button text="添加模组" onclick="ProcessMod();" class="button button-success" id="amod"}
            {sb_button text="返回" onclick="history.go(-1)" class="button button-light" id="aback"}
        </div>
    </div>
{/if}