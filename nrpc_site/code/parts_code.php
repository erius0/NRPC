<?php

$data = ['', '', 0.00, 1000000.00, 0, 0];
$categories = getCategories($con);
$suppliers = getSuppliers($con);

if (isset($_REQUEST['parts_show'])) {
    $upc = $_REQUEST['parts_upc'];
    $name = $_REQUEST['parts_name'];
    $price_bottom = $_REQUEST['parts_price_bottom'];
    $price_upper = $_REQUEST['parts_price_upper'];
    $category_id = $_REQUEST['parts_categorys'];
    $supplier_id = $_REQUEST['parts_suppliers'];
    $data[0] = $upc;
    $data[1] = $name;
    $data[2] = $price_bottom;
    $data[3] = $price_upper;
    $data[4] = $category_id;
    $data[5] = $supplier_id;
}

function showParts($con) {
    if (isset($_REQUEST['parts_show'])) {
        global $data;
        $host = $_SERVER['HTTP_HOST'];
        $link = "http://$host/admin/stock.php?part_id=";
        $upc = $_REQUEST['parts_upc'];
        $name = $_REQUEST['parts_name'];
        $price_bottom = $_REQUEST['parts_price_bottom'];
        $price_upper = $_REQUEST['parts_price_upper'];
        $category_id = $_REQUEST['parts_categorys'];
        $supplier_id = $_REQUEST['parts_suppliers'];
        $data[0] = $upc;
        $data[1] = $name;
        $data[2] = $price_bottom;
        $data[3] = $price_upper;
        $data[4] = $category_id;
        $data[5] = $supplier_id;
        $category_arr = getCategories($con);
        $supplier_arr = getSuppliers($con);
        $sql = "CALL selectParts('$upc', '$name', $price_bottom, $price_upper, $category_id, $supplier_id);";
        $query = mysqli_query($con, $sql);
        echo '<form name="parts_modify" method="post" action="parts.php"><table border=1px cellspacing=3px>'
        . '<tr><td><b>ID</b></td>'
        . '<td><b>Артикул</b></td>'
        . '<td><b>Наименование</b></td>'
        . '<td><b>Цена</b></td>'
        . '<td><b>Категория</b></td>'
        . '<td><b>Поставщик</b></td>'
        . '<td><b>Подробности</b></td></tr>';
        while ($r = mysqli_fetch_assoc($query)) {
            $id = $r['id'];
            $upc = $r['upc'];
            $name = $r['name'];
            $price = $r['price'];
            $category = $r['category'];
            $supplier = $r['supplier'];
            $final_link = $link . $id;
            echo "<tr><td>$id</td>"
            . "<td>$upc</td>"
            . "<td><a href='../pages/part.php?part_id=$id'>$name</a></td>"
            . "<td>$price</td>"
            . "<td>$category</td>"
            . "<td>$supplier</td>"
            . "<td align='center'><input class='btn' type=button name='stock$id' value='Посмотреть' onclick='openWindow(" . '"' . $final_link . '"' . ");'/></td>";
        }
        echo '</table></br></br></form>';
    }
}

function addPart($con) {
    if (isset($_REQUEST['add_part'])) {
        $upc = $_REQUEST['part_add_upc'];
        $name = $_REQUEST['part_add_name'];
        $price = $_REQUEST['part_add_price'];
        $category = $_REQUEST['part_add_categorys'];
        $supplier = $_REQUEST['part_add_suppliers'];
        $description = $_REQUEST['part_add_description'];
        $path = $_FILES['part_add_image']['name'];
        $ext = pathinfo($path, PATHINFO_EXTENSION);
        $image = "$upc.$ext";
        $moveto = "../images/parts/$image";
        if (move_uploaded_file($_FILES['part_add_image']['tmp_name'], $moveto)) {
            if ($upc != '' && $name != '') {
                $sql = "SELECT addNewPart('$upc', '$name', $price, $category, $supplier, '$description', '$image') AS 'result';";
                $query = mysqli_query($con, $sql);
                $r = mysqli_fetch_assoc($query);
                $result = $r['result'];
                if ($result == 1)
                    echo '<span style="color:#008000;">Товар успешно добавлен!</span>';
                else
                    echo '<span style="color:#FF0000;">Товар с таким артикулом уже существует!</span>';
            } else
                echo '<span style="color:#FF0000;">Заполнены не все поля!</span>';
        } else
            echo '<span style="color:#FF0000;">Ошибка при загрузке изображения!</span>';
    }
}
