<?php
	if(!isset($_POST)){
		$response = array("staus"=>"failed","data"=>null);
		sendJsonResponse($response);
		die();
	}

	include_once('dbconnect.php');

	if(isset($_POST['userid'])){
		$userid = $_POST["userid"];
		$sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
	}
	if(isset($_POST['search'])){
		$search = $_POST["search"];
		$sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
	}else{
		$sqlloaditems = "SELECT * FROM `tbl_items`";
	}
	
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
			$itemlist['item_value'] = $row['item_value'];
			$itemlist['state'] = $row['state'];
			$itemlist['locality'] = $row['locality'];
			$itemlist['latitude'] = $row['latitude'];
			$itemlist['longitude'] = $row['longitude'];
			$itemlist['reg_date'] = $row['reg_date'];
			
			array_push($items['items'], $itemlist);
		}
		$response = array('status'=> 'success', 'data'=> $items);
		sendJsonResponse($response);
	} else {
		$response = array('status'=> 'failed', 'data'=> null);
		sendJsonResponse($response);
	}

	function sendJsonResponse($sentArray){
		header("Content-Type: application/json");
		echo json_encode($sentArray);
	}
?>