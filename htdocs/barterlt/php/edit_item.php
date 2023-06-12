<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data'=> null);
    sendJsonResponse($response);
    die();
}

$itemId = $_POST['itemId'];
$itemName = $_POST['itemName'];
$itemDesc = $_POST['itemDesc'];
$itemCategory = $_POST['itemCategory'];
$itemValue = $_POST['itemValue'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];

include_once('dbconnect.php');

$sqlUpdate = "UPDATE `tbl_items` 
                SET      `item_name` = '$itemName',
                         `item_desc` = '$itemDesc',
                         `item_category` = '$itemCategory',
                         `item_value` = '$itemValue',
                         `state` = '$state',
                         `locality` = '$locality',
                         `latitude` = '$latitude',
                         `longitude` = '$longitude'
                WHERE    `item_id` = '$itemId'";
              
if($conn->query($sqlUpdate) === true){
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}
else {
    $response = array(
        'status' => 'failed ',
        'data' => null
    );
    sendJsonResponse($response);
}

function sendJsonResponse($sendArray){
    header('Content-Type: application/json');
    echo json_encode($sendArray);
}
?>