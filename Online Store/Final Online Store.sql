DROP DATABASE IF EXISTS OnlineStore1;
CREATE DATABASE OnlineStore1;
USE OnlineStore1;

-- -----------------------------------------------------
-- DROP TABLES
-- -----------------------------------------------------
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Coupons;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Customers;

-- -----------------------------------------------------
-- Customers
-- -----------------------------------------------------
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FName VARCHAR(100),
    LName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20) UNIQUE,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    CHECK (Phone REGEXP '^[0-9]{11}$')  -- الهاتف لازم يكون 11 رقم
);-- -----------------------------------------------------
-- Categories
-- -----------------------------------------------------
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    C_Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

-- -----------------------------------------------------
-- Products
-- -----------------------------------------------------
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL,
    CHECK (Price > 0),     
    CHECK (Stock >= 0)     
);

-- -----------------------------------------------------
-- Coupons
-- -----------------------------------------------------
CREATE TABLE Coupons (
    CouponID INT AUTO_INCREMENT PRIMARY KEY,
    Code NVARCHAR(100) UNIQUE,
    DiscountType NVARCHAR(50),
    DiscountValue DECIMAL(10,2),
    ValidFrom DATETIME DEFAULT CURRENT_TIMESTAMP,
    ValidUntil DATETIME,
    CHECK (DiscountType IN ('percentage','fixed')),      
    CHECK (
        (DiscountType = 'percentage' AND DiscountValue BETWEEN 1 AND 100)
        OR
        (DiscountType = 'fixed' AND DiscountValue > 0)
    ),
    CHECK (ValidUntil > ValidFrom)       
);

-- -----------------------------------------------------
-- Orders
-- -----------------------------------------------------
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status NVARCHAR(50),
    Total DECIMAL(10,2),
    CouponID INT NULL,
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)  ON DELETE CASCADE,
    FOREIGN KEY(CouponID) REFERENCES Coupons(CouponID) ON DELETE SET NULL,
    CHECK (Total >= 0),
    CHECK (Status IN ('Pending','Shipped','Completed','Cancelled'))
);

-- -----------------------------------------------------
-- OrderItems
-- -----------------------------------------------------
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE RESTRICT,
    CHECK (Quantity > 0),
    CHECK (Price > 0)
);

-- -----------------------------------------------------
-- Payments
-- -----------------------------------------------------
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT UNIQUE,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(50) DEFAULT 'Cash',
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE RESTRICT ,
    CHECK (Amount > 0),
    CHECK (PaymentMethod IN ('Cash','Credit Card','Debit Card','Vodafone Cash'))
);

-- -----------------------------------------------------


-- INSERT DATA
-- -----------------------------------------------------
INSERT INTO Customers (FName, LName, Email, Phone, Street, City, Country) VALUES
('Mariam','Attia','mariam@gmail.com','01000010001','Nile St','Alexandria','Egypt'),
('Omar','Hassan','omar@yahoo.com','01000010002','Green Rd','Cairo','Egypt'),
('Sara','Kamal','sara@gmail.com','01000010003','Talaat Rd','Giza','Egypt'),
('Ali','Yousef','ali@gmail.com','01000010004','Corniche','Alexandria','Egypt'),
('Hana','Fathy','hana@gmail.com','01000010005','Zahra St','Cairo','Egypt'),
('Yara','Mostafa','yara@gmail.com','01000010006','Victory St','Cairo','Egypt'),
('Karim','Adel','karim@gmail.com','01000010007','Freedom St','Giza','Egypt'),
('Laila','Samir','laila@gmail.com','01000010008','Airport Rd','Alexandria','Egypt'),
('Nour','Amr','nour@gmail.com','01000010009','Salah St','Cairo','Egypt'),
('Ziad','Othman','ziad@gmail.com','01000010010','Garden St','Giza','Egypt');

INSERT INTO Categories (C_Name, Description) VALUES
('Electronics','Phones, laptops'),
('Clothing','Fashion Items'),
('Home','Home accessories'),
('Beauty','Beauty products'),
('Sports','Sports items'),
('Toys','Kids toys'),
('Books','All kinds of books'),
('Shoes','Men and women shoes'),
('Bags','Backpacks and handbags'),
('Accessories','Watches and jewelry');

