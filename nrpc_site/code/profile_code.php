<?php

$name = '';
$surname = '';
$phone = '';
$email = '';
$address = '';
$pref_shop_id = 0;

if (isset($_COOKIE['login'])) {
    global $name, $surname, $phone, $email, $address, $pref_shop_id;
    $login = $_COOKIE['login'];
    $sql = "CALL userInfo('$login', 0);";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $name = $r['name'];
    $surname = $r['surname'];
    $phone = $r['phone'];
    $email = $r['email'];
    $address = $r['address'];
    $pref_shop_id = $r['pref_shop_id'];
    while (mysqli_more_results($con))
        mysqli_next_result($con);
} else {
    header('Location: ../index.php');
    exit();
}

if (isset($_REQUEST['save_changes'])) {
    $login = $_COOKIE['login'];
    $name = $_REQUEST['name'];
    $surname = $_REQUEST['surname'];
    $phone = $_REQUEST['phone'];
    $email = $_REQUEST['email'];
    $address = $_REQUEST['address'];
    $shop = $_REQUEST['shop'];
    $sql = "SELECT modifyUser('$login', '$name', '$surname', '$phone', '$email', '$address', $shop)";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    header('Location: profile.php?saved=1');
    exit();
}

function showProfile($con) {
    global $name, $surname, $phone, $email, $address, $pref_shop_id;
    $shop_select = selectShops($con, 'shop', $pref_shop_id);
    echo '<form name="profile" method="post" action="profile.php"><table>'
    . "<tr><td><div class='txt'>Имя: </div></td><td><input class='fld' type='text' name='name' value='$name'/></td></tr>"
    . "<tr><td><div class='txt'>Фамилия: </div></td><td><input class='fld' type='text' name='surname' value='$surname'/></td></tr></td></tr>"
    . "<tr><td><div class='txt'>Телефон: </div></td><td><input class='fld' type='text' name='phone' value='$phone'/></td></tr>"
    . "<tr><td><div class='txt'>Эл. почта: </div></td><td><input class='fld' type='text' name='email' value='$email'/></td></tr>"
    . "<tr><td><div class='txt'>Адрес: </div></td><td><input class='fld' type='text' name='address' value='$address'/></td></tr>"
    . "<tr><td><div class='txt'>Магазин: </div></td><td>$shop_select</td></tr>"
    . '</table></br><input class="btn" type="submit" name="save_changes" value="Сохранить изменения"/></form></br>';
    if (isset($_REQUEST['saved']))
        echo '<span style="color:#008000; font-size: 24px;"><b>Изменения успешно сохранены!</b></span>';
}

function selectShops($con, $sel, $def) {
    $result = '';
    $result .= "<select class='fld' name='$sel'>";
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
    return $result;
}

function showOrders($con) {
    $login = $_COOKIE['login'];
    $sql = "CALL userOrds('$login', 0)";
    $query = mysqli_query($con, $sql);
    $orders = '<form name="orders" method="get" action="profile.php"><table cellpadding="10px" class="txt" border="1px">'
            . '<tr><td>Номер</td><td>Магазин</td><td>Дата</td><td>Статус</td><td>Чек</td></tr>';
    while ($r = mysqli_fetch_assoc($query)) {
        $ord_id = $r['id'];
        $shop = $r['shop'];
        $date = $r['date'];
        $status = $r['status'];
        $link = '"downloadReceipt.php?ord=' . $ord_id . '"';
        $receipt = "<button class='btn' type='button' onclick='location.href=" . $link . "'>Скачать чек</button>";
        $orders .= "<tr><td>$ord_id</td><td>$shop</td><td>$date</td><td>$status</td><td>$receipt</td></tr>";
        $flag = true;
    }
    $orders .= '</table></form>';
    if (isset($flag))
        echo $orders;
    else
        echo 'На данный момент у вас нет заказов';
}
