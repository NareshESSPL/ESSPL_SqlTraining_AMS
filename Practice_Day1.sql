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
VALUES (112, 'Kavita', 'Headphones', 6, '2023-07-19', 12000.00, 'Electronics');

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


---------------------------------------
--1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)

UPDATE Orders
SET Total_Amount= (Total_Amount*(isnull(d.Discount_Percentage,0 )/100))
from Orders o left join Discounts d on o.Product=d.product

select * from Orders
select * from Discounts
select d.Discount_Percentage,o.Product 
from 
	orders o left join 
	Discounts d
	on o.Product=d.Product

select o.Product,d.Discount_Percentage,o.Total_Amount 
from 
	Orders o left join Discounts d 
	on d.Product=o.Product
where Discount_Percentage is not null
go

select o.Product as product_name,isnull((o.Total_Amount-(o.Total_Amount*d.Discount_Percentage)/100),0) as updated_total_amount 
from 
	Orders o left join Discounts d 
	on d.Product=o.Product
go

select o.Product as product_name,isnull(d.Discount_Percentage,0) as discount_percentage
from Orders o left join Discounts d
on d.Product=o.Product
go

select o.Product as product,
	isnull(d.Discount_Percentage,0) as percentage_dicount,
	isnull(o.Total_Amount*(d.Discount_Percentage/100),0) as  discounted_amount
from Orders o left join Discounts d on o.Product=d.Product
go

---------------------------------------------------
--2. Delete orders placed by customers who have placed more than 5 orders:

delete from Orders where Customer_Name in(
select Customer_Name from Orders group by Customer_Name having count(*)>5)

delete from Orders where Customer_Name in(
select Customer_Name,avg(total_amount) as Avg_Amount_or_Total_Amount from Orders group by Customer_Name having sum(Quantity)>3
)

---------------------------------------------------------

--3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:

select * into Cust_Order from Orders where Total_Amount>50000
select * from Cust_Order

----------------
--for customer who order >50000 insert into new table

select * into Orders_Cust
from Orders
where Customer_Name in (select Customer_Name from Orders group by Customer_Name having sum(Total_Amount)>60200)
select * from Orders_Cust


--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 500
-- and  where EconomyTotal_Amount between 2000 and 50000

select Order_ID,CATEGORY,Total_Amount into ProductSummary from Orders
select * from ProductSummary

drop table ProductSummary
add catagory varchar(100)

update ProductSummary
set catagory = iif((Total_Amount>50000),'Premium','Economy')

create table ProductSummary(
	Order_ID INT PRIMARY KEY,
	Total_Amount int,
	Catagory varchar(100)
)

insert into ProductSummary
select Order_ID,Total_Amount,
   case 
	 when Total_Amount>50000 then 'Premium'
	 when Total_Amount between 20000 and 50000 then 'Economy'
	 else 'other'
	end
from Orders
go
-------------------------

CREATE TABLE OrderSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

MERGE OrderSummary os
    USING Orders o
ON (o.Order_ID = os.Order_ID)
	WHEN MATCHED
    THEN UPDATE 
	SET os.Product = o.Product

	WHEN NOT MATCHED BY TARGET 
    THEN INSERT (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
         VALUES (o.Order_ID, o.Customer_Name, o.Product, o.Quantity, o.Order_Date, o.Total_Amount, o.CATEGORY)
	WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

select * from OrderSummary
go

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (115, 'Deva', 'Coffee Maker', 1, '2024-07-04', 4000.00, 'Furniture');
INSERT INTO OrderSummary(Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (118, 'Devil', 'Coffee Maker', 1, '2025-07-04', 4000.00, 'Furniture');


----------------------------

--5.Update the CATEGORY in the Orders table based on the average Total_Amount

update Orders
set CATEGORY = 'High Value'
where Total_Amount >
(select avg(Total_Amount) from Orders
go
select * from Orders

------or--------------
--more effort for below query
declare @average_amount int
set @average_amount=(select avg(Total_Amount) from Orders)

-----------------

create function Mask(@account_no nvarchar(250))
returns nvarchar(250)
as begin 
	return left(@account_no,2)+'*******'+right(@account_no,2)
end
SELECT
    Order_ID,
    dbo.Mask(Total_Amount) AS MaskedTotalAmount
FROM
    Cust_Order;
go

create function MaskedDetail(@AnyNo varchar(250))
returns varchar(250)
as begin
	return '*******'+right(@AnyNo,2)
end
SELECT
    Order_ID,
    dbo.MaskedDetail(Total_Amount) AS MaskedTotalAmount
FROM
    Cust_Order;
select * from Cust_Order
go
---------------------------------
--8.Remove duplicate orders where all attributes are identical:

;with cte_duplicate as (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY  [Customer_Name]
      ,[Product]
      ,[Quantity]
      ,[Order_Date]
      ,[Total_Amount]
      ,[CATEGORY] ORDER BY Total_Amount) AS RowNumber

FROM Orders
)
delete from cte_duplicate
where RowNumber>1

go
INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (113, 'Kavita', 'Shoes', 6, '2023-07-19', 12000.00, 'Electronics');