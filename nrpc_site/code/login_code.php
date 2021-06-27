<?php

$msg = "Неверный логин или пароль</br>";
$error = false;

if (isset($_COOKIE['login'])) {
    header('Location: ../index.php');
    exit();
}

if (isset($_REQUEST['sub'])) {
    $login = $_REQUEST['login'];
    $password = $_REQUEST['password'];
    $func = 'result';

    $sql = "SELECT handleLogin('$login', '$password') AS '$func';";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $result = $r["$func"];

    if ($result != '0') {
        setcookie('login', $login, 0, '/');
        setcookie('cart', $result, 0, '/');

        $sql = "SELECT isUserAdmin('$login') AS '$func';";
        $query = mysqli_query($con, $sql);
        $r = mysqli_fetch_assoc($query);
        $result = $r["$func"];
        if ($result == 1)
            setcookie('is_admin', $result, 0, '/');

        header('Location: ../index.php');
        exit();
    } else {
        $error = true;
    }
}
