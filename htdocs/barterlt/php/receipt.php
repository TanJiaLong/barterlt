<?php
if(!isset($_POST)){
    $response = array("status"=> "failed", "data"=> null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$status = $_POST['status'];
if($status == "false"){
    $response = array("status"=> "success", "data"=> null);
    sendJsonResponse($response);
    die();
}


$orderBill = $_POST['orderBill'];
$itemId = $_POST['itemId'];
$itemQuantity = $_POST['itemQuantity'];
$itemValue = $_POST['itemValue'];
$orderQuantity = $_POST['orderQuantity'];
$orderAmount = $_POST['orderAmount'];
$orderUserId = $_POST['orderUserId'];
$orderSellerId = $_POST['orderSellerId'];


// Update the quantity of that item
if($itemQuantity - $orderQuantity > 0){
    $sqlUpdateItem = "UPDATE `tbl_items` SET `item_quantity` = ($itemQuantity - $orderQuantity)
                                         WHERE `item_id` = '$itemId'";
    if($conn->query($sqlUpdateItem)){

    }
}else if($itemQuantity - $orderQuantity == 0){

    $sqlUpdateItem = "UPDATE `tbl_items` SET `item_quantity` = 0
                                         WHERE `item_id` = '$itemId'";
    if($conn->query($sqlUpdateItem)){

    }
}else{
    $response = array("status"=> "failed", "data"=> null);
    sendJsonResponse($response);
    die();
}

// Delete that cart
$cartId = $_POST['cartId'];
$sqlDeleteCart = "DELETE FROM `tbl_carts` WHERE `cart_id` = '$cartId'";
if($conn->query($sqlDeleteCart)){

}

$sqlInsertOrder = "INSERT INTO `tbl_orders`(`order_bill`, 
                                            `order_itemId`,
                                            `order_quantity`,
                                            `order_amount`,
                                            `order_userId`,
                                            `order_sellerId`,
                                            `order_status`) 
                                    VALUES('$orderBill',
                                           '$itemId',
                                           '$orderQuantity',
                                           '$orderAmount',
                                           '$orderUserId',
                                           '$orderSellerId',
                                           'New')";

if($conn->query($sqlInsertOrder) === true){
    $sqlLoadOrder = "SELECT * FROM `tbl_orders` WHERE `order_bill` = '$orderBill'";
    $result = $conn->query($sqlLoadOrder);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $order = array();
            $order['orderId'] = $row['order_id'];
            $order['orderBill'] = $row['order_bill'];
            $order['orderItemId'] = $row['order_itemId'];
            $order['orderQuantity'] = $row['order_quantity'];
            $order['orderAmount'] = $row['order_amount'];
            $order['orderUserId'] = $row['order_userId'];
            $order['orderSellerId'] = $row['order_sellerId'];
            $order['orderStatus'] = $row['order_status'];
            $order['orderDate'] = $row['order_date'];

            $response = array("status" => "success", "data"=> $order);
            sendJsonResponse($response);
        }
    }else{
        $response = array("status" => "failed", "data"=> null);
        sendJsonResponse($response);
    }
}else{
    $response = array("status" => "failed", "data"=> null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
	echo json_encode($sentArray);
}
?>