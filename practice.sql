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

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (112, 'rita', 'Headphones', 7, '2023-07-19', 55000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (113, 'riya', 'Headphones', 8, '2023-07-19', 52000.00, 'Electronics');
 
 INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (114, 'riya', 'Headphones', 8, '2023-07-19', 52000.00, 'Electronics');



CREATE TABLE OrderSummary (
   Order_ID INT PRIMARY KEY,
   Customer_Name NVARCHAR(50),
   Product NVARCHAR(50),
    Quantity INT,
   Order_Date DATE,
   Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

CREATE TABLE TopOrders (
   Order_ID INT PRIMARY KEY,
   Customer_Name NVARCHAR(50),
   Product NVARCHAR(50),
    Quantity INT,
   Order_Date DATE,
   Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);


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



-----------------QUESTIONS-----------------------------
---1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)

UPDATE Orders
--SET Total_Amount = IsNUll(Total_Amount, 0) - (IsNUll(Total_Amount, 0) * isnull(d.Discount_Percentage,0) / 100)
SET Total_Amount = IsNull(Total_Amount - (Total_Amount * (d.Discount_Percentage / 100)), 0)
FROM Orders
LEFT JOIN Discounts d ON Orders.Product =d.Product



---2. Delete orders placed by customers who have placed more than 5 orders:
DELETE FROM Orders
WHERE Customer_Name IN (
    SELECT Customer_Name
    FROM Orders
    GROUP BY Customer_Name
    HAVING SUM(Quantity) > 5
);


---3.Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:
INSERT INTO TopOrders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, Category)
SELECT Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, Category
FROM Orders
WHERE Total_Amount > 50000;


----4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium'  and'economy' where Total_Amount > 50000
-- and  'economy' where EconomyTotal_Amount between 2000 and 50000



CREATE TABLE ProductSummary (
    Category NVARCHAR(50),
    Total_Amount DECIMAL(10, 2)
);

 INSERT INTO ProductSummary ( Category, Total_Amount)
SELECT 
    CASE 
        WHEN Total_Amount > 50000 THEN 'Premium'
        WHEN Total_Amount BETWEEN 2000 AND 50000 THEN 'Economy'
        ELSE NULL
    END AS Category,
    Total_Amount
FROM Orders

----5.upsert records into the orderSummary table to update exixting rows or insert new ones

MERGE INTO OrderSummary AS t
USING Orders AS s
ON s.Order_ID = t.Order_ID

WHEN MATCHED THEN 
    UPDATE SET 
        t.Customer_Name = s.Customer_Name,
        t.Product = s.Product,
        t.Total_Amount = s.Total_Amount,
        t.Category = s.Category

WHEN NOT MATCHED BY TARGET THEN
    INSERT (Order_ID, Customer_Name, Product, Total_Amount, Category)
    VALUES (s.Order_ID, s.Customer_Name, s.Product, s.Total_Amount, s.Category)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


--6.update the category in the orders table based on the average Total_ amount

UPDATE Orders
SET Category = 'High Value'
WHERE Total_Amount > (SELECT AVG(Total_Amount) FROM Orders);

---another way---------
;WITH AvgAmount AS (
    SELECT AVG(Total_Amount) AS AverageTotal
    FROM Orders
)
UPDATE Orders
SET Category = 'High Value'
WHERE Total_Amount > (SELECT AverageTotal FROM AvgAmount);

select Customer_Name,category from Orders where category ='high value'


--------7.hide account no-----------
CREATE FUNCTION dbo.MaskAccountNumber(@accountNo VARCHAR(10))
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN LEFT(@accountNo, 2) + '******' + RIGHT(@accountNo, 2);
END;

SELECT dbo.MaskAccountNumber('123456789') AS MaskedAccountNo;


--8.REMOVE DUPLICATE OREDRS WHWRE ALL ATRIBUTES ARE IDENTICAL

 
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY customer_name, product, quantity, order_date, total_amount ORDER BY total_amount) AS row_num
    FROM orders
)
delete from Orders where Order_ID in (
SELECT Order_ID
FROM CTE
WHERE row_num > 1);










SELECT customer_name, product, quantity, Order_date, total_amount, COUNT(*) AS duplicate_count
FROM Orders
GROUP BY customer_name, product, quantity
HAVING COUNT(*) > 1;

    


select * from   OrderSummary
select * from   ProductSummary
select * from 	TopOrders
select * from 	Orders
select * from 	Employees
select * from 	Discounts