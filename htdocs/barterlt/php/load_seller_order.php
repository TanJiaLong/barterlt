<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


$sellerid = $_POST['sellerid'];	
$sqlorder = "SELECT * FROM `tbl_orders` WHERE `order_sellerId` = '$sellerid'";
$result = $conn->query($sqlorder);
$numOfOrders = $result->num_rows;

$orderList["orders"] = array();

//Storing the list of the itemID for further looping
$itemIdList = array();
$itemList["items"] = array();

if ($numOfOrders > 0) {
	while ($row = $result->fetch_assoc()) {
        $order = array();
        $order['orderId'] = $row['order_id'];
        $order['orderBill'] = $row['order_bill'];
        $order['orderItemId'] = $row['order_itemId'];
        $order['orderQuantity'] = $row['order_quantity'];
        $order['orderAmount'] = $row['order_amount'];
        $order['orderUserId'] = $row['order_userId'];
        $order['orderSellerId'] = $row['order_sellerId'];
        $order['orderStatus'] = $row['order_status'];
        $order['orderLatitude'] = $row['order_latitude'];
        $order['orderLongitude'] = $row['order_longitude'];
        $order['orderDate'] = $row['order_date'];
        
        array_push($orderList["orders"] ,$order);

        //store id of items accordingly 
		//To query the item name in the order
		array_push($itemIdList, $order['orderItemId']);
    }

    $numOfItems = 0;
    for($i = 0; $i < count($itemIdList); ++$i){
        $itemId = $itemIdList[$i];
        $sqlLoadItems = "SELECT * FROM `tbl_items` WHERE `item_id` = '$itemId' ORDER BY 'order_bill' DESC";
        $result = $conn->query($sqlLoadItems);
        $numOfItems = $result->num_rows;
        if($numOfItems > 0){
            while($row = $result->fetch_assoc()){
                $item = array();
                    
                $item['item_id'] = $row['item_id'];
                $item['user_id'] = $row['user_id'];
                $item['item_name'] = $row['item_name'];
                $item['item_desc'] = $row['item_desc'];
                $item['item_category'] = $row['item_category'];
                $item['item_quantity'] = $row['item_quantity'];
                $item['item_value'] = $row['item_value'];
                $item['state'] = $row['state'];
                $item['locality'] = $row['locality'];
                $item['latitude'] = $row['latitude'];
                $item['longitude'] = $row['longitude'];
                $item['reg_date'] = $row['reg_date'];
                    
                array_push($itemList['items'], $item);
            }
        }
    }

    if($numOfOrders > 0){
        $response = array("status" => "success", "orders" => $orderList, "items" => $itemList);
        sendJsonResponse($response);
    }else{
        $response = array("status" => "success", "orders" => null, "item" => null);
        sendJsonResponse($response);
    }
}else{
     $response = array('status' => 'failed', "orders" => null, "item" => null);
    sendJsonResponse($response);
}



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}