Create Database Practice
--go

use Practice
--go

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

drop table orders;

Alter table orders
add DiscountAmount decimal(10,2);

select * from orders;

select * from Discounts;

select * from Employees;

--update o
--set o.total_Amount=o.total_Amount-(o.total_amount*d.Discount_Percentage/100)
--from orders o join Discounts d on o.Product=d.Product;

update o
set o.DiscountAmount=o.total_Amount-isnull(o.total_amount*d.Discount_Percentage/100,0)
from orders o left join Discounts d on o.Product=d.Product;

select * from Orders;

alter table Orders drop column DiscountAmount

delete from Orders
where Customer_name in(
select Customer_name from Orders
group by Customer_name having sum(Quantity)>5);

--select Customer_name from Orders
--group by Customer_name having sum(Quantity)=2

CREATE TABLE TopOrders (
    Customer_Name NVARCHAR(50),
    Total_Amount DECIMAL(10, 2),
);

select * from TopOrders;

drop table TopOrders

insert into TopOrders(Customer_Name,Total_Amount)
select Customer_Name,sum(Total_Amount) as total from Orders
group by customer_name having sum(Total_Amount)>50000;

drop table productSummary

CREATE TABLE productSummary (
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

--insert into productSummary(Customer_Name,Product,Total_Amount,category)
--	select Customer_Name,Product,Total_Amount,
--	case
--		when Total_Amount>50000 then 'Premium'
--		when Total_Amount      50000 and 20000 then 'Economy'
--		else 'Othera'
--	end as category
--	from orders

insert into productSummary(Customer_Name,Product,Total_Amount,category)
	select Customer_Name,Product,Total_Amount,
	case
		when Total_Amount>50000 then 'Premium'
		when Total_Amount<50000 and Total_Amount>20000 then 'Economy'
		else 'Others'
	end as category
	from orders

select * from productSummary;


create function funcMask(@accountNo varchar(20))
returns varchar(20)
as begin
	return concat(left(@accountNo,2),replicate('*',len(@accountNo)-4),right(@accountNo,2))
end

select dbo.funcMask(123467890);

select customer_name from orders group by Customer_Name having count(*)>1;

select * from Orders;

delete from orders
where Order_ID not in(
	select min(Order_ID)
	from Orders
	group by Customer_Name
);

DELETE FROM Orders
WHERE Order_ID IN (
    SELECT Order_ID
    FROM (
        SELECT Order_ID,
               ROW_NUMBER() OVER (PARTITION BY Customer_Name ORDER BY Order_ID) AS rn
        FROM Orders
    ) AS temp
    WHERE rn > 1
); 
