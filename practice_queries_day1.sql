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
VALUES (112, 'Ananya', 'Laptop', 1, '2023-06-15', 55000.00, 'Electronics');

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

SELECT * FROM Employees
SELECT * FROM Orders


--Q1)- Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)


update Orders set Total_Amount =Total_Amount * (1 - (select Discount_Percentage from Discounts where Discounts.Product = Orders.Product) / 100)
where Product IN (select Product from Discounts); 
select * from Orders
select * from Discounts
select * from Employees

select o.*,o.total_amount*(100-ISNULL(d.Discount_Percentage,0))/100 
as 
updatedAmount from Orders o left join Discounts d on o.product = d.Product	;


SELECT 
	o.*,
    COALESCE(o.Total_Amount * (1 - d.Discount_Percentage / 100), o.Total_Amount) AS Updated_Total_Amount
FROM Orders o
LEFT JOIN Discounts d ON o.Product = d.Product;

-- Q2)-Delete orders placed by customers who have placed more than 5 orders:

SELECT * FROM ORDERS WHERE Customer_Name 
IN 
(select Customer_Name from orders group by Customer_Name having count(order_id) > 5)

delete from orders where Customer_Name 
in 
(select Customer_Name from orders group by Customer_Name having count(order_id)>5)


-- Q3). Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:
CREATE TABLE TopOrders (
	Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
)

		INSERT INTO TopOrders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
		SELECT Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY
		FROM Orders
		WHERE Total_Amount > 50000;
		select * from TopOrders

--Q4) -4.--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 500
-- and  where EconomyTotal_Amount between 2000 and 50000

	CREATE table productSummary (
	Category varchar(10),
    Product NVARCHAR(50),
    Quantity INT,
    Total_Amount DECIMAL(10, 2),
)

	INSERT INTO productSummary (Category, Product, Quantity, Total_Amount)
	SELECT 
    CASE 
        WHEN Total_Amount > 50000 THEN 'Premium'
        WHEN Total_Amount BETWEEN 20000 AND 50000 THEN 'Economy'
        ELSE 'Other' 
	END, 
    Product, 
    Quantity, 
    Total_Amount
	FROM Orders;

SELECT * FROM productSummary

DELETE FROM productSummary

-- SECOND METHOD USING "SELECT INTO" SYNTAX
	select Product,Total_Amount,
	CASE
		WHEN Total_Amount > 50000 THEN 'Premium'
        WHEN Total_Amount BETWEEN 2000 AND 50000 THEN 'Economy'
        ELSE 'Other'
	END PRODUCT_TYPE
 into productSummary from orders
 DROP TABLE productSummary

 --Q5)- UPSERT RECORDS INTO THE ORDERSUMMARY TABLE TO UPDATE EXISTING ROWS OR INSERT NEW ONES
-- UPSERT MEANS UPDDTE OR INSERT - IF DATA IS PRESENT THEN UPDATE AND IF NOT INSERT THE DATA


CREATE TABLE ORDERSUMMARY (
	Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
)



MERGE ORDERSUMMARY AS TARGET
USING ORDERS AS SOURCE
ON TARGET.order_id = SOURCE.order_id  
WHEN MATCHED THEN
    UPDATE SET
        TARGET.Customer_Name = SOURCE.Customer_Name,
        TARGET.Product = SOURCE.Product,
        TARGET.Quantity = SOURCE.Quantity,
        TARGET.Order_Date = SOURCE.Order_Date,
        TARGET.Total_Amount = SOURCE.Total_Amount,
        TARGET.CATEGORY = SOURCE.CATEGORY
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        Order_ID,
        Customer_Name,
        Product,
        Quantity,
        Order_Date,
        Total_Amount,
        CATEGORY
    ) VALUES (
        SOURCE.Order_ID,
        SOURCE.Customer_Name,
        SOURCE.Product,
        SOURCE.Quantity,
        SOURCE.Order_Date,
        SOURCE.Total_Amount,
        SOURCE.CATEGORY
    );

	select * from ORDERSUMMARY

--q6)- update the category nt the orders table based on the average total amoiund
-- if total amount > avg value then "high"
-- else "low"

ALTER TABLE Orders
ADD newcategory VARCHAR(20);

DECLARE @average DECIMAL(10, 2); 
SELECT @average = AVG(Total_Amount) FROM Orders; 

update Orders
set newcategory = 
    CASE
        WHEN Total_Amount > @average THEN 'High value'
        ELSE 'Low value'
    END;

select * from Orders


--Q7) - 

CREATE FUNCTION MaskAccountNumber2 (  
    @accountNumber VARCHAR(255)
)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @length INT;
    DECLARE @maskedNumber VARCHAR(255);
    DECLARE @i INT;

    SET @length = LEN(@accountNumber);

    
            SET @maskedNumber = LEFT(@accountNumber, 2);
            SET @i = 1;  
            WHILE @i <= 4  
            BEGIN
                SET @maskedNumber = @maskedNumber + '*';
                SET @i = @i + 1;
            END;
            SET @maskedNumber = @maskedNumber + RIGHT(@accountNumber, 2);

    RETURN @maskedNumber;
END;
GO
	
DECLARE @accountNumber VARCHAR(10) = '124323464';
DECLARE @maskedAccountNumber VARCHAR(255);  
SET @maskedAccountNumber = dbo.MaskAccountNumber2(@accountNumber);
PRINT @maskedAccountNumber;
GO

--Q8)-.8.Remove duplicate orders where all attributes are identical:
/*
	DUPLICATE DATA -removal using rank by partition
*/
SELECT CUSTOMER_NAME FROM ORDERS GROUP BY Customer_Name,Order_ID HAVING COUNT(*)>1


SELECT *, RANK() OVER
(PARTITION BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Order_ID) 
as rank_num 
FROM Orders order by rank_num desc

DELETE FROM Orders
WHERE Order_ID IN (
    SELECT Order_ID
    FROM (
        SELECT 
            Order_ID,
            RANK() OVER (PARTITION BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Order_ID) as rank_num
        FROM Orders
    ) as RankedOrders
    WHERE rank_num > 1
);

SELECT * from Orders;
