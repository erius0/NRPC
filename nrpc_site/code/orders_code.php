<?php

$data = ['', '', 0, 0];

if (isset($_REQUEST['orders_show'])) {
    $data[0] = $_REQUEST['orders_id'];
    $data[1] = $_REQUEST['orders_name'];
    $data[2] = $_REQUEST['orders_shop'];
    $data[3] = $_REQUEST['orders_status'];
}

function selectShops($con, $sel, $def) {
    $result = '';
    $result .= "<select class='filter' name='$sel'>";
    if ($def == 0)
        $result .= "<option value=$def>Не выбран</option>";
    $sql = "SELECT * FROM get_shops;";
    $query = mysqli_query($con, $sql);
    while ($r = mysqli_fetch_assoc($query)) {
        $id = $r['id'];
        $name = $r['name'];
        $selected = $def == $id ? 'selected' : '';
        $result .= "<option value=$id $selected>$name</option>";
    }
    $result .= '</select>';
    return $result;
}

function selectStatus($con, $sel, $def) {
    $result = '';
    $result .= "<select class='filter' name='$sel'>";
    if ($def == 0)
        $result .= "<option value=$def>Не выбран</option>";
    $sql = "SELECT * FROM get_status;";
    $query = mysqli_query($con, $sql);
    while ($r = mysqli_fetch_assoc($query)) {
        $id = $r['id'];
        $name = $r['name'];
        $selected = $def == $id ? 'selected' : '';
        $result .= "<option value=$id $selected>$name</option>";
    }
    $result .= '</select>';
    return $result;
}

function showOrders($con) {
    if (isset($_REQUEST['orders_show'])) {
        global $data;
        $ord_id = $data[0];
        $ord_user = $data[1];
        $ord_shop = $data[2];
        $ord_status = $data[3];
        $sql = "CALL selectOrds('$ord_id', '$ord_user', $ord_shop, $ord_status);";
        $query = mysqli_query($con, $sql);
        echo '<form name="parts_modify" method="post" action="parts.php"><table border=1px cellspacing=3px>'
        . '<tr><td><b>Номер</b></td>'
        . '<td><b>Пользователь</b></td>'
        . '<td><b>Магазин</b></td>'
        . '<td><b>Дата</b></td>'
        . '<td><b>Статус</b></td>'
        . '<td><b>Подробности</b></td></tr>';
        $host = $_SERVER['HTTP_HOST'];
        $link = "http://$host/admin/order_info.php?ord_id=";
        while ($r = mysqli_fetch_assoc($query)) {
            $id = $r['id'];
            $login = $r['login'];
            $shop = $r['shop'];
            $date = $r['date'];
            $status = $r['status'];
            $final_link = $link . $id;
            echo "<tr><td>$id</td>"
            . "<td>$login</td>"
            . "<td>$shop</td>"
            . "<td>$date</td>"
            . "<td>$status</td>"
            . "<td align='center'><input class='btn' type=button name='ord_info$id' value='Посмотреть' onclick='openWindow(" . '"' . $final_link . '"' . ");'/></td>";
        }
        echo '</table></br></br></form>';
    }
}
