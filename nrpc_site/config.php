<?php

header('Content-Type:text/html; charset=utf-8');

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

if ($_SERVER['HTTP_HOST'] == 'localhost') {
    $host = 'localhost';
    $user = 'root';
    $pass = 'vertrigo';
    $db = 'pc_parts_new';
} else {
    $host = 'localhost';
    $user = 'id16898488_egor';
    $pass = 'Egor-20052003';
    $db = 'id16898488_nrpc';
}

$con = mysqli_connect($host, $user, $pass, $db);