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

select * from Orders

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

select * from Discounts;
select * from Employees;
select * from Orders;
 --q1-----------------------------------------

delete from Orders where Customer_Name in (
select customer_name  from Orders o group by  customer_name having  sum(quantity)>5)
----q2---------------------------------------------------

select o.Customer_Name,o.Product,
o.Total_Amount,o.Total_Amount*(100-isnull( d.Discount_Percentage,0))/100 as reduced_amout
from orders o left join Discounts d on o.Product=d.Product;
--q3-------------------------------------------------------------

select * into TopOrders from Orders where Total_Amount>50000;

--q4---------------------------------------------------------------------

select Order_ID,Customer_Name,Product,Quantity,
order_date,total_amount,CATEGORY,
case 
 when o.total_amount >50000 then 'premium'
 when o.total_amount >2000 and  o.total_amount<50000 then 'economy'
 else 'other'
end as class
into ProductSummary from Orders o;


select * from ProductSummary;

---q5--------------------------------------------------

CREATE TABLE OrdersSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

select * from orders

MERGE OrdersSummary t
 USING Orders s ON s.order_id= t.order_id

WHEN MATCHED
    THEN UPDATE
	SET t.[Order_ID] =s. Order_ID, 
      t.[Customer_Name] = s.Customer_Name,
      t.[Product] = s.Product,
      t.[Quantity] = s.Quantity,
      t.[Order_Date] =s.Order_Date,
      t.[Total_Amount] = s.Total_Amount,
      t.CATEGORY = s.CATEGORY
WHEN NOT MATCHED BY TARGET
    THEN INSERT
           (
		   [Order_ID]
           ,[Customer_Name]
           ,[Product]
           ,[Quantity]
           ,[Order_Date]
           ,[Total_Amount]
           ,[CATEGORY]
		  )
     VALUES
           (
		   s.Order_ID,
           s.Customer_Name,
           s.Product,
           s.Quantity,
           s.Order_Date,
           s.Total_Amount,
           s.CATEGORY
		   )

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

---q6-----------------------------------------------------------

alter table orders add valuecategory nvarchar(100);

UPDATE Orders
SET CATEGORY = 
    CASE 
        WHEN Total_Amount > (SELECT AVG(Total_Amount) FROM Orders) THEN 'High Value'
        ELSE 'Low Value'
    END;

--------------------------------------------------------



--Retrieve orders where the Total_Amount is greater than the average Total_Amount of all orders.
SELECT o.Order_ID, o.Product, o.Total_Amount
FROM orders o
WHERE o.Total_Amount > (
    SELECT AVG(Total_Amount) FROM orders
);

select * from orders ;

--Display the total revenue generated for each product.

select product , SUM(Total_Amount) as tota_revenue from Orders group by Product;

--Find the top 2 highest Total_Amount orders for each customer.

WITH RankedOrders AS (
    SELECT Order_ID, Customer_Name, Product, Total_Amount,
           RANK() OVER (PARTITION BY Customer_Name ORDER BY Total_Amount DESC) AS rank
    FROM Orders
)
SELECT Order_ID, Customer_Name, Product, Total_Amount
FROM RankedOrders
WHERE rank <= 2;

---------------------------------------------------------------
----function to mask number

CREATE FUNCTION FUN_Mask(@input VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @masked VARCHAR(50)
    SET @masked = LEFT(@input, 2) + REPLICATE('*', LEN(@input) - 4) + RIGHT(@input, 2)
    RETURN @masked
END

SELECT dbo.FUN_Mask('1234567890') AS MaskedString

--Remove duplicate orders where all attributes are identical:-----------------------------------------------
with table1 as(
	select *,ROW_NUMBER() over(partition by customer_name order by Order_ID) as rowNum
	from Orders
)
delete from table1
where rowNum>1;

----------------------------------------------------------------------
---------question 8

;with cte_deletedupl
as
(
select *,ROW_NUMBER() over(partition by Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY order by Order_ID) as rowNum
from Orders
)
delete from cte_deletedupl where rowNum > 1











