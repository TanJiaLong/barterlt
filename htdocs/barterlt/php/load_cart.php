<?php
if(!isset($_POST)){
	$response = array("staus"=>"failed","data"=>null);
	sendJsonResponse($response);
	die();
}
include_once('dbconnect.php');

$cart_userId = $_POST["cart_userId"];

$sqlLoadCarts = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cart_userId'";
$result = $conn->query($sqlLoadCarts);
$numOfCarts = $result->num_rows;

$carts["carts"] = array();

//Storing the list of the itemID for further looping
$itemIdList = array();
$itemList["items"] = array();

if($numOfCarts > 0){
	while($row = $result->fetch_assoc()){
		$cartList = array();

		$cartList['cart_id'] = $row['cart_id'];
		$cartList['cart_itemId'] = $row['cart_itemId'];
		$cartList['cart_quantity'] = $row['cart_quantity'];
		$cartList['cart_price'] = $row['cart_price'];
		$cartList['cart_userId'] = $row['cart_userId'];
		$cartList['cart_sellerId'] = $row['cart_sellerId'];
		$cartList['cart_date'] = $row['cart_date'];

		array_push($carts['carts'], $cartList);

		//store id of items accordingly 
		//To query the item name in the order
		array_push($itemIdList, $cartList['cart_itemId']);
	}
} else {
	$response = array('status'=> 'failed: No Cart Found', 'data'=> null, 'sql'=> $sqlLoadCarts);
	sendJsonResponse($response);
	die();
}

$numOfItems = 0;
for($i = 0; $i < count($itemIdList); ++$i){
	$itemId = $itemIdList[$i];
	$sqlLoadItemNames = "SELECT * FROM `tbl_items` WHERE `item_id` = '$itemId'";
	$result = $conn->query($sqlLoadItemNames);
	$numOfItems = $result->num_rows;
	if($numOfItems > 0){
		// while($row = $result->fetch_assoc()){
		// 	$itemName = $row['item_name'];
		// 	array_push($itemNameList,$itemName);
		// }
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

if($numOfCarts > 0 && $numOfItems > 0 ){
	$response = array("status" => "success", "cartData" => $carts, "itemData" => $itemList);
	sendJsonResponse($response);
}else{
	$response = array("status" => "failed", "cartData" => null, "itemName" => null);
	sendJsonResponse($response);
}



function sendJsonResponse($sentArray){
	header("Content-Type: application/json");
	echo json_encode($sentArray);
}
?>