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
  VALUES (113, 'Kavita', 'Headphones', 6, '2023-07-19', 12000.00, 'Electronics');
go

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
go

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
go

  select * from Orders
  select * from Discounts
  select * from Employees
go
  
  --PRACTICE QUESTINOS
  --1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
  ;with cte_OrdersAndDiscounts as(
     select O.Total_Amount,D.Discount_Percentage 
	 from Orders O left join Discounts D on D.Product = O.Product
	 where Discount_Percentage is not null
  )
  update cte_OrdersAndDiscounts 
  set Total_Amount =Total_Amount- (Total_Amount *(Discount_Percentage/100)) 
go

--2. Delete orders placed by customers who have placed more than 5 orders:
delete from Orders where Customer_Name in (
  select Customer_Name from Orders group by Customer_Name having COUNT(Order_ID) > 5
)
go


--3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000
 CREATE TABLE TopOrders (
      Order_ID INT PRIMARY KEY,
      Customer_Name NVARCHAR(50),
      Product NVARCHAR(50),
      Quantity INT,
      Order_Date DATE,
      Total_Amount DECIMAL(10, 2),
      CATEGORY NVARCHAR(50)
  ); 

insert into TopOrders 
select * from Orders where Total_Amount > 50000

select * from TopOrders
go


--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 500
-- and 'Economy' where Total_Amount between 2000 and 50000
create table ProductSummary(Total_Amount decimal(10,2), Category varchar(100))

insert into ProductSummary 
select Total_Amount ,
case 
   when Total_Amount > 50000 then 'Premium'
   when Total_Amount between 2000 and 50000 then 'Economy'
   else 'Invalid'
end
from Orders

select * from ProductSummary
go


--5.Upsert records into OrderSummary table from Orders table
create table OrderSummary(
      Order_ID INT PRIMARY KEY,
      Customer_Name NVARCHAR(50),
      Product NVARCHAR(50),
      Quantity INT,
      Order_Date DATE,
      Total_Amount DECIMAL(10, 2),
      CATEGORY NVARCHAR(50)
 );

 merge OrderSummary t using Orders s on s.Order_ID = t.Order_ID
 when matched 
 then update set t.Customer_Name = s.Customer_Name,
                 t.Product = s.Product,
				 t.Quantity = s.Quantity,
				 t.Order_Date = s.Order_Date,
				 t.Total_Amount = s.Total_Amount,
				 t.CATEGORY = s.CATEGORY

 when not matched by target 
 then insert(Order_ID ,Customer_Name ,Product ,Quantity ,Order_Date ,Total_Amount ,CATEGORY)
 values (s.Order_ID ,s.Customer_Name ,s.Product ,s.Quantity,s.Order_Date ,s.Total_Amount ,s.CATEGORY)

 WHEN NOT MATCHED BY SOURCE 
 THEN DELETE;

 select * from OrderSummary
 
 go


 --6.update the categry based on the average of total amount
 declare @avg_TAmount decimal(10,2)
 set @avg_TAmount = (select avg(Total_Amount) from Orders )
 update Orders 
 set CATEGORY = iif(Total_Amount > @avg_TAmount, 'High Value', 'Low Value')

 --update Orders 
 --set CATEGORY = iif(Total_Amount > (select avg(Total_Amount) from Orders), 'High Value', 'Low Value')

 select * from Orders
 go


 --7.mask the aaccount no
 create function fn_maskAccountNO (@AccountNO nvarchar(100)) 
 returns nvarchar(100)
 as begin
    return left(@AccountNO,2) + LPAD(right(@AccountNO,2),length(@AccountNo)-2,'*')
 end

 print dbo.fn_maskAccountNO(122345678);
 go


 --remove duplicate orders where all attributes are identical
 delete from Orders
 where Order_ID in
 (
 select Order_ID from 
 (
   select Order_ID,
   rn = ROW_NUMBER() OVER (PARTITION BY Orders.Customer_Name ,Orders.Customer_Name, Orders.Product,Orders.Quantity,Orders.Order_Date,Orders.Total_Amount,Orders.CATEGORY 
   ORDER BY Orders.Order_ID)
   from Orders
  ) as x
  where rn > 1
 )

--remove all the duplicate records from employee table
 ;with cte_duplicates as (
    select EmployeeID, ROW_NUMBER() over (partition by FirstName, LastName, Position, Salary order by EmployeeID) as rnk 
	from Employees
	--select * from Employees
 )

 select * from Employees e1 join cte_duplicates e2 on e1.EmployeeID = e2.EmployeeID 

 delete from Employees where EmployeeID in (
    select EmployeeID from cte_duplicates where rnk > 1
 )

 --using join find duplicate id's
 select distinct e1.* from Employees e1 join Employees e2
 on  e1.FirstName = e2.FirstName and e1.LastName = e2.LastName and e1.Position = e2.Position and e1.Salary = e2.Salary and e1.EmployeeID > e2.EmployeeID
go

--update quantity column of orders as the cumulative sum of orders by customer name
;with cte_SumByName as(
    --select * from Orders
    select sum(Quantity) s,Customer_Name from Orders group by Customer_Name
)
update O 
set O.Quantity = C.s 
from Orders O join cte_SumByName C on O.Customer_Name = C.Customer_Name 
