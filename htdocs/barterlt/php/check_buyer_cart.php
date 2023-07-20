<?php
	if (!isset($_POST)) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	include_once('dbconnect.php');
	
    $itemId = $_POST['itemId'];
	$cartBuyerId = $_POST['cartBuyerId'];
	
	$sqlLoadCartQuantity = "SELECT `cart_quantity` FROM `tbl_carts` WHERE `cart_itemId` = '$itemId' AND `cart_userId` = '$cartBuyerId'";

	$result = $conn->query($sqlLoadCartQuantity);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $itemQuantityInCart = $row['cart_quantity'];
        }
        $response = array("status"=>"success", "itemQuantityInCart"=>$itemQuantityInCart);
        sendJsonResponse($response);
    } else{
        $response = array("status" => "success", "itemQuantityInCart" => "0");
		sendJsonResponse($response);
    }
    
	
	function sendJsonResponse($sentArray){
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>