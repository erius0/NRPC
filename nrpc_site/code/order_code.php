<?php

if (isset($_REQUEST['part_ids']))
    setcookie('cart', '_', 0, '/');

require_once '../dompdf/autoload.inc.php';

use Dompdf\Dompdf;

function orderConfirmed($con) {
    if (isset($_REQUEST['part_ids'])) {
        $login = $_COOKIE['login'];
        $sql = "SELECT createNewOrd('$login') AS 'result';";
        $query = mysqli_query($con, $sql);
        $r = mysqli_fetch_assoc($query);
        $ord_id = $r['result'];
        $ids = explode('.', $_REQUEST['part_ids']);
        $sql = "CALL ordInfo($ord_id);";
        $query = mysqli_query($con, $sql);
        $r = mysqli_fetch_assoc($query);
        $shop = $r['shop'];
        $date = $r['date'];
        $address = $r['address'];
        while (mysqli_more_results($con))
            mysqli_next_result($con);
        $i = 0;
        $sum = 0;
        $dompdf = new Dompdf();
        $html = '';
        $html .= "<style type='text/css'>html * { font-family: DejaVu Sans; }"
                . "table { text-align: center; font-size: 12px; }</style>";
        $html .= "<h2>Чек к заказку $ord_id от $date</h2></br></br><table border='1px'>";
        $html .= "<tr><td>Номер</td><td>Артикул</td><td>Наименование</td><td>Цена</td><td>Кол-во</td><td>Стоимость</td></tr>";
        foreach ($ids as $id) {
            $count = $_REQUEST["count$id"];
            $sql = "SELECT modifyOrder($ord_id, $id, $count) AS 'result';";
            $query = mysqli_query($con, $sql);
            $r = mysqli_fetch_assoc($query);
            if ($r['result'] != 1) {
                echo 'Ошибка при создании заказа';
                return;
            }
            $sql = "CALL partInfo($id, 0);";
            $query = mysqli_query($con, $sql);
            $r = mysqli_fetch_assoc($query);
            $price = $r['price'];
            $price_dec = number_format($price, 2, '.', ' ');
            $upc = $r['upc'];
            $name = $r['name'];
            $sum_dec = number_format($price * $count, 2, '.', ' ');
            $index = $i + 1;
            $html .= "<tr><td>$index</td><td>$upc</td><td>$name</td><td>$price_dec</td><td>$count</td><td>$sum_dec</td></tr>";
            $i++;
            $sum += $price * $count;
            while (mysqli_more_results($con))
                mysqli_next_result($con);
        }
        $sum_final = number_format($sum, 2, '.', ' ');
        $html .= "</table><h3>Итого: $sum_final рублей</h3></br></br><h4>Заказ готов к выдаче и ждет оплаты в магазине $shop по адресу $address</h4>";
        $sql = "SELECT saveCart('$login', '_');";
        $query = mysqli_query($con, $sql);
//    $sql = "SELECT getEmail('$login') AS 'email';";
//    $query = mysqli_query($con, $sql);
//    $r = mysqli_fetch_assoc($query);
//    $email = $r['email'];
//    $headers = "From: nrpc <nrpc@nrpc.ru>\n";
//    $headers .= "Cc: nrpc <nrpc@nrpc.ru>\n";
//    $headers .= "X-Sender: nrpc <nrpc@nrpc.ru>\n";
//    $headers .= 'X-Mailer: PHP/' . phpversion();
//    $headers .= "X-Priority: 1\n";
//    $headers .= "Return-Path: nrpc@nrpc.ru\n";
//    $headers .= "MIME-Version: 1.0\r\n";
//    $headers .= "Content-Type: text/plain; charset=iso-8859-1\n";
//    $res = mail($email, 'Заказ', 'Заказ успешно оформлен!', $headers);
        $dompdf->load_html($html);
        $dompdf->render();
        $output = $dompdf->output();
        file_put_contents("../receipt/$ord_id.pdf", $output);
        $link = '"downloadReceipt.php?ord=' . $ord_id . '"';
        echo "Ваш заказ успешно офрмлен!</br></br><button class='btn' type='button' onclick='location.href=" . $link . "'>Скачать чек</button>";
    } else {
        header('Location: ../index.php');
        exit();
    }
}
