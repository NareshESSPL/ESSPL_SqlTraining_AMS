Create Database Practice
go

use Practice
go

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);


INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (101, 'Ananya', 'Laptop', 1, '2023-06-15', 55000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (102, 'Bharat', 'Mobile Phone', 2, '2023-06-18', 60000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (103, 'Chitra', 'Office Chair', 4, '2023-07-01', 28000.00, 'Furniture');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (104, 'Dev', 'Coffee Maker', 1, '2023-07-04', 4000.00, 'Furniture');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (105, 'Esha', 'Dining Table', 1, '2023-07-10', 15000.00, 'Furniture');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (106, 'Ananya', 'Headphones', 1, '2023-06-16', 2000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (107, 'Bharat', 'Charger', 1, '2023-06-20', 500.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (108, 'Harsh', 'Headphones', 1, '2023-07-16', 2000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (109, 'Ishita', 'Headphones', 2, '2023-07-17', 4000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (110, 'Jai', 'Headphones', 2, '2023-07-18', 4000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (111, 'Kavita', 'Headphones', 6, '2023-07-19', 12000.00, 'Electronics');

Create table Discounts
(
    Discount_ID INT PRIMARY KEY,
    Product NVARCHAR(50),
    Discount_Percentage float
)

INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (1, 'Headphones', 10)
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (2, 'Coffee Maker', 10)
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (3, 'Charger', 10)
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (4, 'Mobile Phone', 10)

CREATE TABLE Employees (
   EmployeeID INT PRIMARY KEY,
   FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Position NVARCHAR(50),
  Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (1, 'John', 'Doe', 'Manager', 75000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (2, 'Jane', 'Smith', 'Developer', 60000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (3, 'Alice', 'Johnson', 'Designer', 55000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (4, 'Bob', 'Brown', 'Analyst', 50000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (5, 'Bob', 'Brown', 'Analyst', 50000.00);

SELECT * FROM Orders
SELECT * FROM Discounts
SELECT * FROM Employees

--1

SELECT d.Discount_Percentage,o.Total_Amount,o.Total_Amount*(100-ISNULL(d.Discount_Percentage,0))/100
AS newAmount from Discounts d left join Orders o on o.product = d.product

--2
SELECT
    d.Discount_Percentage AS DiscountPercent,
    o.Total_Amount AS OriginalAmount,
    o.Total_Amount * (1 - ISNULL(d.Discount_Percentage, 0) / 100) AS DiscountedAmount
FROM
    Discounts d
LEFT JOIN
    Orders o ON o.Product = d.Product;

--3
SELECT
    o.Order_ID,
    d.Discount_Percentage AS DiscountPercent,
    o.Total_Amount AS OriginalAmount,
    o.Total_Amount * (1 - ISNULL(d.Discount_Percentage, 0) / 100) AS DiscountedAmount
FROM
    Discounts d
LEFT JOIN
    Orders o ON o.Product = d.Product;

--4
SELECT
    o.Order_ID,
    o.Product AS OrderProduct,
    d.Product AS DiscountedProduct,
    d.Discount_Percentage AS DiscountPercent,
    o.Total_Amount AS OriginalAmount,
    o.Total_Amount * (1 - ISNULL(d.Discount_Percentage, 0) / 100) AS DiscountedAmount
FROM
    Discounts d
LEFT JOIN
    Orders o ON o.Product = d.Product;

--5
SELECT
    o.Order_ID,
    o.Product,
    CASE
        WHEN d.Discount_Percentage IS NOT NULL THEN d.Discount_Percentage
        ELSE 0
    END AS DiscountPercent,
    o.Total_Amount AS OriginalAmount,
    CASE
        WHEN d.Discount_Percentage IS NOT NULL THEN o.Total_Amount * (1 - d.Discount_Percentage / 100)
        ELSE o.Total_Amount
    END AS DiscountedAmount
FROM
    Orders o
LEFT JOIN
    Discounts d ON o.Product = d.Product;

-- 6
SELECT
    o.Order_ID,
    o.Product,
    ISNULL(d.Discount_Percentage, 0) AS DiscountPercent,
    o.Total_Amount AS OriginalAmount,
    ISNULL(d.Discount_Percentage, 0) / 100 * o.Total_Amount AS DiscountAmount,
    o.Total_Amount - ISNULL(d.Discount_Percentage, 0) / 100 * o.Total_Amount AS DiscountedAmount
FROM
    Orders o
LEFT JOIN
    Discounts d ON o.Product = d.Product;

-- 7
WITH DiscountedOrders AS (
    SELECT
        o.Order_ID,
        o.Product,
        o.Total_Amount,
        ISNULL(d.Discount_Percentage, 0) AS DiscountPercent
    FROM
        Orders o
    LEFT JOIN
        Discounts d ON o.Product = d.Product
)
SELECT
    Order_ID,
    Product,
    Total_Amount AS OriginalAmount,
    DiscountPercent,
    Total_Amount * (1 - DiscountPercent / 100) AS DiscountedAmount
FROM
    DiscountedOrders;




DELETE FROM Orders
WHERE Customer_Name IN (SELECT Customer_Name FROM Orders GROUP BY
    Customer_Name
HAVING
    SUM(Quantity) > 5)
;


SELECT * FROM Orders;

CREATE TABLE TopOrders(
	Order_ID INT PRIMARY KEY,
	Customer_Name NVARCHAR(50),
	Product NVARCHAR(50),
	Quantity INT,
	Order_Date DATE,
	Total_Amount DECIMAL(10,2),
	Category NVARCHAR(50)
);
INSERT INTO TopOrders 
	(Order_ID, Customer_Name, Product, Quantity, Order_Date,Total_Amount,Category)
SELECT 
	Order_ID, Customer_Name, Product, Quantity, Order_Date,Total_Amount,Category
FROM 
	Orders 
WHERE 
	Total_Amount > 50000
SELECT * FROM TopOrders

CREATE TABLE ProductSummary (
    Product NVARCHAR(50),
    TotalAmount DECIMAL(10, 2),
	Category NVARCHAR(50),
);
GO

INSERT INTO ProductSummary (Product,TotalAmount,Category)
SELECT
    Product,Total_Amount,
CASE
    WHEN Total_Amount > 50000 THEN 'Premium'
    WHEN Total_Amount BETWEEN 2000 AND 50000 THEN 'Economy'
    ELSE 'Other'
END 
AS Category
FROM
    Orders;

SELECT * FROM ProductSummary;

CREATE TABLE OrderSummary(
	Order_ID INT PRIMARY KEY,
	Customer_Name NVARCHAR(50),
	Product NVARCHAR(50),
	Quantity INT,
	Order_Date DATE,
	Total_Amount DECIMAL(10,2),
	Category NVARCHAR(50)
)

MERGE OrderSummary Target
 USING Orders Source ON Source.Order_ID= Target.Order_ID

WHEN MATCHED
    THEN UPDATE SET 
        Target.Customer_Name = Source.Customer_Name,
		Target.Product = Source.Product,
		Target.Quantity = Source.Quantity,
		Target.Order_Date = Source.Order_Date,
		Target.Total_Amount = Source.Total_Amount,
		Target.Category = Source.Category

WHEN NOT MATCHED BY TARGET
    THEN INSERT
		 (Order_ID,Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
	VALUES(Source.Order_ID,Source.Customer_Name,Source.Product,Source.Quantity,Source.Order_Date,Source.Total_Amount,Source.CATEGORY)
;
Select * from OrderSummary

--Update the CATEGORY in the Orders table based on the average Total_Amount
--if(total_amount > avg(total_amount) 'High value'
UPDATE Orders
SET CATEGORY =
    CASE
        WHEN Total_Amount > (SELECT AVG(Total_Amount) FROM Orders) THEN 'High Value'
        ELSE CATEGORY 
		END;
GO


SELECT * FROM Orders;
--write a function to mask my account number

GO
CREATE FUNCTION MaskAccountNumber (@AccountNumber VARCHAR(20))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Length INT;
    DECLARE @MaskedAccountNumber VARCHAR(20);

    SET @Length = LEN(@AccountNumber);

    IF @Length <= 4
        SET @MaskedAccountNumber = @AccountNumber;
    ELSE
        SET @MaskedAccountNumber =
            LEFT(@AccountNumber, 2) +
            REPLICATE('*', @Length - 4) +
            RIGHT(@AccountNumber, 2);

    RETURN @MaskedAccountNumber;
END;
GO


DECLARE @AccountNumber VARCHAR(20) = '1234567899';
PRINT 'Original Account Number: ' + @AccountNumber;
PRINT 'Masked Account Number: ' + dbo.MaskAccountNumber(@AccountNumber);
DECLARE @AccountNumber VARCHAR(20) = '123';
PRINT 'Original Account Number: ' + @AccountNumber;
PRINT 'Masked Account Number: ' + dbo.MaskAccountNumber(@AccountNumber);
GO

--REMOVE DUPLICATE ORDERS WHERE ALL ATTRIBUTES ARE IDENTICAL

DELETE FROM Orders
WHERE Order_ID NOT IN (
    SELECT MIN(Order_ID)
    FROM Orders
    GROUP BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY
);
DELETE FROM Employees
WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM (
        SELECT
            EmployeeID,
            ROW_NUMBER() OVER (PARTITION BY FirstName, Salary ORDER BY EmployeeID) AS RowNum
        FROM
            Employees
    ) AS RowNumCTE
    WHERE RowNum > 1
);
