Create Database Practice
go

use Practice
go

create TABLE Orders (
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

select * from Orders
select * from Discounts
select * from Employees

-- Q1.  Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts) --

Update o
SET o.Total_Amount =IsNull( Total_Amount - (Total_Amount * d.Discount_Percentage / 100.0),0)
FROM Orders o
LEFT JOIN Discounts d ON o.Product  = d.Product 

select ISNULL(d.Discount_Percentage, Discount_Percentage),o.Order_ID,o.CATEGORY,o.Customer_Name,o.Quantity,o.Order_Date,o.Total_Amount , o.Product ,d.Discount_ID from Orders o Left Join Discounts d on o.Product = d.Product

-- Q2. 2. Delete orders placed by customers who have placed more than 5 orders: -- 

DELETE FROM Orders 
WHERE ORDER_ID  IN (
	SELECT Customer_Name
    FROM Orders
    GROUP BY Quantity
    HAVING COUNT(Order_ID) > 5
);

-- 3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:

create TABLE TopOrders (
   Order_ID INT PRIMARY KEY,
   Customer_Name NVARCHAR(50),
   Product NVARCHAR(50),
   Quantity INT,
   Order_Date DATE,
   Total_Amount DECIMAL(10, 2),
   CATEGORY NVARCHAR(50)
);

Insert into TopOrders (Order_ID , Customer_Name,Product,Quantity,Order_Date,Total_Amount,CATEGORY)
SELECT  Order_ID,Customer_Name,Product,Quantity,Order_Date,Total_Amount,CATEGORY  from Orders 
where
Total_Amount > 50000; 

select * from TopOrders

 -- Q4.  Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium'   where Total_Amount > 50000
--and 'Economy' where EconomyTotal_Amount between 20000 and 50000

create table ProductSummary (
Total_Amount DECIMAL (10,2),

Category nVarchar(100)
)

insert into ProductSummary(Category,Total_Amount)
SELECT	
	CASE	
		WHEN Total_Amount > 50000 THEN 'Premium'
		WHEN Total_Amount  BETWEEN 2000 AND 50000  THEN 'Economy'
		ELSE 'INVALID'
	END AS Category,
	Total_Amount
FROM Orders

select * from ProductSummary

--Q5. Upsert records into the OrderSummary table to update existing rows or insert new ones--


create TABLE OrderSummary (
   Order_ID INT PRIMARY KEY,
   Customer_Name NVARCHAR(50),
   Product NVARCHAR(50),
   Quantity INT,
   Order_Date DATE,
   Total_Amount DECIMAL(10, 2),
   CATEGORY NVARCHAR(50)
);

MERGE INTO OrderSummary AS target
USING Orders AS source
ON target.Order_ID = source.Order_ID
WHEN MATCHED THEN
    UPDATE SET 
        target.Total_Amount = source.Total_Amount,
        target.Order_Date = source.Order_Date
WHEN NOT MATCHED THEN
    INSERT (Order_ID, Total_Amount, Order_Date)
    VALUES (source.Order_ID, source.Total_Amount, source.Order_Date);

 select * from OrderSummary

 -- Q6. Update the category in the orders table based on the average Total_Amount
 -- if total_amount > avg(total_amount) then change it to 'High Value'

 UPDATE Orders
 SET CATEGORY = 'HIGH VALUE'
 where Total_Amount > (Select AVG(Total_Amount) FROM Orders)
  ;
 select * from Orders

 -- Q7.create a function to mask my account number --

 create FUNCTION   dbo.MaskAccountNumber (@AccountNumber VARCHAR(10))
RETURNS VARCHAR(10)
AS
	 BEGIN
		RETURN LEFT(@AccountNumber, 2) + '*****' + RIGHT (@AccountNumber , 3)
	 END;

select dbo.MaskAccountNumber ('1234567898') AS MaskAccountNumber

-- Q8. remove duplicate orders where all attributes are identical


INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (112, 'Ananya', 'Laptop', 1, '2023-06-15', 55000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (113, 'Ananya', 'Headphone', 1, '2023-06-15', 55000.00, 'Electronics');

update orders set Order_Date = '2023-06-15' where Order_ID = 106;


with cte as
(
SELECT 
     *, 
     ROW_NUMBER() OVER (PARTITION BY Customer_Name ,Product, Quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Order_ID) AS Row_Num
FROM 
    Orders
	)
	delete from Orders where Order_Id in (
	Select Order_Id FROM CTE
	where  Row_Num > 1
	);

	select * from Orders