-- E-commerce Sales & Customer Analysis
-- SQL Server starter schema and analytical queries.
-- The included CSV data is synthetic and intended for portfolio practice.

CREATE TABLE Customers (
  CustomerID VARCHAR(10) PRIMARY KEY,
  CustomerName VARCHAR(100), Gender VARCHAR(30), Age INT,
  City VARCHAR(80), State VARCHAR(80), Region VARCHAR(30),
  SignupDate DATE, CustomerSegment VARCHAR(30)
);
CREATE TABLE Products (
  ProductID VARCHAR(10) PRIMARY KEY,
  ProductName VARCHAR(120), Category VARCHAR(60),
  UnitPrice DECIMAL(12,2), CostPrice DECIMAL(12,2), Brand VARCHAR(60)
);
CREATE TABLE Orders (
  OrderID VARCHAR(10) PRIMARY KEY,
  OrderDate DATE, CustomerID VARCHAR(10),
  OrderStatus VARCHAR(30), ShippingFee DECIMAL(12,2), OrderTotal DECIMAL(12,2),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE Order_Items (
  OrderID VARCHAR(10), ProductID VARCHAR(10), Quantity INT,
  UnitPrice DECIMAL(12,2), DiscountPct DECIMAL(5,4), LineTotal DECIMAL(12,2),
  PRIMARY KEY (OrderID, ProductID),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
CREATE TABLE Payments (
  PaymentID VARCHAR(12) PRIMARY KEY, OrderID VARCHAR(10),
  PaymentMethod VARCHAR(40), PaymentStatus VARCHAR(30), PaymentAmount DECIMAL(12,2),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 1. Monthly revenue and order volume
SELECT YEAR(o.OrderDate) AS SalesYear, MONTH(o.OrderDate) AS MonthNo,
       SUM(oi.LineTotal) AS ProductRevenue, COUNT(DISTINCT o.OrderID) AS Orders
FROM Orders o JOIN Order_Items oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus NOT IN ('Cancelled','Returned')
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY SalesYear, MonthNo;

-- 2. Revenue and units by category
SELECT p.Category, SUM(oi.LineTotal) AS Revenue, SUM(oi.Quantity) AS UnitsSold
FROM Order_Items oi JOIN Products p ON oi.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = oi.OrderID
WHERE o.OrderStatus NOT IN ('Cancelled','Returned')
GROUP BY p.Category ORDER BY Revenue DESC;

-- 3. Customer lifetime value (net product revenue)
SELECT c.CustomerID, c.CustomerName, c.Region,
       COUNT(DISTINCT o.OrderID) AS OrderCount,
       SUM(oi.LineTotal) AS LifetimeProductRevenue
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus NOT IN ('Cancelled','Returned')
GROUP BY c.CustomerID, c.CustomerName, c.Region
ORDER BY LifetimeProductRevenue DESC;

-- 4. Repeat customer rate
WITH CustomerOrders AS (
  SELECT CustomerID, COUNT(DISTINCT OrderID) AS OrderCount
  FROM Orders WHERE OrderStatus NOT IN ('Cancelled','Returned')
  GROUP BY CustomerID
)
SELECT
  COUNT(*) AS PurchasingCustomers,
  SUM(CASE WHEN OrderCount >= 2 THEN 1 ELSE 0 END) AS RepeatCustomers,
  100.0 * SUM(CASE WHEN OrderCount >= 2 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS RepeatCustomerPct
FROM CustomerOrders;

-- 5. Product profitability estimate
SELECT p.ProductID, p.ProductName, p.Category,
       SUM(oi.Quantity) AS UnitsSold,
       SUM(oi.LineTotal) AS Revenue,
       SUM(oi.Quantity * p.CostPrice) AS EstimatedCost,
       SUM(oi.LineTotal) - SUM(oi.Quantity * p.CostPrice) AS EstimatedGrossProfit
FROM Products p JOIN Order_Items oi ON p.ProductID = oi.ProductID
JOIN Orders o ON o.OrderID = oi.OrderID
WHERE o.OrderStatus NOT IN ('Cancelled','Returned')
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY EstimatedGrossProfit DESC;

-- 6. Payment method mix
SELECT p.PaymentMethod, COUNT(*) AS PaymentCount, SUM(p.PaymentAmount) AS PaymentValue
FROM Payments p GROUP BY p.PaymentMethod ORDER BY PaymentValue DESC;

-- 7. Order status summary
SELECT OrderStatus, COUNT(*) AS OrderCount, SUM(OrderTotal) AS OrderValue
FROM Orders GROUP BY OrderStatus ORDER BY OrderCount DESC;
