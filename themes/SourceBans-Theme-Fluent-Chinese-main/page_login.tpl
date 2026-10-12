-{if $sso_mode}-
<div class="flex flex-jc:center flex-ai:center">
    <div class="layout_box_small layout_box">
        <div class="layout_box_title">
            <h2><i class="fas fa-shield-halved"></i> -{$sso_texts.title}-</h2>
        </div>

        <div class="padding">
            -{if $sso_reason == 'not_open'}-
            <div class="message message:error margin-bottom:half">-{$sso_texts.not_open}-</div>
            -{elseif $sso_reason == 'api_down'}-
            <div class="message message:error margin-bottom:half">-{$sso_texts.unavailable}-</div>
            -{/if}-

            <div class="margin-bottom:half">
                -{$sso_texts.desc}-
            </div>

            -{if $sso_reason != 'not_open'}-
            <div class="flex margin-top">
                -{sb_button text=$sso_texts.button onclick="location.href='`$sso_login_url`'" class="button button-success flex:11" id="ssologin" submit=false}-
            </div>
            -{/if}-
        </div>
    </div>
</div>
-{else}-
<div class="flex flex-jc:center flex-ai:center">
    <div class="layout_box_small layout_box">
        <div class="layout_box_title">
            <h2>管理员登录</h2>
        </div>

        <div class="padding">
            <div class="margin-bottom:half">
                <label for="loginUsername" class="form-label form-label:bottom">
                    用户名
                </label>
                <input id="loginUsername" class="form-input form-full" type="text" name="username" />
                <div id="loginUsername.msg" class="message message:error margin-top:half" style="display: none;">
                </div>
            </div>

            <div class="margin-bottom:half">
                <label for="loginPassword" class="form-label form-label:bottom">
                    密码
                </label>
                <input id="loginPassword" class="form-input form-full" type="password" name="password" />
                <div id="loginPassword.msg" class="message message:error margin-top:half" style="display: none;">
                </div>
            </div>

            <div class="flex flex-jc:space-between flex-ai:center margin-top">
                <div class="flex flex-jc:space-between flex-ai:center">
                    <span class="input_checkbox">
                        <input id="loginRememberMe" type="checkbox" name="remember" value="checked"
                            class="form-check" />
                        <label for="loginRememberMe" class="form-label form-label:left">记住我</label>
                    </span>
                </div>

                <a href="index.php?p=lostpassword">
                    忘记密码?
                </a>
            </div>

            <div class="flex margin-top">
                -{sb_button text="登录" onclick=$redir class="button button-success flex:11" id="alogin" submit=false}-
            </div>
        </div>
    </div>
</div>

<script>
    $E('html').onkeydown = function(event) {
        var event = new Event(event);
        if (event.key == 'enter' ) -{$redir}-
    };
    $('loginRememberMeDiv').onkeydown = function(event) {
        var event = new Event(event);
        if (event.key == 'space') $('loginRememberMeDiv').checked = true;
    };
    $('button').onkeydown = function(event) {
        var event = new Event(event);
        if (event.key == 'space' ) -{$redir}-
    };
</script>
-{/if}-
