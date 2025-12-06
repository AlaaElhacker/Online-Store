<?php
// اتصال بالداتابيز
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "admins";   // اسم قاعدة البيانات اللي قولتي عليها

$conn = new mysqli($servername, $username, $password, $dbname);

// اختبار الاتصال
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// جلب الداتا من الفورم
$email = $_POST['email'];
$pass = $_POST['password'];

// SQL
$sql = "SELECT * FROM admin_table WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $pass);
$stmt->execute();
$result = $stmt->get_result();

// لو لقيناه
if ($result->num_rows > 0) {
    echo "<h2 style='color:green;text-align:center;margin-top:40px;'>Login Successful!</h2>";
    header("refresh:1; url=../HTMLs/Admin dash board.html");  // هيوديه للداشبورد بعد ثانية
    exit();
} else {
    echo "<h2 style='color:red;text-align:center;margin-top:40px;'>Invalid Email or Password</h2>";
    echo "<p style='text-align:center;'><a href='admin_login.html'>Try Again</a></p>";
}

$conn->close();
?>
