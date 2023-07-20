<?php
if(!isset($_POST)){
	$response = array("staus"=>"failed","data"=>null);
	sendJsonResponse($response);
	die();
}
include_once('dbconnect.php');

//set each page to display 6 records
$results_per_page = 6;

//set current page number to be displayed
if(isset($_POST['pageNo'])){
	$pageNo = $_POST['pageNo'];
}else{
	$pageNo = 1;
}
$first_result_for_that_page = ($pageNo - 1) * $results_per_page;


if(isset($_POST['cartUserId'])){
	$cartUserId = $_POST['cartUserId'];
}else{
	$cartUserId = 0;
}

//check categories first
if(isset($_POST['selectedCategory']) && !empty($_POST['selectedCategory'])){
	$selectedCategory = "'".$_POST['selectedCategory']."'";

	//item page display the 'seller'
	if(isset($_POST['userid'])){
		if($_POST['userid'] != 'na'){
			$userid = $_POST["userid"];
			$sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_category` IN ($selectedCategory) AND user_id = '$userid' AND `item_quantity` > '0'";
			$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$userid'";
		}else{
			$sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_category` IN ($selectedCategory) AND `item_quantity` > '0'";
			$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId'";
		}
	}
	//search page (with search keywords)
	else if(isset($_POST['search'])){
		$search = $_POST["search"];
		$sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_category` IN ($selectedCategory) AND (item_name LIKE '%$search%' OR item_desc LIKE '%$search%') AND `item_quantity` > '0'";
		$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId'";
	}
	//search page
	else{
		$sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_category` IN ($selectedCategory) AND `item_quantity` > '0'";
		$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId'";
	}
}else{
	if(isset($_POST['userid'])){
		if($_POST['userid'] != 'na'){
			$userid = $_POST["userid"];
			$sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid' AND `item_quantity` > '0'";
			$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$userid'";
		}else{
			$sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_quantity` > '0'";
			$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId'";
		}
	}else if(isset($_POST['search'])){
		$search = $_POST["search"];
		$sqlloaditems = "SELECT * FROM `tbl_items` WHERE (item_name LIKE '%$search%' OR item_desc LIKE '%$search%') AND `item_quantity` > '0'";
		$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId'";
	}else{
		$sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_quantity` > '0'";
		$sqlcart = "SELECT * FROM `tbl_carts` WHERE `cart_userId` = '$cartUserId'";
	}
}

//cart quantity
if (isset($sqlcart)){
	$resultcart = $conn->query($sqlcart);
	$number_of_result_cart = $resultcart->num_rows;
	if ($number_of_result_cart > 0) {
		$totalcart = 0;
		while ($rowcart = $resultcart->fetch_assoc()) {
			$totalcart = $totalcart+ $rowcart['cart_quantity'];
		}
	}else{
		$totalcart = 0;
	}
}else{
	$totalcart = 0;
}

//Pagination
$result = $conn->query($sqlloaditems);
$numberOfResult = $result->num_rows;
$numberOfPage = ceil($numberOfResult / $results_per_page);
$sqlloaditems = $sqlloaditems . "LIMIT $first_result_for_that_page, $results_per_page";
$result = $conn->query($sqlloaditems);

if($result->num_rows > 0){
	$items["items"] = array();
	while($row = $result->fetch_assoc()){
		$itemlist = array();
			
		$itemlist['item_id'] = $row['item_id'];
		$itemlist['user_id'] = $row['user_id'];
		$itemlist['item_name'] = $row['item_name'];
		$itemlist['item_desc'] = $row['item_desc'];
		$itemlist['item_category'] = $row['item_category'];
		$itemlist['item_quantity'] = $row['item_quantity'];
		$itemlist['item_value'] = $row['item_value'];
		$itemlist['state'] = $row['state'];
		$itemlist['locality'] = $row['locality'];
		$itemlist['latitude'] = $row['latitude'];
		$itemlist['longitude'] = $row['longitude'];
		$itemlist['reg_date'] = $row['reg_date'];
			
		array_push($items['items'], $itemlist);
	}
	$response = array('status'=> 'success', 'data'=> $items, 'numberOfPage'=> "$numberOfPage", "numberOfResult"=>"$numberOfResult","cartqty"=> "$totalcart");
	sendJsonResponse($response);
} else {
	$response = array('status'=> 'failed', 'data'=> null, 'sql'=> $sqlloaditems);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
	header("Content-Type: application/json");
	echo json_encode($sentArray);
}
?>