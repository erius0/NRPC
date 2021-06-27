<?php

$data = ['', '', '', -1];

if (isset($_REQUEST['show_users'])) {
    $data[0] = $_REQUEST['user_login'];
    $data[1] = $_REQUEST['user_phone'];
    $data[2] = $_REQUEST['user_email'];
    $data[3] = $_REQUEST['user_admin'];
}

function showUsers($con) {
    global $data;
    if (isset($_REQUEST['show_users'])) {
        $login = $data[0];
        $phone = $data[1];
        $email = $data[2];
        $is_admin = $data[3];
        echo "<form name='users' method='get' action='users.php'><table border='1px'>"
        . "<tr><td>ID</td><td>Логин</td><td>Номер телефона</td><td>Эл. почта</td><td>Админ</td><td>Подробности</td></tr>";
        $sql = "CALL selectUsers('$login', '$phone', '$email', $is_admin);";
        $query = mysqli_query($con, $sql);
        while ($r = mysqli_fetch_assoc($query)) {
            $id = $r['id'];
            $login = $r['login'];
            $name = $r['name'];
            $surname = $r['surname'];
            $phone = $r['phone'];
            $email = $r['email'];
            $address = $r['address'];
            $is_admin = $r['is_admin'] == 1 ? 'Да' : 'Нет';
            $host = $_SERVER['HTTP_HOST'];
            $link = "http://$host/admin/user_info.php?user_id=";
            $final_link = $link . $id;
            $btn = "<input class='btn' type=button name='ord_info$id' value='Посмотреть' onclick='openWindow(" . '"' . $final_link . '"' . ");'/>";
            echo "<tr><td>$id</td><td>$login</td><td>$phone</td><td>$email</td><td>$is_admin</td><td>$btn</td></tr>";
        }
        echo "</table></form>";
    }
}
