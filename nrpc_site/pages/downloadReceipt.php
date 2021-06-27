<?php

if (isset($_REQUEST['ord'])) {
    $ord = $_REQUEST['ord'];
    $file = "../receipt/$ord.pdf";

    if (!file_exists($file))
        die("I'm sorry, the file doesn't seem to exist.");
    $type = filetype($file);
    header("Content-type: $type");
    header("Content-Disposition: attachment;filename=$ord.pdf");
    header("Content-Transfer-Encoding: binary");
    header('Pragma: no-cache');
    header('Expires: 0');
    set_time_limit(0);
    ob_clean();
    flush();
    readfile($file);
    exit();
} else {
    header('Location: ../index.php');
    exit();
}