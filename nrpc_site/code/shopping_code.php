<?php

$data = ['', 0.00, 1000000.00, 0, 0, ''];

function selectSort($def) {
    $selected = '';
    if ($def != 0)
        $selected = 'selected';
    return '<select class="filter" name="parts_sort">'
            . '<option value=0>По возрастанию цены</option>'
            . "<option value=1 $selected>По убыванию цены</option>"
            . '</select>';
}

function showPartsShop($con) {
    global $data;
    if (isset($_REQUEST['parts_show'])) {
        $name = $_REQUEST['parts_name'];
        $price_bottom = $_REQUEST['parts_price_bottom'];
        $price_upper = $_REQUEST['parts_price_upper'];
        $category_id = $_REQUEST['parts_categorys'];
        $sort = $_REQUEST['parts_sort'];
        $show_absent = 0;
        if (isset($_REQUEST['show_absent']))
            $show_absent = $_REQUEST['show_absent'];
    } else {
        $name = '';
        $price_bottom = 0;
        $price_upper = 1000000;
        $category_id = 0;
        $sort = 0;
        $show_absent = 0;
    }
    $data[0] = $name;
    $data[1] = $price_bottom;
    $data[2] = $price_upper;
    $data[3] = $category_id;
    $data[4] = $sort;
    if (isset($_COOKIE['login'])) {
        $login = $_COOKIE['login'];
        $sql = "SELECT getUserShop('$login') AS 'result';";
        $query = mysqli_query($con, $sql);
        $r = mysqli_fetch_assoc($query);
        $shop = $r['result'];
    } else
        $shop = 1;
    if ($show_absent == 1)
        $data[5] = 'checked';
    $sql = "SELECT s.name FROM shop s WHERE s.id = $shop";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $shop_name = $r['name'];
    $sql = "CALL selectPartsShopping('$name', $price_bottom, $price_upper, $category_id, $sort, $show_absent, $shop);";
    $query = mysqli_query($con, $sql);
    echo "<h2>Товары в магазине $shop_name</h2>";
    echo '<form name="part_list" method="post" action="shopping.php">';
    while ($r = mysqli_fetch_assoc($query)) {
        $flag = 1;
        $id = $r['id'];
        $name = $r['name'];
        $price = number_format($r['price'], 2, '.', ' ');
        $image = $r['image'];
        $in_stock = $r['in_stock'];
        $btn_id = 'out';
        $btn_value = 'Нет в наличии';
        $disabled = 'disabled';
        if ($in_stock > 0) {
            $btn_value = 'Купить';
            $disabled = '';
            $btn_id = 'buy';
        }
        if (isset($_COOKIE['cart'])) {
            $cart = explode('.', $_COOKIE['cart']);
            $onclick = "addToCart($id);";
            if (in_array($id, $cart)) {
                $btn_value = 'В корзине';
                $btn_id = 'incart';
                $onclick = "removeFromCart($id);";
            }
            if ($shop == 0)
                $onclick = "specifyShop();";
        } else
            $onclick = "askLogin();";
        echo '<div id="part">'
        . "<a href='part.php?part_id=$id'><img src='../images/parts/$image'/></a>"
        . "<a id='part_name' href='part.php?part_id=$id'>$name</a>"
        . "<div id='part_price'>$price ₽</div>"
        . "<input class='$btn_id' id='buy_part$id' type=button value='$btn_value' $disabled onclick='$onclick'/>"
        . "<div id='part_stock'>В наличии <b>$in_stock</b> шт.</div>"
        . '</div>';
    }
    if (!isset($flag))
        echo '<h2 style="margin-right: 500px;">По вашему запросу ничего не найдено</h2>';
    echo '</form>';
    while (mysqli_more_results($con))
        mysqli_next_result($con);
}
