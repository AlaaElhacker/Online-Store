<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "OnlineStore1";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
}

$C_Name = $_POST['C_Name'];
$Description = $_POST['Description'];

$sql = "INSERT INTO categories (C_Name, Description)
        VALUES ('$C_Name', '$Description')";

if ($conn->query($sql) === TRUE) {
    echo "Category added successfully!";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