INSERT INTO Products (Name, Description, Price, Stock, CategoryID) VALUES
('iPhone 15','Apple 128GB',50000,10,1),
('Samsung S23','Samsung 256GB',42000,15,1),
('Laptop HP','Core i7 16GB',35000,5,1),
('Laptop Dell','Core i5 8GB',25000,8,1),
('AirPods Pro','Apple earbuds',6000,20,1),
('Smart Watch','Digital fitness watch',1500,30,1),
('T-Shirt','White cotton',200,100,2),
('Jeans','Blue denim jeans',450,60,2),
('Hoodie','Winter hoodie',550,40,2),
('Dress','Women dress',450,25,2),
('Jacket','Leather jacket',1200,15,2),
('Sofa','Grey 3 seats',15000,4,3),
('Lamp','LED desk lamp',300,30,3),
('Carpet','Large soft carpet',800,12,3),
('Dining Table','Wooden table',9000,3,3),
('Perfume','Men perfume 100ml',900,40,4),
('Makeup Kit','Full set',700,20,4),
('Skin Cream','Moisturizing cream',250,50,4),
('Football','FIFA quality',300,50,5),
('Gym Gloves','Workout gloves',150,40,5),
('Yoga Mat','Thick mat',350,30,5),
('Basketball','Official size',400,25,5),
('LEGO Set','Star Wars edition',1200,20,6),
('Puzzle 1000 pcs','Kids puzzle',200,40,6),
('Toy Car','Remote control',350,25,6),
('Doll','Kids doll',180,35,6),
('The Alchemist','Paulo Coelho',150,200,7),
('Atomic Habits','James Clear',250,150,7),
('Harry Potter','Fantasy novel',300,120,7),
('Sneakers','Running shoes',900,35,8),
('Formal Shoes','Black leather',1100,20,8),
('Sandals','Summer sandals',250,40,8),
('Handbag','Women leather handbag',700,25,9),
('Backpack','School backpack',300,40,9),
('Travel Bag','Large travel bag',900,10,9),
('Watch','Men watch',1500,30,10),
('Necklace','Gold plated',500,40,10),
('Bracelet','Silver bracelet',350,50,10),
('Sunglasses','UV protection',600,25,10);

INSERT INTO Coupons (Code, DiscountType, DiscountValue, ValidFrom, ValidUntil) VALUES
('SAVE10','percentage',10,'2025-01-01','2025-12-31'),
('WELCOME50','fixed',50,'2025-02-01','2025-12-31'),
('NEW20','percentage',20,'2025-03-01','2025-12-31'),
('SPRING5','fixed',5,'2025-04-01','2025-10-01'),
('BLACKFRIDAY','percentage',40,'2025-11-01','2025-11-30');

INSERT INTO Orders (CustomerID, Status, Total, CouponID) VALUES
(1,'Pending',50200, 1),
(2,'Completed',200, NULL),
(3,'Shipped',35000, 2),
(4,'Pending',150, NULL),
(5,'Cancelled',450, 3),
(6,'Completed',900, NULL),
(7,'Shipped',15000, 4),
(8,'Pending',300, NULL),
(9,'Completed',900, 5),
(10,'Pending',1200, NULL),
(1,'Pending',700, NULL),
(4,'Pending',1200, NULL),
(6,'Pending',450, NULL),
(8,'Pending',3000, NULL),
(10,'Pending',900, NULL);

INSERT INTO Payments (OrderID, Amount, PaymentMethod) VALUES
(1,50200,'Credit Card'),
(2,200,'Cash'),
(3,35000,'Vodafone Cash'),
(4,150,'Credit Card'),
(5,450,'Cash'),
(6,900,'Credit Card'),
(7,15000,'Debit Card'),
(8,300,'Cash'),
(9,900,'Credit Card'),
(10,1200,'Cash');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES
(1,1,1,50000),
(1,3,1,200),
(2,3,1,200),
(3,2,1,35000),
(4,9,1,150),
(5,4,1,450),
(6,6,1,900),
(7,5,1,15000),
(8,7,1,300),
(10,8,1,1200);

-- UPDATE Totals بعد تطبيق الكوبونات
UPDATE Orders O
JOIN Coupons C ON O.CouponID = C.CouponID
SET O.Total = O.Total - 
    CASE
        WHEN C.DiscountType = 'percentage' THEN (O.Total * C.DiscountValue / 100)
        WHEN C.DiscountType = 'fixed' THEN C.DiscountValue
        ELSE 0
    END
WHERE C.ValidUntil >= NOW();

-- -----------------------------------------------------
-- SELECT Queries
-- -----------------------------------------------------

-- Query 1: Inner Join (كل العملاء اللي عندهم طلبات)
SELECT O.OrderID, CONCAT(C.FName, ' ', C.LName) AS CustomerName, O.Total
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID;

