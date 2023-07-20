<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

if(isset($_POST['sellerid'])){
    $sellerid = $_POST['sellerid'];
    $sqlloadseller = "SELECT * FROM `tbl_user` WHERE id = '$sellerid'";
    $result = $conn->query($sqlloadseller);
    
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $userarray = array();
            $userarray['id'] = $row['id'];
            $userarray['email'] = $row['email'];
            $userarray['name'] = $row['name'];
            $userarray['phone'] = $row['phone'];
            $userarray['password'] = $row['password'];
            $userarray['datereg'] = $row['regDate'];
            $response = array('status' => 'success', 'data' => $userarray);
            sendJsonResponse($response);
        }
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}else{
    $userid = $_POST['userid'];
    $sqlloaduser = "SELECT * FROM `tbl_user` WHERE id = '$userid'";
    $result = $conn->query($sqlloaduser);
    
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $userarray = array();
            $userarray['id'] = $row['id'];
            $userarray['email'] = $row['email'];
            $userarray['name'] = $row['name'];
            $userarray['phone'] = $row['phone'];
            $userarray['password'] = $row['password'];
            $userarray['datereg'] = $row['regDate'];
            $response = array('status' => 'success', 'data' => $userarray);
            sendJsonResponse($response);
        }
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