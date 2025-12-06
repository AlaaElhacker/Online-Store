<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "OnlineStore1";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $order_id = intval($_POST['order_id']);
    $amount = floatval($_POST['amount']);
    $method = $_POST['method'];

    // جلب total الفعلي للـ order
    $stmt = $conn->prepare("SELECT Total FROM Orders WHERE OrderID = ?");
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $stmt->bind_result($order_total);
    if ($stmt->fetch()) {
        $stmt->close();

        if ($amount != $order_total) {
            echo "<p style='color:red;'>Amount entered does not match the order total ($order_total). Payment not accepted.</p>";
        } else {
            // تسجيل الدفع
            $stmt2 = $conn->prepare("INSERT INTO Payments (OrderID, Amount, PaymentMethod) VALUES (?, ?, ?)");
            $stmt2->bind_param("ids", $order_id, $amount, $method);
            if ($stmt2->execute()) {
                echo "<p style='color:green;'>Payment successful! ✅</p>";
                
                $conn->query("UPDATE Orders 
                            SET Status = 'Completed' 
                            WHERE OrderID = $order_id");

            } else {
                echo "<p style='color:red;'>Error: " . $stmt2->error . "</p>";
            }
            $stmt2->close();
        }
    } else {
        echo "<p style='color:red;'>Order not found!</p>";
        $stmt->close();
    }
}

$conn->close();
?>
