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

truncate table Orders;
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

create table Discounts
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
VALUES (4, 'Bob', 'Brown', 'Analyst', 50000.00)

select * from Orders;
select * from Discounts;
select * from Employees;
----Question 1
--1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)

;with cte_order as(
select c.Order_ID,c.Total_Amount ,d.Discount_Percentage
from Orders c
left join
Discounts d 
on c.Product=d.Product
)
update  cte_order
set Total_Amount=isnull(Total_Amount-Total_Amount* (Discount_Percentage /100),0) 
where Order_ID in(select Order_ID from cte_order);


update orders
set Total_Amount=ISNULL(Total_Amount-Total_Amount* (isNull (Discount_Percentage,0) /100),0)
from Orders c
left join
Discounts d 
on c.Product=d.Product;

select * FROM Orders;

--------------------------------------------------------------------------------------------------------
--Question 2
--2. Delete orders placed by customers who have placed more than 5 orders:
select Customer_Name 
from Orders
group by Customer_Name
having count(Customer_Name)>=5;

delete from Orders
where Customer_Name in(
select Customer_Name 
from Orders
group by Customer_Name
having Sum(Quantity)>=5
)
---------------
--Question 3
 --Insert records into a TopOrders table for orders exceeding a total amount of ?50,000:
 --3. Insert records into a TopOrders table for orders exceeding a total amount of ?50,000:
create TABLE TopOrders(  
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
create TABLE TopOrders1(  
   TopOrdersId bigint identity(1,1),
   Customer_Name NVARCHAR(50),
    Quantity INT,
    Total_Amount DECIMAL(10, 2),
	Order_Date datetime default getdate() 
 );
 select * from TopOrders;
 select * from TopOrders1;
 insert into TopOrders1(Customer_Name,Quantity,Total_Amount)
 select Customer_Name,sum(Quantity),Sum(Total_Amount)
 from Orders
 group by Customer_Name
 having sum(Total_Amount)>=50000;

 -------------------------------------------------
 --Question4
 --
 create table ProductSummary
 (
 
    Product NVARCHAR(50),
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
	);
	truncate table ProductSummary
	select * from ProductSummary;
insert into ProductSummary   
select o.Product,o.Total_Amount,case
	when Total_Amount>50000 then 'Premium'
	when Total_Amount between 20000 and 50000 then 'Economy'
	else 'General'
end as category
from Orders o;
--------------------------------------------------------
--Question 5
--Upsert recorde into the OrderSummary table to update existing rows or insert new ones;
CREATE TABLE OrderSumamry (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

Merge OrderSumamry t
using Orders s on s.Order_ID=t.Order_Id

when matched 
	then update set t.Customer_Name=s.Customer_Name,t.Product=s.Product,
	t.Quantity=s.Quantity,t.Order_Date=s.Order_Date,t.Total_Amount=s.Total_Amount,t.Category=s.category

when not matched by target
	then insert (Order_ID,Customer_Name,Product,Quantity,Order_Date,Total_Amount,Category)
	values(s.Order_Id,s.Customer_Name,s.Product,s.Quantity,s.Order_Date,s.Total_Amount,s.Category);
--------------------------------------------------------------
--Question 6
--Update the category in the orders table based on the average Total_Amount
UPDATE Orders 
set CATEGORY='HIGH VALUE'
where Orders.Total_Amount>(select AVG(Total_Amount) from Orders );

with cte_category as(
select Avg(o.Total_Amount) as avg_amount from orders o
)

declare @Avg_Amount decimal(10,2)
select @Avg_Amount = Avg(o.Total_Amount) from orders o 
UPDATE orders
set CATEGORY=iif(@Avg_Amount < Total_Amount,'High value','Low value')
----------------------------------------------------
--Question 7
--create a function 
--input-101111111
--output-11******
create function fun_Mask(
@input varchar(10)
)
returns varchar(10)
as 
begin

declare @output varchar(10)
set @output=left(@input,2)+'******'+right(@input,3)

return @output
end
select * from orders

print dbo.fun_Mask(1100011001)

declare @left_val varchar(10),@right_val varchar(10),@input varchar(10)
set @input='preeti'
set @right_val=right(@input,3)
set @left_val=left(@input,3)
print @left_val
print @right_val

----------------------------
--Question 8
---remove duplicate orders  where all attricutes are identical

select * ,
ROW_NUMBER() OVER(partition by Customer_Name,Quantity,Order_Date,Total_Amount,Category,product ORDER BY Product) AS ROWNUMBER,
RANK() OVER(partition by Customer_Name,Quantity,Order_Date,Total_Amount,Category,product ORDER BY Product) AS [Rank],
DENSE_RANK() OVER(partition by Customer_Name,Quantity,Order_Date,Total_Amount,Category,product ORDER BY Product) as [denseRank]
from Orders;

with cte_raw as(
select *,ROW_NUMBER() OVER(partition by Customer_Name,Quantity,Order_Date,Total_Amount,Category,product ORDER BY Product) AS ROWNUMBER
from orders)
DELETE FROM cte_raw where ROWNUMBER>1;
select * 
from cte_raw 
where ROWNUMBER>1;
