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

truncate table Orders
INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (101, 'Ananya', 'Laptop', 1, '2023-06-15', 55000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (102, 'Ananya', 'Mobile Phone', 2, '2023-06-18', 60000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (113, 'Chitra', 'Office Chair', 4, '2023-07-01', 28000.00, 'Furniture');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (114, 'Dev', 'Coffee Maker', 1, '2023-07-04', 4000.00, 'Furniture');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (105, 'Esha', 'Dining Table', 1, '2023-07-10', 15000.00, 'Furniture');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (106, 'Ananya', 'Headphones', 1, '2023-06-16', 2000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (107, 'Bharat', 'Charger', 1, '2023-06-20', 2000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (108, 'Harsh', 'Headphones', 1, '2023-07-16', 2000.00, 'Electronics');

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (119, 'Ishita', 'Headphones', 2, '2023-07-17', 4000.00, 'Electronics');

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



--1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
UPDATE Orders
SET Total_Amount = Total_Amount * (Discount_Percentage / 100)
FROM Orders
JOIN Discounts
ON Orders.Product = Discounts.Product; 

select * from Orders 
select * from Discounts

UPDATE Orders
SET Total_Amount =isnull( Total_Amount * ( isnull( Discount_Percentage,0)/ 100),0)
FROM Orders
LEFT JOIN Discounts
ON Orders.Product = Discounts.Product; 
select * from Orders 

truncate table Orders
/*2.check by own
UPDATE Orders
SET Total_Amount =coalesce( Total_Amount * ( coalesce( Discount_Percentage)/ 100))
FROM Orders
LEFT JOIN Discounts
ON Orders.Product = Discounts.Product; */

--delete orders placed by customers who have placed more than 5 orders;

delete from Orders where Customer_Name in
(select Customer_Name
from Orders
group by Customer_Name
having sum(Quantity)>=5)
select * from Orders

--3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:
create TABLE TopOrders (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
    
    
);
insert into TopOrders 
select * from Orders where Total_Amount>=50000;
select * from TopOrders 

--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 50000
-- and  where Economy Total_Amount between 2000 and 50000

truncate TABLE ProductSummary  (
    Product NVARCHAR(50),
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
    
);
insert into ProductSummary
select o.Product,o.Total_Amount,
case
   when Total_Amount >50000 then 'premium'
   when Total_Amount between 20000 and 50000 then 'Economy'
  else 'general'
end as category
from Orders o;
select * from ProductSummary

/*5.upsert records into the ordersummary table to update existing rows or insert new ones;*/
CREATE TABLE Ordersummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

MERGE Ordersummary t
USING  Orders s ON s.Order_ID= t.Order_ID


WHEN MATCHED
    THEN UPDATE SET 
	    t.Order_ID = s.Order_ID,
        t.Customer_Name = s.Customer_Name,
		t.Product =s.Product,
		t.Quantity =s.Quantity ,
		t.Order_Date=s.Order_Date,
		t.Total_Amount=t.Total_Amount,
		t.CATEGORY=s.CATEGORY


WHEN NOT MATCHED BY TARGET
    THEN INSERT (Order_ID,Customer_Name,Product,Quantity,Order_Date,Total_Amount,CATEGORY)
	values(s.Order_ID,s.Customer_Name,s.Product,s.Quantity,s.Order_Date,s.Total_Amount,s.CATEGORY);

/*6.update the category in the orders table based on the average Total_Amount
if total_amount > avg(total_amount)'high values'*/

update Orders
set CATEGORY='high values'
where Orders.Total_Amount>(select avg(Total_Amount)from Orders);
select * from Orders

/*7.write a function */
CREATE FUNCTION fun_mask(
@input varchar(10)
)
returns varchar(10)
as
begin

declare @output varchar(10)
set @output=left(@input,2)+'******'+right(@input,3)

return @output
end
print dbo.fun_mask(1100011000)

/*8.remove duplicate orders where all attributes are identical*/

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Customer_Name ORDER BY Product ) AS RowNumber,
/*ROW_NUMBER() OVER(PARTITION BY Qunatity ORDER BY Product ) AS RowNumber,
ROW_NUMBER() OVER(PARTITION BY Order_Date ORDER BY Product ) AS RowNumber,
ROW_NUMBER() OVER(PARTITION BY Total_Amount ORDER BY Product ) AS RowNumber,
ROW_NUMBER() OVER(PARTITION By CATEGORY ORDER BY Product ) AS RowNumber*/
RANK() OVER(PARTITION BY  Customer_Name ORDER BY Product) AS [Rank],
DENSE_RANK() OVER(PARTITION BY Customer_Name  ORDER BY Product) AS [DenseRank]
FROM [dbo].[Orders]
select * from Orders;

;with cte_row as(
SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Customer_Name, Quantity, Order_Date,Total_Amount, CATEGORY ORDER BY product) AS RowNumber
FROM [dbo].[Orders])
delete from cte_row where RowNumber >1;
select * 
from cte_row
where RowNumber >1;


















