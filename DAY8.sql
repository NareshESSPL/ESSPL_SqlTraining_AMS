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

--1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
--total = total - total * (discount/100)

update o
set o.Total_Amount = o.Total_Amount - o.Total_Amount * (ISNULL(Discount_Percentage,0) /100)
from Orders o
left join Discounts d on o.Product = d.Product

select * from Orders

--2.Delete orders places by Customer who have placed more than 5 orders

delete from Orders
where Customer_Name IN(
select Customer_Name from Orders 
GROUP BY 
Customer_Name 
HAVING Sum(Quantity)>5
);


select * from Orders

--3.Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:

CREATE TABLE TopOrders1
(
Customer_Name NVARCHAR(50),
Total_Amount DECIMAL(10,2)
);

insert into TopOrders1(Customer_Name,Total_Amount)
select o.Customer_Name, SUM(o.Total_Amount) as Total_Quantity
from Orders as o
GROUP BY o.Customer_Name
HAVING SUM(o.Total_Amount) > 10000

select * from TopOrders1

/*4.Conditional Insert with a CASE Statement
insert into ProductSummary table where Category columns
will have two type values one is 'Premium' where Total_Amount > 50000
and  where EconomyTotal_Amount between 2000 and 50000*/

create table ProductSummary
(
CATEGORY NVARCHAR(50),
Total_Amount Decimal(10,2)
);

insert into ProductSummary(CATEGORY,Total_Amount)
select 
CASE
        WHEN Total_Amount > 50000 THEN 'Premium'
        WHEN Total_Amount BETWEEN 2000 AND 50000 THEN 'Economy'
        ELSE NULL
    END AS Category,
	Total_Amount
FROM Orders

select * from ProductSummary

--5.Upsert records into the ordersummary table to update existing rows or insert new ones

create table OrderSummary
(
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
	);

merge OrderSummary as target using
Orders as source 
on target.Order_ID = source.Order_ID
When MATCHED then 
UPDATE SET 
target.Customer_Name = source.Customer_Name,
target.Product = source.Product,
target.Total_Amount = source.Total_Amount
When NOT MATCHED then
insert(Order_ID,Customer_Name,Product,Total_Amount)
values(source.Order_ID,source.Customer_Name,source.Product,source.Total_Amount);

select * from OrderSummary

--6.Update the CATEGORY in the Orders table based on the average Total_Amount
--if total_amount > avg(total_amount) 'High Value'

-->Sol 1.
/*UPDATE Orders
SET CATEGORY = CASE
                   WHEN Total_Amount > (SELECT AVG(Total_Amount) FROM Orders) THEN 'High Value'
                   ELSE 'Low Value'
               END;
*/

-->Sol 2.
/*
SET @AverageTotalAmount = (SELECT AVG(Total_Amount) FROM Orders);

-- Update the Orders table based on the condition
UPDATE Orders
SET CATEGORY = 'High Value'
WHERE Total_Amount > @AverageTotalAmount;
*/

update Orders
set CATEGORY = 'High Value'
where  Total_Amount > (select AVG(Total_Amount) from Orders)


select * from Orders

------------------------

--Masking
CREATE FUNCTION AMS.MASKED_function(
 @account_no varchar(10)
)
RETURNS varchar(10)
AS
BEGIN
     RETURN LEFT(@account_no,2) + '******' + RIGHT(@account_no,2)
END

SELECT AMS.MASKED_function('1234567890') AS MaskedAccountNumber;

-----------------------------------------------

--7.Remove duplicates orders where all attributes are identical


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

