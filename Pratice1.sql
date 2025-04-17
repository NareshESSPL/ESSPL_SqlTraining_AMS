use AccountManagementSystem12
USE master

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

SELECT * FROM Employees
SELECT * FROM Orders

-- QUESTION 1
update Orders set Total_Amount =Total_Amount * (1 - (select Discount_Percentage from Discounts where Discounts.Product = Orders.Product) / 100)
where Product IN (select Product from Discounts); 
select * from Orders
select * from Discounts
select * from Employees

select o.*,o.total_amount*(100-ISNULL(d.Discount_Percentage,0))/100 
as 
updatedAmount from Orders o left join Discounts d on o.product = d.Product	;

-- QUESTION 2

SELECT 
	o.*,
    COALESCE(o.Total_Amount * (1 - d.Discount_Percentage / 100), o.Total_Amount) AS Updated_Total_Amount
FROM Orders o
LEFT JOIN Discounts d ON o.Product = d.Product;


SELECT * FROM ORDERS WHERE Customer_Name 
IN 
(select Customer_Name from orders group by Customer_Name having count(order_id) > 5)

-- QUESTION 3

delete from orders where Customer_Name 
in 
(select Customer_Name from orders group by Customer_Name having count(order_id)>5)


select * into TopOrders from orders where Total_Amount >= 50000

select * from TopOrders

-- QUESTION 4

select Product,Total_Amount,
case 
when Total_Amount > 50000 then 'premium'
when Total_Amount > 20000 then 'economy'
else 'other'
end product_type
into productSummary from Orders

select * from productSummary

--QUESTION 5
CREATE TABLE OrderSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Total_Quantity INT,
    Total_Amount DECIMAL(10, 2),
    Order_Date DATE
);
select * from OrderSummary
MERGE OrderSummary t
 USING Orders s ON s.Order_ID  = t.Order_ID 

WHEN MATCHED
    THEN UPDATE SET 
        t.Total_Quantity=s.Quantity,
		t.Total_Amount=s.Total_Amount

WHEN NOT MATCHED BY TARGET
    THEN INSERT ([Order_ID]
           ,[Customer_Name]
           ,[Total_Quantity]
           ,[Total_Amount]
           ,[Order_Date]) values (s.[Order_ID],s.[Customer_Name],s.Quantity,s.[Total_Amount],s.[Order_Date])

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

--QUESTION 6

alter table Orders add ValueCategory nvarchar(10);

declare @AVG_AMOUNT decimal(10,2)
select @AVG_AMOUNT = avg(total_amount) from Orders

update Orders
set ValueCategory =
case 
    when Total_Amount > @AVG_AMOUNT then 'HighValue'
    else 'LowValue'
end;

select * from Orders


-- QUESTION 7


CREATE FUNCTION FUN_Mask(@input VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @masked VARCHAR(50)
    SET @masked = LEFT(@input, 2) + replicate('*', LEN(@input) - 4) + RIGHT(@input, 2)
    RETURN @masked
END


SELECT dbo.FUN_Mask('1234567890') AS MaskedString

--QUESTION 8

;with cte_deletedupl
as
(
select *,ROW_NUMBER() over(partition by Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY order by Order_ID) as rowNum
from Orders
)
delete from cte_deletedupl where rowNum > 1
