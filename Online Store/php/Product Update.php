<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "OnlineStore1";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$product_id  = $_POST["product_id"];
$update_type = $_POST["update_type"];
$stock       = $_POST["stock"];
$price       = $_POST["price"];

$sql = "";

if ($update_type == "stock") {
    $sql = "UPDATE Products SET Stock = Stock + $stock WHERE ProductID = $product_id";
}

elseif ($update_type == "price") {
    $sql = "UPDATE Products SET Price = $price WHERE ProductID = $product_id";
}

elseif ($update_type == "both") {
    $sql = "UPDATE Products 
            SET Stock = Stock + $stock, Price = $price 
            WHERE ProductID = $product_id";
}

if ($conn->query($sql) === TRUE) {
    echo "Product updated successfully!";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
