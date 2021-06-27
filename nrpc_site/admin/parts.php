<?php
include '../config.php';
include '../code/parts_shopping_code.php';
include '../code/parts_code.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <?php if (isset($_COOKIE['is_admin'])) { ?>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <title>Админ - товары</title>
            <link href="../style.css" rel="stylesheet" type="text/css" />
        </head>
        <script src="../code/js_code.js"></script>
        <body>
            <div id="wrapper">
                <div id="header">
                    <ul id="nav">
                        <li><a href="../index.php">Вернуться на сайт</a></li>
                        <li class="active"><a href="#">Товары</a></li>
                        <li><a href="orders.php">Заказы</a></li>
                        <li><a href="users.php">Пользователи</a></li>
                        <li><a href="index.php">На главную</a></li>
                    </ul>
                </div>
                <div id="masthead">
                    <h2>Товары</h2>
                    <h3>Возможность модифицировать и добавлять товары</h3>
                </div>
                <div id="blue-bar">

                </div>
                <div id="main">
                    <div id="content">
                        <h2>Поиск и изменение существующих комплектующих:</h2></br>
                        <div class='txt'>
                            <form name="parts_modify" method="get" action="parts.php">
                                Артикул: <input class='filter' type="text" name="parts_upc" value="<?= $data[0] ?>"/></br></br>
                                Наименование: <input class='filter' type="text" name="parts_name" value="<?= $data[1] ?>"/></br></br>
                                Стоимость от: <input class='filter' type="number" name="parts_price_bottom" min="0" max="1000000" step="100" value="<?= $data[2] ?>"/>
                                до: <input class='filter' type="number" name="parts_price_upper" min="0" max="1000000" step="100" value="<?= $data[3] ?>"/> рублей</br></br>
                                <?php
                                $categories = getCategories($con);
                                $suppliers = getSuppliers($con);
                                echo 'Категория: ' . selectCategory($categories, $data[4], 'parts_categorys', true) . '</br></br>';
                                echo 'Поставщик: ' . selectSupplier($suppliers, $data[5], 'parts_suppliers', true);
                                ?></br></br>
                                <input class='btn' type="submit" name="parts_show" value="Показать товары"/>
                            </form></div>
                        </br></br>
                        <?php showParts($con); ?></br></br>
                        <h2>Добавление новых комплектующих:</h2></br>
                        <div class="txt">
                            <form enctype="multipart/form-data" name="part_add" method="post" action="parts.php">
                                Артикул: <input class='filter' type="text" name="part_add_upc"/>
                                Наименование: <input class='filter' type="text" name="part_add_name"/></br></br>
                                Стоимость: <input class='filter' type="number" name="part_add_price" min="0.00" max="1000000.00" step="0.01" value="0.00"/> рублей</br></br>
                                <?php
                                echo 'Категория: ' . selectCategory($categories, 1, 'part_add_categorys', false);
                                echo 'Поставщик: ' . selectSupplier($suppliers, 1, 'part_add_suppliers', false);
                                ?>
                                </br></br>
                                Описание: <textarea rows="10" cols="100" name="part_add_description"></textarea></br></br>
                                Изображение: <input type="file" name="part_add_image" accept="image/jpeg"/></br></br>
                                <input class='btn' type="submit" name="add_part" value="Добавить товар"/>
                                <?php addPart($con); ?>
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