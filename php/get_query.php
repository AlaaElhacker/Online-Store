<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "OnlineStore1";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$query_id = $_GET["query"];

switch ($query_id) {
   
    case "1":
        
        $sql = "SELECT O.OrderID, C.FName AS CustomerName, O.Total
                FROM Orders O
                INNER JOIN Customers C ON O.CustomerID = C.CustomerID;";
        $desc = "Customers Who has orders";
        break;
         

    case "2":
        $sql = "SELECT C.C_Name AS CategoryName, COUNT(P.ProductID) AS ProductCount
                FROM Categories C
                LEFT JOIN Products P ON C.CategoryID = P.CategoryID
                GROUP BY C.C_Name;";
        $desc = "Every categorey has how many product";        
        break;

    case "3":
        $sql = "SELECT CONCAT(C.FName, ' ', C.LName) AS CustomerName, COUNT(O.OrderID) AS OrdersCount
                FROM Customers C
                LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
                GROUP BY C.FName, C.LName
                ORDER BY OrdersCount DESC;";
        $desc = "Amount of Orders for each customer in DESC order";          
        break;

    case "4":
        $sql = "SELECT Name, Price FROM Products ORDER BY Price DESC;";
        $desc = "Products listed from most expensive to cheapest";
        break;

    
    case "5":
        $desc = "Top 5 best-selling products";
        $sql = "SELECT P.Name AS ProductName, SUM(O.Quantity) AS SoldQuantity
                FROM OrderItems O
                INNER JOIN Products P ON P.ProductID = O.ProductID
                GROUP BY P.Name
                ORDER BY SoldQuantity DESC
                LIMIT 5;";
        break;

    case "6":
        $desc = "Products that are still pending in orders";
        $sql = "SELECT P.Description, P.Name
                FROM OrderItems T
                INNER JOIN Orders O ON O.OrderID=T.OrderID
                INNER JOIN Products P ON P.ProductID=T.ProductID
                WHERE O.Status='Pending';";
        break;

    case "7":
        $desc = "Customers and the coupons they used, if any";
        $sql = "SELECT O.OrderID, CONCAT(C.FName,' ',C.LName) AS CustomerName,
                       CO.Code AS CouponUsed, O.Total
                FROM Orders O
                LEFT JOIN Customers C ON O.CustomerID = C.CustomerID
                LEFT JOIN Coupons CO ON O.CouponID = CO.CouponID;";
        break;

    case "8":
        $desc = "Total discount loss from all orders";
        $sql = "SELECT SUM(
                    CASE 
                        WHEN CO.DiscountType = 'percentage' 
                            THEN O.Total * (CO.DiscountValue / (100 - CO.DiscountValue))
                        ELSE CO.DiscountValue
                    END
                ) AS TotalDiscountLoss
                FROM Orders O
                JOIN Coupons CO ON O.CouponID = CO.CouponID;";
        break;

    case "9":
        $desc = "Orders with coupons: original price, discounted price and discount amount";
        $sql = "SELECT 
                    O.OrderID,
                    CONCAT(CUS.FName,' ',CUS.LName) AS CustomerName,
                    CP.Code AS CouponUsed,
                    O.Total AS DiscountedTotal,
                    CASE 
                        WHEN CP.DiscountType='percentage'
                            THEN O.Total / (1 - (CP.DiscountValue/100))
                        WHEN CP.DiscountType='fixed'
                            THEN O.Total + CP.DiscountValue
                        ELSE O.Total
                    END AS OriginalTotal,
                    CASE 
                        WHEN CP.DiscountType='percentage'
                            THEN (O.Total / (1 - (CP.DiscountValue/100))) - O.Total
                        WHEN CP.DiscountType='fixed'
                            THEN CP.DiscountValue
                        ELSE 0
                    END AS DiscountAmount
                FROM Orders O
                JOIN Customers CUS ON O.CustomerID = CUS.CustomerID
                JOIN Coupons CP ON O.CouponID = CP.CouponID;";
        break;

    case "10":
        $desc = "Total number of orders from each city";
        $sql = "SELECT C.City, COUNT(O.OrderID) AS TotalOrders
                FROM Orders O
                JOIN Customers C ON O.CustomerID = C.CustomerID
                GROUP BY C.City;";
        break;

    case "11":
        $desc = "Total sales per category in the last 30 days";
        $sql = "SELECT 
            C.C_Name AS CategoryName,
            SUM(OI.Quantity * OI.Price) AS TotalSales_Last30Days
        FROM OrderItems OI
        JOIN Products P ON OI.ProductID = P.ProductID
        JOIN Categories C ON P.CategoryID = C.CategoryID
        JOIN Orders O ON OI.OrderID = O.OrderID
        WHERE O.Order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        GROUP BY C.C_Name
        ORDER BY TotalSales_Last30Days DESC;";
        break;

    case "12":
        $desc = "Products with stock less than 10";
        $sql = "SELECT ProductID, Name, Stock
                FROM Products
                WHERE Stock < 10;";
        break;

    case "13":
        $desc = "Orders that have not been paid yet";
        $sql = "SELECT O.OrderID, O.Total, P.PaymentID
                FROM Orders O
                LEFT JOIN Payments P ON O.OrderID = P.OrderID
                WHERE P.PaymentID IS NULL;";
        break;
    default:
        echo "Invalid Query!";
        exit;
}

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<table border='1' cellpadding='8' cellspacing='0'>";
    
    // Header
    echo "<tr>";
    while ($field = $result->fetch_field()) {
        echo "<th>{$field->name}</th>";
    }
    echo "</tr>";

    // Rows
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        foreach ($row as $cell) {
            echo "<td>$cell</td>";
        }
        echo "</tr>";
    }

    echo "</table>";
    echo "<p style='color:#444; margin-bottom:10px; font-size:16px'>$desc</p>";
} else {
    echo "No Results Found!";
}

$conn->close();
?>
