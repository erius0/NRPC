<?php
include '../config.php';
include '../code/orders_code.php'
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <?php if (isset($_COOKIE['is_admin'])) { ?>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Админ - заказы</title>
            <link href="../style.css" rel="stylesheet" type="text/css" />
        </head>
        <script src="../code/js_code.js"></script>
        <body>
            <div id="wrapper">
                <div id="header">
                    <ul id="nav">
                        <li><a href="../index.php">Вернуться на сайт</a></li>
                        <li><a href="parts.php">Товары</a></li>
                        <li class="active"><a href="#">Заказы</a></li>
                        <li><a href="users.php">Пользователи</a></li>
                        <li><a href="index.php">На главную</a></li>
                    </ul>
                </div>
                <div id="masthead">
                    <h2>Заказы</h2>
                    <h3>Поиск заказов, возможность отменять или завершать заказы</h3>
                </div>
                <div id="blue-bar">

                </div>
                <div id="main">
                    <div id="content">
                        <h2>Поиск и изменение существующих заказов:</h2></br>
                        <form name="orders_modify" method="get" action="orders.php">
                            <div class='txt'>
                                Номер: <input class='filter' type="text" name="orders_id" value="<?= $data[0] ?>"/></br></br>
                                Пользователь: <input class='filter' type="text" name="orders_name" value="<?= $data[1] ?>"/></br></br>
                                Магазин: <?php echo selectShops($con, 'orders_shop', $data[2]); ?></br></br>
                                Статус: <?php echo selectStatus($con, 'orders_status', $data[3]); ?></br></br>
                                <input class='btn' type="submit" name="orders_show" value="Показать заказы"/></br></br>
                            </div>
                            <?php showOrders($con); ?>
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
    <?php } else { ?>
        <h2>В доступе отказано</br>
            <a href="../index.php">На главную</a>
        </h2>
    <?php } ?>
</html>