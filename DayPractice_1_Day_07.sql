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

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (5, 'Bob', 'Brown', 'Analyst', 50000.00);


--Make the diacount 100%

select 
O.Order_ID,
O.Customer_Name,
O.Product,
O.Total_Amount as  Previous_Price,
O.Total_Amount-(Total_Amount * isnull(d.Discount_Percentage/100,0)) as Final_Price ,
d.Discount_Percentage from 
 Orders O
 left join
 Discounts d
on  O.Product = d.Product  ;
--
select * from Orders;
--update the and ad the col in the Orders

---since we can't selecct and update at a time so we need to only perform the set operation
Update Orders 
set Total_Amount = O.Total_Amount-(Total_Amount * isnull(d.Discount_Percentage/100,0))  
 from 
 Orders O
 left join
 Discounts d
on  O.Product = d.Product ;
select * from Orders;

---delete orders placed by customers who have placed more than 5 orders
delete from Orders 
where Customer_Name in(
select Customer_Name  from Orders group by Customer_Name having Sum(Quantity) >5
);

select * from Orders;

---- create table TopOrders for order exceeding a Total_Amount of 50000

CREATE TABLE Top_Orders (
   Order_ID INT PRIMARY KEY,
  Customer_Name NVARCHAR(50),
  Product NVARCHAR(50),
  Quantity INT,
  Order_Date DATE,
  Total_Amount DECIMAL(10, 2),
  CATEGORY NVARCHAR(50)
)

select * from Orders

INSERT INTO Top_Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
(SELECT Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY
FROM Orders
WHERE Total_Amount > 50000)

--Q4 
--create table Productsummary for order make a column catagory 
--con-1 exceeding a Total_Amount of 50000 is premium and 
--condition-2   a Total_Amount between 20000 of 50000 is Economy and 
--condition-3 General


Create table Product_Summary
(
Total_Amount DECIMAL(10, 2),
Catagory Varchar(50)
)

INSERT INTO Product_Summary(Total_Amount,Catagory)
select Total_Amount,
-- here we don't write the CASE expression bcz here we compairing the boolean value not the string type
CASE 
    WHEN Total_Amount > 50000 THEN 'Premium'
    WHEN Total_Amount > 20000 THEN 'Economy'
    ELSE 'General'
END as Catagory
from Orders ;

---Upsert(Combi of Update and Insert) record into the OrderSummary table to update existing rows or insert new ones;
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

MERGE INTO OrderSummary t
 USING Orders s 
 ON t.Order_ID = s.Order_ID

WHEN MATCHED
    THEN UPDATE SET 
		t.Order_ID = s.Order_ID,
		t.Customer_Name = s.Customer_Name,
		t.Product = s.Product,
		t.Quantity = s.Quantity,
		t.Order_Date = s.Order_Date,
		t.Total_Amount = s.Total_Amount,
		t.CATEGORY = s.CATEGORY
        

WHEN NOT MATCHED BY TARGET
    THEN INSERT (Order_ID, Customer_Name,Product, Quantity, Order_Date, Total_Amount, CATEGORY) 
	values (s.Order_ID, s.Customer_Name, s.Product,s.Quantity, s.Order_Date,s.Total_Amount,s.CATEGORY);

select * from OrderSummary

----update catagory col in the order on the basisi of avg(Total_Amount)

update Orders
 set CATEGORY = 'highvalue'
 where Total_Amount > ( select avg(Total_Amount) from Orders)

 ----create function for masking of 10 digit no as 58******98
CREATE FUNCTION MaskingNumber (@original_num VARCHAR(10))
RETURNS VARCHAR(10)
AS
BEGIN
    
    DECLARE @masked_num VARCHAR(10);
    SET @masked_num = LEFT(@original_num, 2) + '******' + RIGHT(@original_num, 2);

    RETURN @masked_num;
END;
GO

DECLARE @original_num VARCHAR(10) = '9876543210';
SELECT MaskingNumber(@original_num) AS MaskedNumber;


---finding duplicate records
;With CTE_Accuring_Duplicate 
as
(
SELECT EmployeeID,FirstName,LastName,row_number()over(partition by FirstName, LastName, Position, Salary order by salary)as 
ROW_NUM ,Position,Salary from Employees
)
DELETE FROM CTE_Accuring_Duplicate
WHERE ROW_NUM > 1;

select * from Employees;


