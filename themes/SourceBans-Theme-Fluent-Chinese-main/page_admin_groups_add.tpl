{if NOT $permission_addgroup}
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
        <h2><i class="fas fa-users"></i> 新建组</h2>
    </div>

    <div class="padding">
        <div class="margin-bottom:half">
            <label for="groupname" class="form-label form-label:bottom">
                组名称
            </label>

            <input type="text" TABINDEX=1 class="form-input form-full" id="groupname" name="groupname" />

            <div class="form-desc">
                输入您要创建的新组的名称。
            </div>
            <div id="name.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="grouptype" class="form-label form-label:bottom">
                组类型
            </label>

            <select onchange="UpdateGroupPermissionCheckBoxes()" TABINDEX=2 class="form-select form-full" name="grouptype"
                id="grouptype">
                <option value="0">请选择...</option>
                <option value="1">网页管理组</option>
                <option value="2">服务器管理组</option>
                <option value="3">服务器组</option>
            </select>

            <div class="form-desc">
                这定义了您即将创建的组的类型。这有助于识别和分类组列表。
            </div>
            <div id="type.msg" class="message message:info margin-top:half" style="display: none;"></div>

            <div class="test" colspan="2" id="perms" valign="top" style="height:5px;overflow:hidden;"></div>
        </div>

        <div class="flex flex-ai:center flex-jc:space-between margin-top">
            {sb_button text="保存更改" onclick="ProcessGroup();" class="button button-success" id="agroup" submit=false}
            {sb_button text="返回" onclick="history.go(-1)" class="button button-light" id="back" submit=false}
        </div>
    </div>
{/if}