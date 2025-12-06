<?php
// 1️⃣ بيانات الاتصال بقاعدة البيانات
$servername = "localhost";
$username = "root";       // عادة XAMPP الافتراضي
$password = "";           // عادة XAMPP الافتراضي
$dbname = "OnlineStore1"; // اسم قاعدة البيانات عندك

// 2️⃣ إنشاء الاتصال
$conn = new mysqli($servername, $username, $password, $dbname);

// 3️⃣ فحص الاتصال
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 4️⃣ استلام البيانات من النموذج
$Name = $_POST['Name'];
$Description = $_POST['Description'];
$Price = $_POST['Price'];
$Stock = $_POST['Stock'];
$CategoryID = $_POST['CategoryID'];

// 5️⃣ تحضير الاستعلام (Prepared Statement لتجنب SQL Injection)
$stmt = $conn->prepare("INSERT INTO Products (Name, Description, Price, Stock, CategoryID) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("ssdii", $Name, $Description, $Price, $Stock, $CategoryID);

// 6️⃣ تنفيذ الاستعلام
if ($stmt->execute()) {
    echo "Product added successfully!";
} else {
    echo "Error: " . $stmt->error;
}

// 7️⃣ إغلاق الاتصال
$stmt->close();
$conn->close();
?>
