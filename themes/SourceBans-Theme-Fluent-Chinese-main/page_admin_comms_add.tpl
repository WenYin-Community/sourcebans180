{if NOT $permission_addban}
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
        <h2><i class="fas fa-microphone-alt-slash"></i> 添加禁言</h2>
    </div>

    <div class="padding">
        <div id="msg-green" class="message message:succes margin-bottom:half" style="display: none;">
            <h3>已添加禁言</h3>
            <div>新管理员已成功添加到系统中。</div>
            <div class="text:italic">正在重定向回禁言页面</div>
        </div>

        <div class="margin-bottom">
            如需了解特定主题的更多信息或帮助，请将鼠标悬停在问号上。
        </div>

        <div class="margin-bottom:half">
            <label for="nickname" class="form-label form-label:bottom">
                昵称
            </label>

            <input type="hidden" id="fromsub" value="" />
            <input type="text" TABINDEX=1 class="form-input form-full" id="nickname" name="nickname" />

            <div class="form-desc">
                输入您要封禁的玩家的昵称。
            </div>
            <div id="nick.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="steam" class="form-label form-label:bottom">
                Steam ID / 社区 ID
            </label>

            <input type="text" TABINDEX=3 class="form-input form-full" id="steam" name="steam" />

            <div class="form-desc">
                您要封禁的玩家的 Steam ID 或社区 ID。
            </div>
            <div id="steam.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="type" class="form-label form-label:bottom">
                禁言类型
            </label>

            <select id="type" name="type" TABINDEX=2 class="form-select form-full">
                <option value="1">语音</option>
                <option value="2">聊天</option>
                <option value="3">聊天和语音</option>
            </select>
        </div>

        <div class="margin-bottom:half">
            <label for="listReason" class="form-label form-label:bottom">
                禁言原因
            </label>

            <select id="listReason" name="listReason" TABINDEX=4 class="form-select form-full"
                onChange="changeReason(this[this.selectedIndex].value);">
                <option value="" selected> -- 选择原因 -- </option>
                <optgroup label="违规行为">
                    <option value="Obscene language">淫秽语言</option>
                    <option value="Insult players">侮辱玩家</option>
                    <option value="Admin disrespect">不尊重管理员</option>
                    <option value="Inappropriate Language">不当语言</option>
                    <option value="Trading">交易</option>
                    <option value="Spam in chat/voice">垃圾信息</option>
                    <option value="Advertisement">广告</option>
                </optgroup>
                <option value="other">其他原因</option>
            </select>

            <div id="dreason" style="display:none;">
                <textarea class="form-text margin-top:half" TABINDEX=4 cols="30" rows="5" id="txtReason"
                    name="txtReason"></textarea>
            </div>

            <div class="form-desc">
                详细说明此禁言的原因。
            </div>
            <div id="reason.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="margin-bottom:half">
            <label for="banlength" class="form-label form-label:bottom">
                禁言时长
            </label>

            <select id="banlength" TABINDEX=5 class="form-select form-full">
                <option value="0">永久</option>
                <optgroup label="分钟">
                    <option value="1">1 分钟</option>
                    <option value="5">5 分钟</option>
                    <option value="10">10 分钟</option>
                    <option value="15">15 分钟</option>
                    <option value="30">30 分钟</option>
                    <option value="45">45 分钟</option>
                </optgroup>
                <optgroup label="小时">
                    <option value="60">1 小时</option>
                    <option value="120">2 小时</option>
                    <option value="180">3 小时</option>
                    <option value="240">4 小时</option>
                    <option value="480">8 小时</option>
                    <option value="720">12 小时</option>
                </optgroup>
                <optgroup label="天">
                    <option value="1440">1 天</option>
                    <option value="2880">2 天</option>
                    <option value="4320">3 天</option>
                    <option value="5760">4 天</option>
                    <option value="7200">5 天</option>
                    <option value="8640">6 天</option>
                </optgroup>
                <optgroup label="周">
                    <option value="10080">1 周</option>
                    <option value="20160">2 周</option>
                    <option value="30240">3 周</option>
                </optgroup>
                <optgroup label="月">
                    <option value="43200">1 个月</option>
                    <option value="86400">2 个月</option>
                    <option value="129600">3 个月</option>
                    <option value="259200">6 个月</option>
                    <option value="518400">12 个月</option>
                </optgroup>
            </select>

            <div id="length.msg" class="message message:error margin-top:half" style="display: none;"></div>
        </div>

        <div class="flex flex-ai:center flex-jc:space-between margin-top">
            {sb_button text="添加禁言" onclick="ProcessBan();" class="button button-success" id="aban" submit=false}
            {sb_button text="返回" onclick="history.go(-1)" class="button button-light" id="aback"}
        </div>
    </div>
{/if}