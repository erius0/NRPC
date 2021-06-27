<?php
include '../config.php';
include '../code/register_code.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Регистрация</title>
        <link href="../style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <div id="wrapper">

            <div id="loginpane">
                <h1>Регистрация в системе</h1>
                </br>
                <form name="auth" method="post" action="register.php">
                    <table>
                        <h4>
                            <?php
                            if ($error)
                                echo $msg;
                            ?>
                        </h4>
                        <h2>
                            <tr><td>Имя:</td><td><input name="name" type="txt" value="<?= $data[0] ?>"/></td></tr>
                            <tr><td>Фамилия:</td><td><input name="surname" type="txt" value="<?= $data[1] ?>"/></td></tr>
                            <tr><td>Логин:</td><td><input name="login" type="txt" value="<?= $data[2] ?>"/></td></tr>
                            <tr><td>Телефон:</td><td><input name="phone" type="number" value="<?= $data[3] ?>"/></td></tr>
                            <tr><td>Эл. почта:</td><td><input name="email" type="txt" value="<?= $data[4] ?>"/></td></tr>
                            <tr><td>Адрес:</td><td><input name="address" type="txt" value="<?= $data[5] ?>"/></td></tr>
                            <tr><td>Пароль:</td><td><input name="password" type="password"/></td></tr>
                            <tr><td><input name="sub" type="submit" value="Зарегестрироваться"/></td></tr>
                    </table>
                    </h2>
                </form>
                </br>
                <h3>
                    Уже есть аккаунт? <a href="login.php">Войдите</a>
                </h3>
            </div>
        </div>
    </body>
</html>