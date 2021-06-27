<?php

$msgs = ["Такой логин уже существует</br>", "Данный номер телефона уже занят другим пользователем</br>", "Данная почта уже занята другим пользователем</br>", "Неправильный номер телефона</br>", "Заполните все поля</br>"];
$msg = "";
$error = false;

$data = ['', '', '', '', '', ''];

if (isset($_COOKIE['login'])) {
    header('Location: ../index.php');
    exit();
}

if (isset($_REQUEST['sub'])) {
    $login = $_REQUEST['login'];
    $password = $_REQUEST['password'];
    $name = $_REQUEST['name'];
    $surname = $_REQUEST['surname'];
    $phone = $_REQUEST['phone'];
    $email = $_REQUEST['email'];
    $address = $_REQUEST['address'];
    $func = 'result';

    $data[0] = $name;
    $data[1] = $surname;
    $data[2] = $login;
    $data[3] = $phone;
    $data[4] = $email;
    $data[5] = $address;

    if (strlen($phone) > 12) {
        $data[3] = '';
        $msg = $msgs[3];
        $error = true;
        return;
    }
    if ($name == null || $surname == null || $login == null || $phone == null || $email == null || $address == null || $password == null) {
        $msg = $msgs[4];
        $error = true;
        return;
    }
    $sql = "SELECT addNewUser('$login', '$password', '$name', '$surname', '$phone', '$email', '$address') AS '$func';";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $result = $r["$func"];

    if ($result == 3) {
        setcookie('login', $login, 0, '/');
        setcookie('cart', '_', 0, '/');
        header('Location: ../index.php');
        exit();
    } else {
        $data[$result + 2] = '';
        $msg = $msgs[$result];
        $error = true;
    }
}
    