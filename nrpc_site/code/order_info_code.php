<?php

if (isset($_REQUEST['ord_id']))
    $id = $_REQUEST['ord_id'];
else {
    header('Location: index.php');
    exit();
}

$saved = '';

if (isset($_REQUEST['finish'])) {
    $sql = "SELECT ordStatus($id, 4) AS 'result';";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    if ($r['result'] == 1)
        $saved = '<span style="color:#008000;">Заказ был успешно завершен!</span>';
    else
        $saved = '<span style="color:#FF0000;">Ошибка при завершении заказа!</span>';
}

if (isset($_REQUEST['cancel'])) {
    $sql = "SELECT ordStatus($id, 3) AS 'result';";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    if ($r['result'] == 1)
        $saved = '<span style="color:#008000;">Заказ был успешно отменен!</span>';
    else
        $saved = '<span style="color:#FF0000;">Ошибка при отмене заказа!</span>';
}

function showOrdInfo($con) {
    global $id;
    $sql = "CALL ordInfo($id);";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $login = $r['login'];
    $shop = $r['shop'];
    $address = $r['address'];
    $status = $r['status'];
    $date = $r['date'];
    echo "<div class='txt'><form name='order_info' method='post' action='order_info.php'><table>"
    . "<tr><td>Пользователь: </td><td>$login</td></tr>"
    . "<tr><td>Магазин: </td><td>$shop ($address)</td></tr>"
    . "<tr><td>Дата: </td><td>$date</td></tr>"
    . "<tr><td>Статус: </td><td>$status</td></tr>"
    . "</table></div></br></br>";
    while (mysqli_more_results($con))
        mysqli_next_result($con);
}

function partsOrder($con) {
    global $id;
    echo "<form name='part_order' method='get' action='order_info.php'><table border='1px'>"
    . "<tr><td>Артикул</td><td>Наименование</td><td>Цена</td><td>Кол-во</td><td>Стоимость</td></tr>";
    $sql = "CALL ordGetParts($id)";
    $query = mysqli_query($con, $sql);
    $sum = 0;
    while ($r = mysqli_fetch_assoc($query)) {
        $part_id = $r['id'];
        $upc = $r['upc'];
        $name = $r['name'];
        $price = $r['price'];
        $count = $r['count'];
        $cost = $price * $count;
        $sum += $cost;
        $cost = number_format($cost, 2, '.', ' ');
        echo "<tr><td>$upc</td><td><a href='../pages/part.php?part_id=$part_id'>$name</a></td><td>$price</td><td>$count</td><td>$cost</td></tr>";
    }
    $link = '"../pages/downloadReceipt.php?ord=' . $id . '"';
    $sum = number_format($sum, 2, '.', ' ');
    echo "</table></br><b style='font-size: 24px; margin-right: 20px;'>Итого: $sum рублей</b> <button class='btn' type='button' onclick='location.href=" . $link . "'>Скачать чек</button></form>";
}
