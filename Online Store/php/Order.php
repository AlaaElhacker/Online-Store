<?php
$conn = new mysqli("localhost","root","","OnlineStore1");
if($conn->connect_error) die("Connection failed: ".$conn->connect_error);

$customer_id = $_POST['customer_id'];
$product_ids  = $_POST['product_id'];
$quantities   = $_POST['quantity'];

if(empty($product_ids)){
    die("No products selected!");
}

// 1️⃣ Insert new order
$conn->query("INSERT INTO Orders (CustomerID, Order_date, Status, Total) VALUES ($customer_id, NOW(), 'Pending', 0)");
$order_id = $conn->insert_id;
$total_order = 0;

for($i=0;$i<count($product_ids);$i++){
    $pid = $product_ids[$i];
    $qty = $quantities[$i];

    // check stock
    $res = $conn->query("SELECT Price, Stock FROM Products WHERE ProductID=$pid");
    if($res->num_rows==0){ echo "Product $pid not found!<br>"; continue;}
    $prod = $res->fetch_assoc();
    if($qty > $prod['Stock']){ echo "Not enough stock for Product $pid!<br>"; continue;}

    $price = $prod['Price'];
    $total_order += $price * $qty;

    // Insert into OrderItems
    $conn->query("INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES ($order_id, $pid, $qty, $price)");

    // Update product stock
    $new_stock = $prod['Stock'] - $qty;
    $conn->query("UPDATE Products SET Stock=$new_stock WHERE ProductID=$pid");
}

// Update total in Orders
$conn->query("UPDATE Orders SET Total=$total_order WHERE OrderID=$order_id");

echo "✅ Order placed successfully! Order ID: $order_id, Total: $total_order";
$conn->close();
?>
