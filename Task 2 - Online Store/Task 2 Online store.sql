CREATE DATABASE OnlineStore;
USE OnlineStore;

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    City VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    Category VARCHAR(50),
    Manufacturer VARCHAR(100),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    ShippingAddress VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Order Details Table (to handle multiple products per order)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery') NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Status ENUM('Completed', 'Pending', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Sample Data Insertion
-- Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, Country, PostalCode) VALUES
('John', 'Doe', 'john.doe@email.com', '123-456-7890', '123 Main St', 'New York', 'USA', '10001'),
('Jane', 'Smith', 'jane.smith@email.com', '987-654-3210', '456 Elm St', 'Los Angeles', 'USA', '90001');

-- Products
INSERT INTO Products (ProductName, Description, Price, StockQuantity, Category, Manufacturer) VALUES
('Wireless Headphones', 'Noise-cancelling Bluetooth headphones', 199.99, 50, 'Electronics', 'TechBrand'),
('Laptop', '15-inch Ultrabook with SSD', 999.99, 20, 'Computers', 'ComputerCo'),
('Smart Watch', 'Fitness tracking smartwatch', 249.99, 35, 'Wearables', 'WearableTech');

-- Sample Queries

-- 1. Place a new order
INSERT INTO Orders (CustomerID, TotalAmount, Status, ShippingAddress) VALUES
(1, 449.98, 'Pending', '123 Main St, New York, USA 10001');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Subtotal) VALUES
((SELECT LAST_INSERT_ID()), 1, 1, 199.99, 199.99),
((SELECT LAST_INSERT_ID()), 3, 1, 249.99, 249.99);

-- 2. Retrieve all orders for a specific customer
SELECT 
    o.OrderID, 
    o.OrderDate, 
    o.TotalAmount, 
    o.Status,
    p.ProductName,
    od.Quantity
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
WHERE 
    o.CustomerID = 1;

-- 3. Find products with low stock
SELECT 
    ProductID, 
    ProductName, 
    StockQuantity
FROM 
    Products
WHERE 
    StockQuantity < 30
ORDER BY 
    StockQuantity ASC;

-- 4. Calculate total sales by category
SELECT 
    p.Category, 
    SUM(od.Subtotal) AS TotalSales,
    COUNT(DISTINCT o.OrderID) AS NumberOfOrders
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    p.Category
ORDER BY 
    TotalSales DESC;

-- 5. Find customers who have made multiple orders
SELECT 
    c.CustomerID, 
    c.FirstName, 
    c.LastName, 
    COUNT(o.OrderID) AS TotalOrders
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.FirstName, c.LastName
HAVING 
    TotalOrders > 1
ORDER BY 
    TotalOrders DESC;