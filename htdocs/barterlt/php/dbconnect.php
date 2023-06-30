<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "barterlt";

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
} catch (mysqli_sql_exception $e) {
    die();
}

if($conn->connect_error){
	die("Connection failed".$conn->connect_error);
}
?>