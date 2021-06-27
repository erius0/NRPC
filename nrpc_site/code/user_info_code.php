<?php

if (isset($_REQUEST['user_id']))
    $id = $_REQUEST['user_id'];
else {
    header('Location: index.php');
    exit();
}

$saved = '';

if (isset($_REQUEST['admin'])) {
    $sql = "SELECT changeAdmin($id) AS 'result';";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    if ($r['result'] == 1)
        $saved = '<span style="color:#008000;">Настройки успешно сохранены</span>';
    else
        $saved = '<span style="color:#FF0000;">Ошибка при сохранении!</span>';
}

function showUserInfo($con) {
    global $id;
    $sql = "CALL userInfo('', $id);";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $login = $r['login'];
    $name = $r['name'];
    $surname = $r['surname'];
    $phone = $r['phone'];
    $email = $r['email'];
    $address = $r['address'];
    $is_admin = $r['is_admin'] == 1 ? 'Да' : 'Нет';
    $value = $is_admin === 'Да' ? 'Забрать права администратора' : 'Дать права администратора';
    echo "<div class='txt'><form name='user_info' method='post' action='user_info.php'><table>"
    . "<tr><td>Логин: </td><td>$login</td></tr>"
    . "<tr><td>Имя: </td><td>$name</td></tr>"
    . "<tr><td>Фамилия: </td><td>$surname</td></tr>"
    . "<tr><td>Номер телефона: </td><td>$phone</td></tr>"
    . "<tr><td>Эл. почта: </td><td>$email</td></tr>"
    . "<tr><td>Адрес: </td><td>$address</td></tr>"
    . "<tr><td>Админ: </td><td>$is_admin</td></tr>"
    . "</table></div></br></br>"
    . "<input class='btn' name='admin' type='submit' value='$value'/><input type='hidden' name='user_id' value='$id'/>";
    while (mysqli_more_results($con))
        mysqli_next_result($con);
}

function showOrders($con) {
    global $id;
    $sql = "CALL userOrds('', $id)";
    $query = mysqli_query($con, $sql);
    $orders = '<form name="orders" method="get" action="profile.php"><table cellpadding="10px" class="txt" border="1px">'
            . '<tr><td>Номер</td><td>Магазин</td><td>Дата</td><td>Статус</td><td>Чек</td></tr>';
    while ($r = mysqli_fetch_assoc($query)) {
        $ord_id = $r['id'];
        $shop = $r['shop'];
        $date = $r['date'];
        $status = $r['status'];
        $link = '"../pages/downloadReceipt.php?ord=' . $ord_id . '"';
        $receipt = "<button class='btn' type='button' onclick='location.href=" . $link . "'>Скачать чек</button>";
        $orders .= "<tr><td><a href='order_info.php?ord_id=$ord_id'>$ord_id</a></td><td>$shop</td><td>$date</td><td>$status</td><td>$receipt</td></tr>";
        $flag = true;
    }
    $orders .= '</table></form>';
    if (isset($flag))
        echo $orders;
    else
        echo 'На данный момент у пользователя нет заказов';
}
