<?php
	if (!isset($_POST)) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	include_once('dbconnect.php');
	
    $userId = $_POST['id']; 
	$name = $_POST['name'];
	$email = $_POST['email'];
	$phone = $_POST['phone'];
	$password = sha1($_POST['password']);
	
	$sqlinsert = "UPDATE `tbl_user` SET `name` = '$name', 
                                        `email` = '$email', 
                                        `phone` = '$phone',
                                        `password` = '$password'
                                    WHERE `id` = '$userId'";
	
	if($conn-> query($sqlinsert) === TRUE){
		$response = array("status" => "success", "data" => null);
		sendJsonResponse($response);
	}else{
		$response = array("status" => "failed", "data" => null);
		sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray){
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>