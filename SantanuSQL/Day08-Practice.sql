-- 1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
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

Select * From Orders;
GO

Select * From Discounts;
GO

--Select * From Employees;
--GO



UPDATE o
SET o.Total_Amount = o.Total_Amount - o.Total_Amount * (ISNULL(d.Discount_Percentage,0) /100)
FROM Orders o
Left JOIN Discounts d ON o.Product = d.Product;

Select * From Orders;
GO

Select * From Discounts;
GO


-- 2: Delete Orders placed by Customers who have placed more than 5 Orders.


DELETE FROM Orders
WHERE Customer_Name IN (
    SELECT Customer_Name
    FROM Orders
    GROUP BY Customer_Name
    HAVING SUM(Quantity) > 5
);

--3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:


CREATE TABLE TopOrders (
    OrderID INT,
    Customer_Name VARCHAR(50),
    Product VARCHAR(50),
    Total_Amount DECIMAL(10, 2)
);

INSERT INTO TopOrders (OrderID, Customer_Name, Product, Total_Amount)
SELECT o.OrderID, Customer_Name, Product, Total_Amount
FROM Orders
WHERE Total_Amount > 50000;

/* 
4: Conditional Insert with a Case Statement insert into
productSummary table where categoryColumns will have two
type values one is 'Premium' where total_Amount > 50000
and 'Economy' where economyTotal_Amount between 20000 and 50000
*/

Create Table productSummary
(
Total_Amount Decimal(10,2),
Category Varchar(50)
);



INSERT INTO productSummary (Category, Total_Amount)
SELECT 
    CASE 
        WHEN o.Total_Amount > 50000 THEN 'Premium'
        WHEN o.Total_Amount BETWEEN 20000 AND 50000 THEN 'Economy'
        ELSE 'Other' -- Optional: Handle cases outside the specified ranges
    END AS Category,
    o.Total_Amount
FROM Orders o

-- 5. Upsert records into the orderSummary table to update existing rows or insert new ones


CREATE TABLE orderSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

MERGE orderSummary AS target
USING Orders AS source
ON target.Order_ID = source.Order_ID
WHEN MATCHED THEN
    UPDATE SET 
        target.Customer_Name = source.Customer_Name,
        target.Product = source.Product,
        target.Total_Amount = source.Total_Amount
WHEN NOT MATCHED THEN
    INSERT (Order_ID, Customer_Name, Product, Total_Amount)
    VALUES (source.Order_ID, source.Customer_Name, source.Product, source.Total_Amount); 

Select * from Orders

-- 6. Update the category in the Orders table based on the average_amount
-- If total_amount > avg(total_amount) set it to 'High value'


-- Step 1: Calculate the average total amount
DECLARE @avgTotalAmount DECIMAL(18, 2);

SELECT @avgTotalAmount = AVG(Total_Amount)
FROM Orders;

UPDATE Orders
SET Category = CASE 
    WHEN Total_Amount > @avgTotalAmount THEN 'High value'
    ELSE Category 
END;

-- MaskAccountNumber from Account column

Use AccountManagementSystem


CREATE FUNCTION AMS.MASKED_function( @account_no varchar(10) )
RETURNS varchar(10)
AS
BEGIN
    RETURN LEFT(@account_no,2) + '****' + RIGHT(@account_no,2)
END
GO

SELECT AMS.MASKED_function('1234567890') AS MaskedAccountNumber;

--Use Rank, RowNum or DenseRank Function to find the duplicate order's ordered by the customer.




SELECT *
FROM (
    SELECT 
        Order_ID,
        Customer_Name,
        Product,
        Order_Date,
        DENSE_RANK() OVER(PARTITION BY Product, Product, Order_Date ORDER BY Customer_Name) AS DenseRank
    FROM Orders
) AS OrderRanks
WHERE DenseRank > 1;


;WITH OrderRank AS (
    SELECT 
        Order_ID,
        Customer_Name,
        Product,
        Order_Date,
        RANK() OVER(PARTITION BY Customer_Name, Product, Order_Date ORDER BY Order_ID) AS Rank
    FROM Orders
)
SELECT *
FROM OrderRank
WHERE Rank > 1;

--Delete operation with CTE
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Customer_Name,Product ORDER BY Total_Amount) AS row_count
    FROM Orders
)
DELETE FROM Orders
WHERE Total_Amount IN (
    SELECT Total_Amount
    FROM CTE
    WHERE row_count > 0
);