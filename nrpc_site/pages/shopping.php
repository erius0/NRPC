<?php
include '../config.php';
include '../code/exit_handle.php';
include '../code/parts_shopping_code.php';
include '../code/shopping_code.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Каталог</title>
        <link href="../style.css" rel="stylesheet" type="text/css" />
    </head>
    <script src="../code/js_code.js"></script>
    <body onload='cartCount()'>
        <div id="wrapper">
            <div id="header">
                <ul id="nav">
                    <form name="unauth" method="post" action="shopping.php">
                        <li><a href="../index.php">На главную</a></li>
                        <li class="active"><a href="#">Каталог</a></li>
                        <?php if (isset($_COOKIE['login'])) { ?>
                            <li><a href="profile.php">Профиль</a></li>
                            <li><a href="cart.php">Корзина<div id='notif'>0</div></a></li>
                            <?php if (isset($_COOKIE['is_admin'])) { ?>
                                <li><a href="../admin/index.php">Админ. панель</a></li>
                            <?php } ?>
                            <li><input name="exit" type="submit" value="Выйти"/></li>
                        <?php } else { ?>
                            <li><a href="login.php">Войти</a></li>
                            <li><a href="register.php">Регистрация</a></li>
                        <?php } ?>
                    </form>
                </ul>
            </div>
            <div id="masthead">
                <h2>Каталог</h2>

            </div>
            <div id="blue-bar">

            </div>
            <div id="main">
                <div id="content">
                    <?php showPartsShop($con); ?>
                </div>
                <div id="sidebar">
                    <form name="parts_shopping" method="get" action="shopping.php">
                        <div class='txt'>
                            Наименование:</br><input class='filter' type="text" name="parts_name" value="<?= $data[0] ?>"/></br></br>
                            Стоимость (в рублях)</br>от: <input class='filter' type="number" name="parts_price_bottom" min="0" max="1000000" value="<?= $data[1] ?>"/></br>
                            до: <input class='filter' type="number" name="parts_price_upper" min="0" max="1000000" value="<?= $data[2] ?>"/></br></br>
                            <?php
                            $categories = getCategories($con);
                            echo 'Категория:</br>' . selectCategory($categories, $data[3], 'parts_categorys', true) . '</br></br>'
                            . 'Сортировать:</br>' . selectSort($data[4]) . '</br></br>';
                            ?>
                            <input type="checkbox" name="show_absent" value="1" <?= $data[5] ?>/>Показывать отсутсвующие в наличии товары</br></br>
                            <input class='btn' type="submit" name="parts_show" value="Применить фильтр"/></br></br>
                            <input class='btn' type="submit" name="sort_reset" value="Сбросить фильтр"/>
                        </div>
                    </form>
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