-- Query 2: Left Join (عدد المنتجات في كل قسم)
SELECT C.C_Name AS CategoryName, COUNT(P.ProductID) AS ProductCount
FROM Categories C
LEFT JOIN Products P ON C.CategoryID = P.CategoryID
GROUP BY C.C_Name;

-- Query 3: Left Join + Count + Group By (عدد الأوردرات لكل عميل)
SELECT C.FName, C.LName, COUNT(O.OrderID) AS OrdersCount
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FName, C.LName;

-- Query 4: Products ordered by price DESC
SELECT Name, Price
FROM Products
ORDER BY Price DESC;

-- Query 5: Top 5 best selling products
SELECT P.Name AS PRODUCT_NAME , SUM(O.Quantity) AS SOLD_QUANTITY 
FROM OrderItems AS O
INNER JOIN Products AS P ON P.ProductID=O.ProductID
GROUP BY P.Name
ORDER BY SUM(O.Quantity) DESC
LIMIT 5;

-- Query 6: Pending products
SELECT P.Description AS PRODUCT_DESCRIPTION , P.Name AS PRODUCT_NAME 
FROM OrderItems AS T 
INNER JOIN Orders AS O ON O.OrderID=T.OrderID
INNER JOIN Products AS P ON P.ProductID=T.ProductID
WHERE O.Status='Pending';

-- Query 7: Customers who used coupons
SELECT O.OrderID, CONCAT(C.FName, ' ', C.LName) AS CustomerName,
       CO.Code AS CouponUsed, O.Total
FROM Orders O
LEFT JOIN Customers C ON O.CustomerID = C.CustomerID
LEFT JOIN Coupons CO ON O.CouponID = CO.CouponID;

-- Query 8: Total discount loss for store
SELECT SUM(
        CASE 
            WHEN CO.DiscountType = 'percentage' 
                THEN O.Total * (CO.DiscountValue / (100 - CO.DiscountValue))
            ELSE CO.DiscountValue
        END
    ) AS TotalDiscountLoss
FROM Orders O
JOIN Coupons CO ON O.CouponID = CO.CouponID;

-- Query 9: Customers who used coupons + original & discounted totals
SELECT 
    O.OrderID,
    CONCAT(CUS.FName, ' ', CUS.LName) AS CustomerName,
    CP.Code AS CouponUsed,
    O.Total AS DiscountedTotal,
    CASE 
        WHEN CP.DiscountType = 'percentage' 
             THEN O.Total / (1 - (CP.DiscountValue / 100.0))
        WHEN CP.DiscountType = 'fixed'
             THEN O.Total + CP.DiscountValue
        ELSE O.Total
    END AS OriginalTotal,
    CASE 
        WHEN CP.DiscountType = 'percentage' 
             THEN (O.Total / (1 - (CP.DiscountValue / 100.0))) - O.Total
        WHEN CP.DiscountType = 'fixed'
             THEN CP.DiscountValue
        ELSE 0
    END AS DiscountAmount
FROM Orders O
JOIN Customers CUS ON O.CustomerID = CUS.CustomerID
JOIN Coupons CP ON O.CouponID = CP.CouponID;

-- Query 10: Total orders per city
SELECT C.City, COUNT(O.OrderID) AS TotalOrders
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.City;

-- Query 11: Total sales per category last 30 days
SELECT 
    C.C_Name AS CategoryName,
    SUM(OI.Quantity * OI.Price) AS TotalSales_Last30Days
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
JOIN Categories C ON P.CategoryID = C.CategoryID
JOIN Orders O ON OI.OrderID = O.OrderID
WHERE O.Order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY C.C_Name
ORDER BY TotalSales_Last30Days DESC;

-- Query 12: Products with stock < 10
SELECT ProductID, Name, Stock
FROM Products
WHERE Stock < 10;


-- Query 13: Orders not paid yet
SELECT 
    O.OrderID,
    O.Total,
    P.PaymentID
FROM Orders O
LEFT JOIN Payments P ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL;

-- Query: Order 1 items details
SELECT OD.OrderID, Name AS ProductName, Quantity, Oi.Price*Quantity AS Total_Price,
       CONCAT(C.FName, ' ', C.LName) AS CustomerName
FROM Orders OD
JOIN OrderItems Oi ON Oi.OrderID=OD.OrderID
JOIN Products P ON Oi.ProductID=P.ProductID
JOIN Customers C ON OD.CustomerID=C.CustomerID
WHERE OD.OrderID=1;

select * from orders


