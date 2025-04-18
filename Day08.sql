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


select ((100 - b.Discount_Percentage) * a.Total_Amount / 100) as Discounted_Price, * FROM Orders AS a
JOIN Discounts AS b on a.Product = b.Product
--1st question
UPDATE a
SET a.Total_Amount = ((100 - ISNULL(b.Discount_Percentage, 0)) * a.Total_Amount / 100)
FROM Orders a
LEFT JOIN Discounts b on a.Product = b.Product

SELECT *
FROM Orders a
LEFT JOIN Discounts b on a.Product = b.Product
--2nd question delete the records whose quantity is more than 5 one customer can have muyltiple orders
select Customer_Name from Orders
group by Customer_Name
having sum(Quantity) > 5

delete from Orders where Customer_Name IN (select Customer_Name from Orders
group by Customer_Name
having sum(Quantity) > 5)

--3rd question Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000
CREATE TABLE TopOrders (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

INSERT INTO TopOrders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
(SELECT *  FROM Orders 
WHERE Customer_Name IN 
( SELECT Customer_Name FROM Orders
GROUP BY Customer_Name
HAVING SUM(Total_Amount) > 50000))

SELECT * FROM TopOrders

--4th question
SELECT Order_ID ,Customer_Name ,Product,Total_Amount, 
CASE 
	WHEN Total_Amount > 50000.00 THEN 'Premium'
	WHEN Total_Amount BETWEEN 20000.00 AND 50000.00 THEN 'Economic'
	ELSE 'Normal'
END
AS EcCategory
FROM Orders
--5th question upsert records into the ordersummary table to update existing rows or insert new rows
CREATE TABLE OrderSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

INSERT INTO OrderSummary(Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (109, 'Ishu', 'Headphones', 2, '2023-07-17', 4000.00, 'mechatronics');


MERGE INTO OrderSummary t
  USING Orders s ON s.Order_ID= t.Order_ID
 
 WHEN MATCHED
     then UPDATE SET 
         t.Customer_Name = s.Customer_Name,
		 t.Product = s.Product,
		 t.Quantity = s.Quantity,
		 t.Order_Date = s.Order_Date,
		 t.Total_Amount = s.Total_Amount,
		 t.CATEGORY = s.CATEGORY 
 WHEN NOT MATCHED 
     THEN INSERT (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY) 
	 values (s.Order_ID, s.Customer_Name, s.Product, s.Quantity, s.Order_Date, s.Total_Amount, s.CATEGORY);

select * from OrderSummary
--5th question Update the CATEGORY in the Orders table based on the average Total_Amount
SELECT Order_ID ,Customer_Name ,Product,Total_Amount, 
IIF(Total_Amount > (SELECT AVG(Total_Amount) FROM Orders), 'HIGH VALUE', 'LOW VALUE')
AS EcCategory
FROM Orders
--6th question

CREATE FUNCTION MASK
(
	@AccNo VARCHAR(10)
)
RETURNS VARCHAR(10)
AS
BEGIN
	RETURN CONCAT(SUBSTRING(@AccNo, 1, 3), '****', SUBSTRING(@AccNo, LEN(@AccNo) - 2, 3))
END;

DECLARE @AccountNo VARCHAR(10)
SET @AccountNo = '1123567890'
PRINT dbo.MASK(@AccountNo);

--7th question Remove duplicate orders where all attributes are identical
INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (136, 'Ananya', 'Headphones', 1, '2023-06-16', 2000.00, 'Electronics');
INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (126, 'Ananya', 'Headphones', 1, '2023-06-16', 2000.00, 'Electronics');

WITH CTE AS(
	SELECT *,
           ROW_NUMBER() OVER (PARTITION BY 
               Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY
           ORDER BY Customer_Name) AS rn
    FROM Orders
)
delete from CTE
where rn > 1

select * from Orders
