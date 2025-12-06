<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "OnlineStore";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
}

$Code = $_POST['Code'];
$DiscountType = $_POST['DiscountType'];
$DiscountValue = $_POST['DiscountValue'];
$ValidUntil = $_POST['ValidUntil'];

$sql = "INSERT INTO coupons (Code, DiscountType, DiscountValue, ValidUntil)
        VALUES ('$Code', '$DiscountType', '$DiscountValue', '$ValidUntil')";

if ($conn->query($sql) === TRUE) {
    echo "Coupon added successfully!";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
