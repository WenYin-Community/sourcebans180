{if $sso_mode}
<table style="margin: 30px auto;">
    <tr>
        <td class="listtable_top"><b>{$sso_texts.pw_title}</b></td>
    </tr>
    <tr>
        <td class="listtable_1" style="padding: 15px;">
            <div id="login-content">
                <div>{$sso_texts.pw_hint}</div>

                <div id="loginSubmit" style="margin-top: 12px;">
                    {sb_button text=$sso_texts.button onclick="location.href='`$sso_login_url`'" class="ok login" id="ssologin" style="width: 100%; text-transform: uppercase;" submit=false}
                </div>
            </div>
        </td>
    </tr>
</table>
{else}
<div id="lostpassword">
    <div id="login-content">

        <div id="msg-red" style="display:none;">
            <i class="fas fa-times fa-2x"></i>
            <b>Error</b>
            <br />
            The email address you supplied is not registered on the system.</i>
        </div>
        <div id="msg-blue" style="display:none;">
            <i><img src="./images/info.png" alt="Warning" /></i>
            <b>Information</b>
            <br />
            Please check your email inbox (and spam) for a link which will help you reset your password.</i>
        </div>

        <h4>
            Please type your email address in the box below to have your password reset.
        </h4><br />

        <div id="loginPasswordDiv">
            <label for="email">Your E-Mail Address:</label><br />
            <input id="email" class="loginmedium" type="text" name="password" value="" />
        </div>

        <div id="loginSubmit">
            {sb_button text=Ok onclick="xajax_LostPassword($('email').value);" class=ok id=alogin submit=false}
        </div>

    </div>
</div>
{/if}
