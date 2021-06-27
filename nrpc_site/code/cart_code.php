<?php

if (!isset($_COOKIE['cart'])) {
    header('Location: ../index.php');
    exit();
}

function showCartParts($con) {
    $ids = '';
    $cart_parts = explode('.', $_COOKIE['cart']);
    echo "<form name='make_order' method='post' action='order.php'>";
    foreach ($cart_parts as $id) {
        if (is_numeric($id)) {
            if (isset($_COOKIE['login'])) {
                $login = $_COOKIE['login'];
                $sql = "SELECT getUserShop('$login') AS 'result';";
                $query = mysqli_query($con, $sql);
                $r = mysqli_fetch_assoc($query);
                $shop = $r['result'];
                $flag = true;
            }
            $sql = "CALL partInfo($id, $shop)";
            $query = mysqli_query($con, $sql);
            $r = mysqli_fetch_assoc($query);
            $name = $r['name'];
            $price = $r['price'];
            $image = $r['image'];
            $in_stock = $r['in_stock'];
            if ($in_stock > 0) {
                echo "<div class='partcart' id='part_entry$id'>"
                . "<a href='part.php?part_id=$id'><img src='../images/parts/$image'/></a>"
                . "<a href='part.php?part_id=$id'>$name</a>"
                . "<div class='cart_price' id='price_display$id'>$price ₽</div>"
                . "<div class='cart_stock'>В наличии <b>$in_stock</b> шт.</div>"
                . "<div class='count'><button type='button' class='input_btn' id='down$id' onclick='down($id)'>-</button>&nbsp;"
                . "<input class='input_value' id='value$id' name='count$id' value='1' min=1 type='number' max=$in_stock readonly></input>&nbsp;"
                . "<button type='button' class='input_btn' id='up$id' onclick='up($id)'>+</button></div>"
                . "<input type=hidden id='price$id' value=$price />"
                . "</div>";
            } else
                echo "<script>removeFromCart($id);</script>";
            while (mysqli_more_results($con))
                mysqli_next_result($con);
        }
    }
    if (isset($flag)) {
        $ids = substr($_COOKIE['cart'], 2);
        echo "<input id='make_order' class='btn' type='submit' name='order' value='Оформить заказ'/><input type=hidden name='part_ids' value='$ids'/>";
    } else
        echo 'Ваша корзина пуста, зайдите в <a href="shopping.php">каталог</a> и выберите товары для покупки';
    echo '</form>';
}
