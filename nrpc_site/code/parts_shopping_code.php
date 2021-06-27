<?php

function getCategories($con) {
    $categories = [];
    $sql = "SELECT * FROM get_categories;";
    $query = mysqli_query($con, $sql);
    $i = 0;
    while ($r = mysqli_fetch_assoc($query)) {
        $categories[$i][0] = $r['id'];
        $categories[$i][1] = $r['name'];
        $i++;
    }
    return $categories;
}

function getSuppliers($con) {
    $suppliers = [];
    $sql = "SELECT * FROM get_suppliers;";
    $query = mysqli_query($con, $sql);
    $i = 0;
    while ($r = mysqli_fetch_assoc($query)) {
        $suppliers[$i][0] = $r['id'];
        $suppliers[$i][1] = $r['name'];
        $i++;
    }
    return $suppliers;
}

function selectCategory($arr, $def, $sel, $allowAll) {
    $result = "<select class='filter' name='$sel'>";
    $selected = '';
    if ($def == 0)
        $selected = 'selected';
    if ($allowAll == true)
        $result .= "<option value=0 $selected>Все</option>";
    for ($i = 0; $i < sizeof($arr); $i++) {
        $id = $arr[$i][0];
        $name = $arr[$i][1];
        $selected = $id == $def ? 'selected' : '';
        $result .= "<option value=$id $selected>$name</option>";
    }
    $result .= '</select> ';
    return $result;
}

function selectSupplier($arr, $def, $sel, $allowAll) {
    $result = "<select class='filter' name='$sel'>";
    $selected = '';
    if ($def == 0)
        $selected = 'selected';
    if ($allowAll == true)
        $result .= "<option value=0 $selected>Все</option>";
    for ($i = 0; $i < sizeof($arr); $i++) {
        $id = $arr[$i][0];
        $name = $arr[$i][1];
        $selected = $id == $def ? 'selected' : '';
        $result .= "<option value=$id $selected>$name</option>";
    }
    $result .= '</select> ';
    return $result;
}
