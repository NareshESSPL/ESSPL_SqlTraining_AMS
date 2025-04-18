/*
CreatedBy - Aditya Shukla
Date - 17/04/2025
Description - SQL Practice Questions
*/

Create Database Practice
go

use Practice
go
 --Creating Table Orders
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

--Inserting values in Table Orders
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

--------------------------------------------------------------------------------------------

--Creating table discounts
Create table Discounts
(
  Discount_ID INT PRIMARY KEY,
  Product NVARCHAR(50),
  Discount_Percentage float
)
--Inserting Values into table Discounts
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (1, 'Headphones', 10)
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (2, 'Coffee Maker', 10)
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (3, 'Charger', 10)
INSERT INTO Discounts (Discount_ID, Product, Discount_Percentage) VALUES (4, 'Mobile Phone', 10)

-----------------------------------------------------------------------------------------------

--Creating Table Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Position NVARCHAR(50),
    Salary DECIMAL(10, 2)
);
--Inserting Values into table Employess
INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (1, 'John', 'Doe', 'Manager', 75000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (2, 'Jane', 'Smith', 'Developer', 60000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (3, 'Alice', 'Johnson', 'Designer', 55000.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Salary)
VALUES (4, 'Bob', 'Brown', 'Analyst', 50000.00);

----------------------------------------------------------------------------------------------

--Q1 Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)

DECLARE @totalAmt DECIMAL(10,6);
SET @totalAmt =  Total_Amount - (Total_Amount * Discount_Percentage)/100;

UPDATE Orders 
--JOIN Discount d ON Orders.Product = d.Product
SET Total_Amount = (O.Total_Amount - (O.Total_Amount * ISNULL(d.Discount_Percentage, 0) /100))
--(O.Total_Amount - (O.Total_Amount * COALESCE(d.Discount_Percentage,0)/100))
FROM Orders O
LEFT JOIN Discounts d 
ON O.Product = d.Product ;

SELECT * FROM Orders;
SELECT * FROM Discounts;

--Q2. Delete orders placed by Customers who have placed more than 5 orders
--BY QUANTITY
DELETE FROM Orders
WHERE Customer_Name IN (
      SELECT Customer_Name
	  FROM Orders
	  GROUP BY Customer_Name
	  HAVING SUM(Quantity) > 5
);
SELECT * FROM Orders

--BY ORDERS
DELETE FROM orders WHERE Customer_Name IN
(SELECT Customer_Name FROM Orders GROUP BY Customer_Name HAVING  COUNT(*) > 5);

--Q3. Insert records into a TopOrders table for orders exceeding a total amount of ?50,000:

/*
1 WAY
CREATE TABLE TopOrder
(
  Order_ID INT PRIMARY KEY,
  Customer_Name NVARCHAR(50),
  Product NVARCHAR(50),
  Quantity INT,
  Order_Date DATE,
  Total_Amount DECIMAL(10, 2),
  CATEGORY NVARCHAR(50) 
);

INSERT INTO TopOrder( Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY) 
SELECT Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY
FROM Orders
WHERE Total_Amount > 50000;
*/

/*
WAY 2
HERE WE ARE CLONING THE TABLE ORDERS
*/
SELECT * FROM Orders;
SELECT * INTO TopOrders FROM Orders WHERE Orders.Total_Amount > 50000
SELECT * FROM TopOrders;


--Q4. Insert in.Conditional Insert with a CASE Statement
    --insert into ProductSummary table where Category columns
    --will have two type values one is 'Premium' where Total_Amount > 500
    --and  where EconomyTotal_Amount between 2000 and 50000

CREATE PROC Proc_Insert_Summary
AS
  BEGIN
  SELECT Product, Total_Amount, CATEGORY INTO ProductSummary FROM Orders;

  UPDATE ProductSummary 
  SET CATEGORY =
  CASE 
      WHEN Total_Amount > 50000
	  Then 'Premium'
	  WHEN Total_Amount BETWEEN 2000 AND 50000
	  THEN 'Economy'
	  ELSE 'Other'
  END
END
--DROP TABLE ProductSummary
EXEC Proc_Insert_Summary;
SELECT * FROM ProductSummary;

--Q5. Upsert(update or insert) records into OrderSummary table to update existing rows or  insert new  ones
SELECT * FROM Orders;
SELECT * INTO OrderSummary FROM Orders WHERE 1=0;

MERGE OrderSummary OS
USING Orders O ON OS.Order_ID = O.Order_ID

WHEN MATCHED THEN
    UPDATE 
	SET
        OS.Order_ID = O.Order_ID,
        OS.Order_Date = O.Order_Date,
        OS.Total_Amount = O.Total_Amount
WHEN NOT MATCHED THEN
    INSERT (Order_ID, order_date, total_amount)
    VALUES (O.Order_ID, O.order_date, O.total_amount);

SELECT * FROM OrderSummary;



--Q6. Update the category in the orders table based on the average Total_Amount

/* WAY 1 */
SELECT * FROM Orders

UPDATE Orders 
SET CATEGORY=
    CASE
    WHEN
	Total_Amount > (SELECT AVG(Total_Amount) FROM  Orders) THEN 'HIGH VALUE'
	ELSE 'LOW VALUE'
END
SELECT * FROM Orders;
SELECT AVG(Total_Amount) FROM Orders;

/* WAY 2
Declare @avg Decimal(10,2)
select @avg=avg(Total_Amount) from orders;

update orders
set category=case
	when Total_Amount>@avg then 'High'
	else 'Low'
end
*/

--Q7. Create a function to mask my account no

CREATE FUNCTION mask_account_number
(
 @Account_number VARCHAR(100)
)
 RETURNS VARCHAR(100)
 AS
 BEGIN
   DECLARE @Masked VARCHAR(10) 
    SET @Masked = CONCAT(LEFT(@Account_number,2), 
	REPLICATE('*',LEN(@Account_number)-4), RIGHT(@Account_number,2))
   RETURN @Masked
 END

 PRINT DBO.mask_account_number('1234567892')

--Q8. Remove duplicate 
/* WAY 1
delete from orders
where Order_ID not in(
	select min(Order_ID)
	from Orders
	group by Customer_Name
);
*/
SELECT * FROM Orders;

/* WAY 2 */
DELETE FROM Orders WHERE Order_ID IN
  (SELECT Order_ID FROM 
      (SELECT Order_ID, ROW_NUMBER() OVER 
	      (PARTITION BY Customer_name, product, quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Quantity)
		  AS RowNum FROM Orders) AS Temp
 WHERE RowNum > 1)

SELECT * FROM Orders;
