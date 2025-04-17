use Practice
--Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
select d.Discount_Percentage,o.Customer_Name,o.Product,o.Total_Amount,
o.Total_Amount*(100- ISNULL(d.Discount_Percentage,0))/100 AS reducedAmount 
from Discounts d left join Orders o on d.Product = o.Product
-- Delete orders placed by customers who have placed more than 5 orders:
Delete from Orders where Customer_Name in (
select Customer_Name from Orders group by Customer_Name having sum(Quantity) > 5 )

select * from Orders
go

--insert records into topOrders table for orders exceeding a totalAmount of 50000
CREATE TABLE TopOrders (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);
insert into TopOrders(Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
select Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY from Orders where Total_Amount > 50000;

select * from TopOrders

--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 50000
-- and 'Economy'  where EconomyTotal_Amount between 2000 and 50000

CREATE TABLE ProductSummary (
    CATEGORY NVARCHAR(50),
	Total_Amount DECIMAL(10, 2),
	Product NVARCHAR(50),
);

insert into ProductSummary(Product,CATEGORY,Total_Amount)
select Product,
CASE 
when Total_Amount >  50000 then 'Premium'
when Total_Amount between 2000 and 50000 then 'Economy'
else 'basic'
end AS CATEGORY,
Total_Amount
from Orders;
go
select * from ProductSummary
go

--upsert records into the orderSummary tavle from OrderTable to update existing rows or insert new ones

CREATE TABLE OrderSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
);

MERGE INTO OrderSummary AS Target
Using Orders as Source
ON Target.Order_ID = Source.Order_ID

when matched then update set
Target.Customer_Name = Source.Customer_Name,
       Target.Product = Source.Product,
        Target.Quantity = Source.Quantity,
        Target.Order_Date = Source.Order_Date,
        Target.Total_Amount = Source.Total_Amount,
		Target.CATEGORY = Source.CATEGORY

when not matched by Target then
INSERT (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (Source.Order_ID, Source.Customer_Name, Source.Product, Source.Quantity, Source.Order_Date, Source.Total_Amount, Source.CATEGORY);
select * from OrderSummary
go
--if total amount > avg(totalAmount) 'High Value'
UPDATE OrderSummary
SET CATEGORY = 'High Value'
WHERE Total_Amount > (SELECT AVG(Total_Amount) FROM Orders);
select * from OrderSummary
go
UPDate OrderSummary
set CATEGORY = 
CASE
when Total_Amount > (SELECT AVG(Total_Amount) FROM Orders)
then 'High Value'
else CATEGORY
end
go

--write a function to mask my account number
CREATE FUNCTION MaskAccountNumber (@AccountNumber VARCHAR(20))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Length INT;
    DECLARE @MaskedAccountNumber VARCHAR(20);

    SET @Length = LEN(@AccountNumber);

    IF @Length <= 4
        SET @MaskedAccountNumber = @AccountNumber;
    ELSE
        SET @MaskedAccountNumber =
            LEFT(@AccountNumber, 2) +
            REPLICATE('*', @Length - 4) +
            RIGHT(@AccountNumber, 2);

    RETURN @MaskedAccountNumber;
END;
GO


DECLARE @AccountNumber VARCHAR(20) = '1234567899';
PRINT 'Original Account Number: ' + @AccountNumber;
PRINT 'Masked Account Number: ' + dbo.MaskAccountNumber(@AccountNumber);
DECLARE @AccountNumber VARCHAR(20) = '123';
PRINT 'Original Account Number: ' + @AccountNumber;
PRINT 'Masked Account Number: ' + dbo.MaskAccountNumber(@AccountNumber);
Go
--.Remove duplicate orders where all attributes are identical:

DELETE FROM Employees
WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM (
        SELECT
            EmployeeID,
            ROW_NUMBER() OVER (PARTITION BY FirstName, Salary ORDER BY EmployeeID) AS RowNum
        FROM
            Employees
    ) AS RowNumCTE
    WHERE RowNum > 1
);