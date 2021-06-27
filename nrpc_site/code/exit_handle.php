<?php

if (isset($_REQUEST['exit']) && isset($_COOKIE['login'])) {
    $login = $_COOKIE['login'];
    $cart = $_COOKIE['cart'];
    $sql = "SELECT saveCart('$login', '$cart');";
    $query = mysqli_query($con, $sql);
    unset($_COOKIE['cart']);
    setcookie('cart', null, time() - 3600, '/');
    unset($_COOKIE['login']);
    setcookie('login', null, time() - 3600, '/');
    unset($_COOKIE['is_admin']);
    setcookie('is_admin', null, time() - 3600, '/');
}