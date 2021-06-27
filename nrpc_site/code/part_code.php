<?php

$part_name = '';

function showPart($con) {
    global $part_name;
    if (isset($_REQUEST['part_id']))
        $id = $_REQUEST['part_id'];
    else {
        header('Location: ../index.php');
        exit();
    }
    if (isset($_COOKIE['login'])) {
        $login = $_COOKIE['login'];
        $sql = "SELECT getUserShop('$login') AS 'result';";
        $query = mysqli_query($con, $sql);
        $r = mysqli_fetch_assoc($query);
        $shop = $r['result'];
    } else
        $shop = 0;
    $sql = "CALL partInfo($id, $shop);";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $upc = $r['upc'];
    $name = $r['name'];
    $price = number_format($r['price'], 2, ',', ' ');
    $description = $r['description'];
    $image = $r['image'];
    $category = $r['category_name'];
    $supplier = $r['supplier_name'];
    $in_stock = $r['in_stock'];
    $btn_value = 'Нет в наличии';
    $disabled = 'disabled';
    $btn_id = 'out';
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
    $part_name = $name;
    echo "<div id='part_display'>"
    . "<img src='../images/parts/$image'/>"
    . "<div id='display_name'>$name</div>"
    . "<div id='display_price'>$price ₽</div>"
    . "<input class='$btn_id' id='buy_part$id' type=button value='$btn_value' $disabled onclick='$onclick'/>"
    . "</div>"
    . "<h2>Описание:</h2><span id='description'>$description</span></br></br>"
    . "Код товара: $upc</br></br>";
    while (mysqli_more_results($con))
        mysqli_next_result($con);

    $sql = "CALL partStock($id);";
    $query = mysqli_query($con, $sql);
    echo '<h2>Наличие:</h2></br><table id="stock_table" cellpadding="8px">';
    while ($r = mysqli_fetch_assoc($query)) {
        $shop_name = $r['name'];
        $count = $r['count'];
        $address = $r['address'];
        echo "<tr><td>$shop_name: </td><td><b>$count шт.</b></td><td>($address)</td></tr>";
    }
    echo "</table>";
}
