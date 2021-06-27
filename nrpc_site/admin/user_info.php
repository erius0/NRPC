<?php
include '../config.php';
include '../code/user_info_code.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <?php if (isset($_COOKIE['is_admin'])) { ?>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Админ - пользователи</title>
            <link href="../style.css" rel="stylesheet" type="text/css" />
        </head>
        <script src="../code/js_code.js"></script>
        <body>
            <div id="wrapper">
                <div id="header">
                    <ul id="nav">
                        <li><a href="../index.php">Вернуться на сайт</a></li>
                        <li><a href="parts.php">Товары</a></li>
                        <li><a href="orders.php">Заказы</a></li>
                        <li><a href="users.php">Пользователи</a></li>
                        <li><a href="index.php">На главную</a></li>
                    </ul>
                </div>
                <div id="masthead">
                    <h2>Информация о пользователе <?= $id ?></h2>
                </div>
                <div id="blue-bar">

                </div>
                <div id="main">
                    <div id='content'>
                        <div class='txt'>
                            <form name='user_change' method='get' action='user_info.php'>
                                <?php showUserInfo($con); ?></br></br>
                                <?= $saved ?></br></br>
                                <h2>Заказы пользователя</h2>
                                <?php showOrders($con); ?>
                            </form>
                        </div>
                    </div>
                </div>
                <div id="footer">
                    <h1>Контакты</h1>
                    <h2>Связаться с нами можно по телефону: +7 (997) 190-55-05</h2>
                    <h2>Наш офис находится по адресу: ул. Амбаторный, д. 134</h2>
                    <h3><a href="https://vk.com/id369980463">Разработчик сайта</a></h3>
                </div>
            </div>
        </body>
    <?php } else { ?>
        <h2>В доступе отказано</br>
            <a href="../index.php">На главную</a>
        </h2>
    <?php } ?>
</html>