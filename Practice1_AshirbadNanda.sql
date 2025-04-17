
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
VALUES (982, 'Kavita', 'Headphones', 6, '2023-07-19', 12000.00, 'Electronics');

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
VALUES (4, 'Bob', 'Brown', 'Analyst', 50000.00);

--1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
--total_amount=total-discount/100
update Orders set Total_Amount=o.Total_Amount-(o.Total_Amount*(ISNULL(d.Discount_Percentage,0)/100))
from Orders o left join Discounts d on o.Product=D.product 
      -- or
--using right join
--update Orders set Total_Amount=o.Total_Amount-(o.Total_Amount*(d.Discount_Percentage/100))
--from Orders o right join Discounts d on o.Product=D.product 

select customer_name,count(quantity) as total_no_of_orders from orders 
group by customer_name having count(quantity)>5;
--2.delete orders placed by customers who have more than 5 orders
delete from orders where customer_name in  (select customer_name  from orders 
group by customer_name having count(quantity)>5);
select * from Orders
---------------------------------------------------------------------------------------
--3. Insert records into a TopOrders table for orders exceeding a total amount of 50,000:
select * into TopOrder  from Orders where Total_Amount>50000;
---imp
--syntax select column1,column2 into newtable from oldtable where condition;
select * from TopOrder
---------------------------------------------------------------------------------------
--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 500
-- and  where Economy Total_Amount between 2000 and 50000
create table ProductSummery(
Customer_name varchar(200),Class Varchar(400)
)
insert into ProductSummery(Customer_name,Class)
select Customer_Name,
  case 
      when Total_Amount>50000 then 'premium'
	  when Total_Amount<50000 and Total_Amount>2000 then 'Economy'
	  else 'less_to_economy'
	  end as class
from Orders;
select * from ProductSummery
select Customer_name,Total_Amount,Category into ProductSummery2 from Orders; 
select * from ProductSummery2
update ProductSummery2 set 
category=
      case 
         when Total_Amount>50000 then 'premium'
	     when Total_Amount<50000 and Total_Amount>2000 then 'Economy'
	     else 'less_to_economy'

	  end
	  ------------------------------------------------------------------------------------------

--5.Upsert records into the orderSummary table  to update existing rows or insert new ones from order table
select * into orderSummery3 from orders where 1=0;
select * from OrderSummery3

merge into OrderSummery3 os
using orders o on o.order_ID=os.order_ID
 when matched then
  update set
   os.order_ID=o.order_ID,
   os.customer_name=o.Customer_name,
   os.product=o.product,
   os.quantity=o.quantity,
   os.order_date=o.order_date,
   os.total_amount=o.total_amount,
   os.category=o.category
when not matched by target
 then insert (order_ID,Customer_name,product,quantity,order_date,total_amount,category)values(o.order_ID,o.Customer_name,
   o.product,
   o.quantity,
  o.order_date,
   o.total_amount,
  o.category)
when not matched by source
 then delete;
 ---------------------------------------------------------------------------------------------
 --6. Update the CATEGORY in the Orders table based on the average Total_Amount
update Orders set category = 'high' where total_amount>(select avg(total_amount) from Orders);
select * from orders
go
------------------------------------------------------------------------------------------------------
--7.create function to form masked account no from normal account no
alter function dbo.mask(
      @account_no varchar(10)
   ) returns varchar(10)
as
begin
    declare @masked_account_no varchar(10);
	set @masked_account_no=substring(@account_no,1,2)+'******'+substring(@account_no,9,2)
   return @masked_account_no
end;
print dbo.mask('1234567890')
go
--------------------------------------------------------------------------------------
--8 romove duplicate orders where all attributes are same
select * from(
    select order_id,Customer_name,row_number() over(partition by Customer_name order by order_id) as row_num from Orders ) 
    as x where row_num>1
	select * from Orders

	select order_id,Customer_name,row_number() over(partition by Customer_name,product,quantity,order_date,total_amount,category order by order_id) as row_num from Orders 
delete from orders where order_id in
	(select x.order_id,x.Customer_Name,x.row_num from
	    (select order_id,Customer_name,product,quantity,order_date,total_amount,category ,
	     row_number() over(partition by Customer_name,product,quantity,order_date,total_amount,category 
	     order by order_id) as row_num from Orders ) 
    as x where x.row_num>1)



