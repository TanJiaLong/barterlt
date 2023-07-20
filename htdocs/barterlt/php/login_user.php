<?php
	if(!isset($_POST)){
		$response = array("status"=>"failed","data"=>null);
		sendJsonResponse($response);
		die();
	}
	
	include_once("dbconnect.php");
	
	$email = $_POST["email"];
	$password = sha1($_POST["password"]);
	
	$sqllogin = "SELECT * FROM `tbl_user` WHERE email = '$email' AND password = '$password'";
	
	$result = $conn->query($sqllogin);
	
	if($result->num_rows > 0){
		while($row = $result->fetch_assoc()){
			$userarray = array();
			$userarray['id'] = $row['id'];
			$userarray['name'] = $row['name'];
			$userarray['email'] = $row['email'];
			$userarray['phone'] = $row['phone'];
			$userarray['password'] = $_POST['password'];
			$userarray['regDate'] = $row['regDate'];
			
			$response = array('status'=>'success','data'=> $userarray);
			sendJsonResponse($response);
		}
	}else{
		$response = array('status'=>'failed','data'=> null);
		sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray){
		header("Content-Type: application/json");
		
		//Output the data to the client side immediately
		echo json_encode($sentArray);
	}
?>