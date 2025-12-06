<?php
// 1️⃣ بيانات الاتصال بقاعدة البيانات
$servername = "localhost";
$username = "root";   
$password = "";           
$dbname = "OnlineStore1"; 

// 2️⃣ إنشاء الاتصال
$conn = new mysqli($servername, $username, $password, $dbname);

// 3️⃣ فحص الاتصال
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 4️⃣ استلام البيانات من النموذج
$FName = $_POST['FName'];
$LName = $_POST['LName'];
$Email = $_POST['Email'];
$Phone = $_POST['Phone'];
$Street = $_POST['Street'];
$City = $_POST['City'];
$Country = $_POST['Country'];

// 5️⃣ تحضير الاستعلام (Prepared Statement لتجنب SQL Injection)
$stmt = $conn->prepare("INSERT INTO Customers (FName, LName, Email, Phone, Street, City, Country) VALUES (?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("sssssss", $FName, $LName, $Email, $Phone, $Street, $City, $Country);

// 6️⃣ تنفيذ الاستعلام
if ($stmt->execute()) {
    echo "Customer added successfully!";
} else {
    echo "Error: " . $stmt->error;
}

// 7️⃣ إغلاق الاتصال
$stmt->close();
$conn->close();
?>
