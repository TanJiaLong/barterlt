<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data'=> null);
    sendJsonResponse($response);
    die();
}

$userId = $_POST['userId'];
$itemId = $_POST['itemId'];

include_once('dbconnect.php');

$sqlDelete = "DELETE FROM `tbl_items` WHERE `item_id` = '$itemId'";           
if($conn->query($sqlDelete) === true){
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}
else {
    $response = array(
        'status' => 'failed',
        'data' => null
    );
    sendJsonResponse($response);
}

function sendJsonResponse($sendArray){
    header('Content-Type: application/json');
    echo json_encode($sendArray);
}
?>