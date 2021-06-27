<?php
include '../config.php';
include '../code/login_code.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Войти</title>
        <link href="../style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <div id="wrapper">

            <div id="loginpane">
                <h1>Вход в систему</h1>
                </br>
                <form name="auth" method="post" action="login.php">
                    <table>
                        <h4>
                            <?php
                            if ($error)
                                echo $msg;
                            ?>
                        </h4>
                        <h2>
                            <tr><td>Логин:</td><td><input name="login" type="txt"/></td></tr>
                            <tr><td>Пароль:</td><td><input name="password" type="password"/></td></tr>
                            <tr><td><input name="sub" type="submit" value="Войти"/></td></tr>
                    </table>
                    </h2>
                </form>
                </br>
                <h3>
                    Нет аккаунта? <a href="register.php">Зарегистрироваться</a>
                </h3>
            </div>
        </div>
    </body>
</html>