/*
  Created By : Suraj Kumar Sah
  Date : 17-04-2025
  Desc : Practice - 1 (Questions)
*/

/*
1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts);
 Total amount = total - total * discount / 100;
*/
-- Using LEFT JOIN -Checks all records
UPDATE Orders
SET Total_Amount = O.Total_Amount - (O.Total_Amount * ISNULL(D.discount_percentage, 0)/ 100)
FROM orders O
LEFT JOIN Discounts D
ON O.Product = D.Product;

-- Using RIGHT JOIN -Checks only records which have discount percentage
UPDATE Orders
SET Total_Amount = O.Total_Amount - (O.Total_Amount * D.discount_percentage / 100)
FROM orders O
RIGHT JOIN Discounts D
ON O.Product = D.Product;
GO

------------------------------------------------------------------------------

/*
 2. Delete orders placed by customers who have placed more than 5 orders.
*/

DELETE FROM orders WHERE Customer_Name IN
(SELECT Customer_Name FROM Orders GROUP BY Customer_Name HAVING  COUNT(*) > 5);

------------------------------------------------------------------------------

/*
 3. Insert records into a TopOrders table for orders exceeding a total amount of 50,000:
*/

SELECT * FROM Orders;
SELECT * INTO TopOrders FROM Orders WHERE Orders.Total_Amount > 50000
SELECT * FROM TopOrders;

------------------------------------------------------------------------------

/*
 Conditional Insert with a CASE Statement

 4. Insert into ProductSummary table where Category columns will have two type values one is 'Premium' where Total_Amount > 50000 and  'Economy' Total_Amount between 2000 and 50000
*/

CREATE PROC Proc_ProductSummary
AS
BEGIN

 SELECT Product, Total_Amount, CATEGORY INTO ProductSummary FROM Orders;

 UPDATE ProductSummary SET CATEGORY =
  CASE
    WHEN Total_Amount > 50000 THEN 'Premium'
	WHEN Total_Amount BETWEEN 2000 AND 50000 THEN 'Economy'
	ELSE 'Others'
  END
END

EXEC Proc_ProductSummary
SELECT * FROM ProductSummary;

------------------------------------------------------------------------------

/*
 5. Upsert(Update or Insert) records (from Orders table) into the OrderSummary table to update existing rows or insert new ones
 -- Using MERGE statements: Data Syncing
*/

-- Copying the Table Structure of Orders into OrderSummary
SELECT * INTO OrderSummary FROM Orders WHERE 1 = 0;

MERGE OrderSummary OS
 USING Orders O ON OS.Order_ID= O.Order_ID

WHEN MATCHED
    THEN UPDATE SET 
        OS.Order_ID = O.Order_ID,
		OS.Customer_Name = O.Customer_Name,
		OS.Product = O.Product,
		OS.Quantity = O.Quantity,
		OS.Order_Date = O.Order_Date,
		OS.Total_Amount = O.Total_Amount, 
		OS.CATEGORY = O.CATEGORY

WHEN NOT MATCHED BY TARGET
    THEN 
	    INSERT (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY) 
	    VALUES (O.Order_ID, O.Customer_Name, O.Product, O.Quantity, O.Order_Date, O.Total_Amount, O.CATEGORY)

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;


SELECT * FROM OrderSummary;
SELECT * FROM Orders

INSERT INTO OrderSummary (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY) 
VALUES (116, 'Kappa', 'Human', 2, '2025-04-16', 2000, 'Bio');

------------------------------------------------------------------------------

/*
 6. Update the category in the Orders table based on the average Toal_Amount
*/
SELECT * FROM Orders;

UPDATE ProductSummary SET CATEGORY = 'High Value' WHERE Total_Amount > (Select AVG(Total_Amount) from ProductSummary);

DECLARE @AverageTotalAmount DECIMAL(10, 6)
SET @AverageTotalAmount = (SELECT AVG(Total_Amount) FROM ProductSummary);


UPDATE ProductSummary SET CATEGORY = 
  CASE
    WHEN Total_Amount > @AverageTotalAmount THEN 'High Value'
	ELSE 'Low Value'
  END
FROM ProductSummary;
SELECT * FROM ProductSummary;

------------------------------------------------------------------------------

/* 7. MASK Account Number
Input : 2105346934
Output :  21******34
*/

CREATE FUNCTION func_MaskAccountNumber
(
  @AccountNumber VARCHAR(10)
)
 RETURNS VARCHAR(10)
 AS
 BEGIN
  DECLARE @Masked VARCHAR(10);
  --SET @Masked = LEFT(@AccountNumber, 2) + '******' + RIGHT(@AccountNumber, 2);
  SET @Masked = LEFT(@AccountNumber, 2) + REPLICATE('*', LEN(@AccountNumber)-4) + RIGHT(@AccountNumber, 2);
  RETURN @Masked
 END

PRINT dbo.func_MaskAccountNumber('2105346912')

-------------------------------------------------------------------------------------------------

/*
 8. Remove duplicate Orders where all attributes are identical
*/
-- Inserting Duplicate records
INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (113, 'Kavita', 'Headphones', 6, '2023-07-19', 12000.00, 'Electronics'),
       (114, 'Ananya', 'Shoes', 1, '2023-06-15', 55000.00, 'Electronics');


DELETE FROM Orders WHERE Order_ID IN
  (SELECT Order_ID FROM 
      (SELECT Order_ID, ROW_NUMBER() OVER 
	      (PARTITION BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Quantity)
		  AS RowNum FROM Orders)
	  AS Temp
WHERE RowNum > 1)

SELECT * FROM Orders;

------------------------------------------------------------------------------
