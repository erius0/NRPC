<?php
include '../config.php';
include '../code/parts_shopping_code.php';
include '../code/parts_code.php';
include '../code/stock_code.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <?php if (isset($_COOKIE['is_admin'])) { ?>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Подробности</title>
            <link href="../style.css" rel="stylesheet" type="text/css" />
        </head>
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
                    <h2>Подробности о <?= $name ?></h2>
                </div>
                <div id="blue-bar">

                </div>
                <div id="main">
                    <div id="content">
                        <h2>Общая информация</h2></br>
                        <div class='txt'>
                            <form enctype="multipart/form-data" name="form_info" method="post" action="stock.php">
                                Артикул: <input class='filter' type="text" name="part_upc" value="<?= $upc ?>"/></br></br>
                                Наименование: <input class='filter' type="text" name="part_name" value="<?= $name ?>"/></br></br>
                                Стоимость: <input class='filter' type="number" name="part_price" min="0.00" max="1000000.00" step="0.01" value="<?= $price ?>"/> рублей</br></br>
                                <?php
                                echo 'Категория: ' . selectCategory($categories, $category, 'part_category', false) . '</br></br>';
                                echo 'Поставщик: ' . selectSupplier($suppliers, $supplier, 'part_supplier', false) . '</br></br>';
                                ?>
                                Описание: <textarea rows="10" cols="100" name="part_description"><?= $description ?></textarea></br></br>
                                Изображение: <img src="../images/parts/<?= $file ?>" height="200px"/><input type=hidden name="prev_img" value="<?= $file ?>"/></br></br>
                                <input type="file" name="part_image" accept="image/jpeg"/></br></br>
                                <input type="hidden" name="part_id" value="<?= $id ?>"/>
                                <h2>Наличие в магазинах</h2></br>
                                <?php displayStock($con, $id); ?>
                                <input class='btn' type="submit" name="part_save" value="Сохранить внесенные изменения"/>
                                <?php saveSucces(); ?>
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
    <?php } else { ?>
        <h2>В доступе отказано</br>
            <a href="../index.php">На главную</a>
        </h2>
    <?php } ?>
</html>