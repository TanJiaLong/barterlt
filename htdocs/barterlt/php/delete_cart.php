<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

//Delete specific data
if(isset($_POST['cartId'])){
    $cartid = $_POST['cartId'];
    $sqldeletecart = "DELETE FROM `tbl_carts` WHERE `cart_id` = '$cartid'";
    if ($conn->query($sqldeletecart) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else{
    //delete all cart for that user (buyer)
    $cart_userId = $_POST['cart_userId'];
    $sqlclearcart = "DELETE FROM `tbl_carts` WHERE `cart_userId` = $cart_userId";
    if ($conn->query($sqlclearcart) === TRUE) {
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