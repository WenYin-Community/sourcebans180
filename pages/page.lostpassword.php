<?php

global $theme;

use Sbpp\Mail\EmailType;
use Sbpp\Mail\Mail;
use Sbpp\Mail\Mailer;

// 统一认证模式：密码由认证中心统一管理，本地找回流程关闭
if (defined('WYAUTH_ENABLED') && WYAUTH_ENABLED) {
    $theme->assign('sso_mode', true);
    $theme->assign('sso_login_url', WYAUTH_LOGIN);
    $theme->assign('sso_texts', [
        'pw_title' => Lang::get('login.sso.pw_title'),
        'pw_hint' => Lang::get('login.sso.pw_hint'),
        'button' => Lang::get('login.sso.button'),
    ]);
    $theme->display('page_lostpassword.tpl');
    return;
}

if (isset($_GET['email'], $_GET['validation']) && (!empty($_GET['email']) || !empty($_GET['validation']))) {
    $email = $_GET['email'];
    $validation = $_GET['validation'];

    if (is_array($email) || is_array($validation)) {
        print "<script>ShowBox('" . Lang::js('box.error') . "', '" . Lang::js('pw.invalid_request') . "', 'red');</script>";
        Log::add("w", "Hacking attempt", "Attempted SQL-Injection.");
        PageDie();
    }

    if (strlen($validation) < 10) {
        print "<script>ShowBox('" . Lang::js('box.error') . "', '" . Lang::js('pw.invalid_token') . "', 'red');</script>";
        PageDie();
    }

    $GLOBALS['PDO']->query("SELECT aid, user FROM `:prefix_admins` WHERE `email` = :email AND `validate` = :validate");
    $GLOBALS['PDO']->bind(':email', $email);
    $GLOBALS['PDO']->bind(':validate', $validation);
    $result = $GLOBALS['PDO']->single();

    if (empty($result['aid']) || is_null($result['aid'])) {
        print "<script>ShowBox('" . Lang::js('box.error') . "', '" . Lang::js('pw.token_mismatch') . "', 'red');</script>";
        PageDie();
    }

    $password = Crypto::genSecret(MIN_PASS_LENGTH + 8);
    $GLOBALS['PDO']->query("UPDATE `:prefix_admins` SET `password` = :password, `validate` = NULL WHERE `aid` = :aid");
    $GLOBALS['PDO']->bind(':password', password_hash($password, PASSWORD_BCRYPT));
    $GLOBALS['PDO']->bind(':aid', $result['aid']);
    $GLOBALS['PDO']->execute();

    $isEmailSent = Mail::send($email, EmailType::PasswordResetSuccess, [
        '{password}' => $password,
        '{name}' => $result['user'],
        '{home}' => Host::complete(true)
    ]);

    print "<script>ShowBox('" . Lang::js('box.success') . "', 'Your password has been reset and sent to your email.<br />Please check your spam folder too.<br />Please login using this password, <br />then use the change password link in Your Account.', 'blue');</script>";
    PageDie();
} else {
    $theme->display('page_lostpassword.tpl');
}
