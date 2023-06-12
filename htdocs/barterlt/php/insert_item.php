<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data'=> null);
    sendJsonResponse($response);
    die();
}

$userId = $_POST['userId'];
$itemName = $_POST['itemName'];
$itemDesc = $_POST['itemDesc'];
$itemCategory = $_POST['itemCategory'];
$itemValue = $_POST['itemValue'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];

include_once('dbconnect.php');

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,
                                        `item_name`,
                                        `item_desc`,
                                        `item_category`,
                                        `item_value`,
                                        `state`,
                                        `locality`,
                                        `latitude`,
                                        `longitude`)
              VALUES('$userId',
                     '$itemName',
                     '$itemDesc',
                     '$itemCategory',
                     '$itemValue',
                     '$state',
                     '$locality',
                     '$latitude',
                     '$longitude')";

if($conn->query($sqlinsert) === true){
    $filename = mysqli_insert_id($conn);
    $response = array('status' => 'success', 'data' => null);
    $decodeString = array();
    $decodeString[0] = base64_decode($image1);
    $decodeString[1] = base64_decode($image2);
    $decodeString[2] = base64_decode($image3);

    for($i = 0; $i <3; ++$i){
        $path = '../assets/items/'.$filename.'-'.($i + 1).'.png';
        file_put_contents($path, $decodeString[$i]);
    }
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