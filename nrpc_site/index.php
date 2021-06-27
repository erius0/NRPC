<?php
include 'config.php';
include 'code/exit_handle.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Главная</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <script src="code/js_code.js"></script>
    <body onload='cartCount()'>
        <div id="wrapper">
            <div id="header">
                <ul id="nav">
                    <form name="unauth" method="post" action="index.php">
                        <li class="active"><a href="#">На главную</a></li>
                        <li><a href="pages/shopping.php">Каталог</a></li>
                        <?php if (isset($_COOKIE['login'])) { ?>
                            <li><a href="pages/profile.php">Профиль</a></li>
                            <li><a href="pages/cart.php">Корзина<div id='notif'></div></a></li>
                            <?php if (isset($_COOKIE['is_admin'])) { ?>
                                <li><a href="admin/index.php">Админ. панель</a></li>
                            <?php } ?>
                            <li><input name="exit" type="submit" value="Выйти"/></li>
                        <?php } else { ?>
                            <li><a href="pages/login.php">Войти</a></li>
                            <li><a href="pages/register.php">Регистрация</a></li>
                        <?php } ?>
                    </form>
                </ul>
            </div>
            <div id="masthead">
                <img id="logo" src="images/logo.png"/>
            </div>
            <div id="blue-bar">

            </div>
            <div id="main">
                <div id="content">
                    <h1>Добро пожаловать в интернет магазин комптютерной техники в Новорыбинске!
                        </br></br><img style="width: 50%; margin-left: 30%" src="images/shop1.jpg"/>
                        </br></br>Огромный выбор товаров и низкие цены
                        </br></br>В <a href="pages/shopping.php">каталоге</a> вы можете добавить интересующие вас товары в корзину, после чего оформить заказ</h1>
                    <?php if (!isset($_COOKIE['login'])) { ?>
                        </br><h3>Перед тем как оформить заказ, вы должны войти в свой аккаунт</h3>
                        <a href="pages/login.php" class="green-button">Войти &raquo;</a>
                    <?php } ?>
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
</html>