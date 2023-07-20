<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if(!isset($_POST['lat'])){
    $orderid = $_POST['orderid'];
    $status = $_POST['status'];

    $sqlupdate = "UPDATE `tbl_orders` SET `order_status`='$status' WHERE order_id = '$orderid'";

    if ($conn->query($sqlupdate) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}else{
    $orderid = $_POST['orderid'];
    $status = $_POST['status'];
    $lat = $_POST['lat'];
    $lng = $_POST['lng'];

    $sqlupdate = "UPDATE `tbl_orders` SET `order_status`='$status', `order_longitude` = '$lng', `order_latitude` = '$lat' WHERE order_id = '$orderid'";

    if ($conn->query($sqlupdate) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>