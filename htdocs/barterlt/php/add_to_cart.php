<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data'=> null);
    sendJsonResponse($response);
    die();
}

include_once('dbconnect.php');

$cartItemId = $_POST['cartItemId'];
$cartQuantity = $_POST['cartQuantity'];
$cartPrice = $_POST['cartPrice'];
$cartUserId = $_POST['cartUserId'];
$cartSellerId = $_POST['cartSellerId'];

$checkItemsRecord = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId' AND 
                                                     `cart_itemId` = '$cartItemId'";
$result = $conn->query($checkItemsRecord);
$numOfResult = $result->num_rows;

if($numOfResult > 0){
    $sql = "UPDATE `tbl_carts` SET `cart_quantity`= (cart_quantity + $cartQuantity),
                                   `cart_price`= (cart_price + $cartPrice) 
                                WHERE `cart_userId` = '$cartUserId' AND  
                                      `cart_itemId` = '$cartItemId'";
}else{
    $sql = "INSERT INTO `tbl_carts`(`cart_itemId`,
                                `cart_quantity`,
                                `cart_price`,
                                `cart_userId`,
                                `cart_sellerId`)
              VALUES('$cartItemId',
                     '$cartQuantity',
                     '$cartPrice',
                     '$cartUserId',
                     '$cartSellerId')";
}

if($conn->query($sql) === true){
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}
else {
    $response = array('status' => 'failed','data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sendArray){
    header('Content-Type: application/json');
    echo json_encode($sendArray);
}
?>