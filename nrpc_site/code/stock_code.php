<?php

$file = '';

if (isset($_REQUEST['part_save'])) {
    $id = $_REQUEST['part_id'];
    $upc = $_REQUEST['part_upc'];
    $name = $_REQUEST['part_name'];
    $price = $_REQUEST['part_price'];
    $category = $_REQUEST['part_category'];
    $supplier = $_REQUEST['part_supplier'];
    $description = $_REQUEST['part_description'];
    $file = $_REQUEST['prev_img'];
    $path = $_FILES['part_image']['name'];
    $ext = pathinfo($path, PATHINFO_EXTENSION);
    $image = "$upc.$ext";
    $moveto = "../images/parts/$image";
    $saved = 0;
    if ($path != '')
        $file_moved = move_uploaded_file($_FILES['part_image']['tmp_name'], $moveto);
    else {
        $file_moved = true;
        $image = $file;
    }
    if ($file_moved) {
        $sql = "SELECT modifyPart($id, '$upc', '$name', $price, $category, $supplier, '$description', '$image');";
        $query = mysqli_query($con, $sql);
        $r = mysqli_fetch_assoc($query);
        if (mysqli_more_results($con))
            mysqli_next_result($con);
        $ids = $_REQUEST['shop_ids'];
        $shop_ids = explode(' ', $ids);
        foreach ($shop_ids as &$shop_id) {
            $count = $_REQUEST["shop_count$shop_id"];
            $sql = "SELECT modifySupply($id, $shop_id, $count);";
            $query = mysqli_query($con, $sql);
            $r = mysqli_fetch_assoc($query);
            if (mysqli_more_results($con))
                mysqli_next_result($con);
        }
        $saved = 1;
    }
    header('Cache-Control: no-cache');
    header('Pragma: no-cache');
    header("Location: stock.php?part_id=$id&saved=$saved");
    exit();
}

if (isset($_REQUEST['part_id'])) {
    $id = $_REQUEST['part_id'];
    $sql = "CALL partInfo($id, 0);";
    $query = mysqli_query($con, $sql);
    $r = mysqli_fetch_assoc($query);
    $upc = $r['upc'];
    $name = $r['name'];
    $price = $r['price'];
    $category = $r['category'];
    $supplier = $r['supplier'];
    $description = $r['description'];
    $image = $r['image'];
    if (mysqli_more_results($con))
        mysqli_next_result($con);
    $file = $image;
} else {
    header('Location: index.php');
    exit();
}

function saveSucces() {
    if (isset($_REQUEST['saved'])) {
        $saved = $_REQUEST['saved'];
        if ($saved == 0)
            echo '<span style="color:#FF0000; font-size: 24px;">Произошла ошибка, проверьте введенные данные!</span>';
        if ($saved == 1)
            echo '<span style="color:#008000; font-size: 24px;">Изменения успешно внесены!</span>';
    }
}

function displayStock($con, $id) {
    $sql = "CALL partStock($id);";
    $query = mysqli_query($con, $sql);
    $ids = [];
    $i = 0;
    echo '<table>';
    while ($r = mysqli_fetch_assoc($query)) {
        $shop_id = $r['id'];
        $shop_name = $r['name'];
        $count = $r['count'];
        $ids[$i] = "$shop_id";
        $i++;
        echo "<tr><td>$shop_name: </td><td><input class='filter' type=number name='shop_count$shop_id' min=0 value='$count'/></td></tr>";
    }
    $shop_ids = implode(' ', $ids);
    echo "</table><input type=hidden name='shop_ids' value='$shop_ids'/></br>";
    if (mysqli_more_results($con))
        mysqli_next_result($con);
}
