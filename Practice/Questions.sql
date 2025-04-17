--use Practice
--go

select * from Orders
select * from Employees

--1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
--UPDATE Orders
--SET Total_Amount = Total_Amount - (Total_Amount * d.Discount_Percentage / 100)
--FROM Orders o
--INNER JOIN Discounts d
--ON o.Product = d.Product
--WHERE o.CATEGORY = 'Electronics';

--2. Delete orders placed by customers who have placed more than 5 orders:
--DELETE FROM Orders
--WHERE Customer_Name IN (
--    SELECT Customer_Name
--    FROM Orders
--    GROUP BY Customer_Name
--    HAVING COUNT(Order_ID) > 5
--);

--3.Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:
--INSERT INTO TopOrders (Order_ID, Customer_Name, Product, Total_Amount)
--SELECT Order_ID, Customer_Name, Product, Total_Amount
--FROM Orders
--WHERE Total_Amount > 50000;

--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 500
-- and 'Economy' where EconomyTotal_Amount between 2000 and 50000
--INSERT INTO ProductSummary (Product, Total_Amount, Category)
--SELECT Product, Total_Amount,
--    CASE 
--        WHEN Total_Amount > 50000 THEN 'Premium'
--        WHEN Total_Amount BETWEEN 20000 AND 50000 THEN 'Standard'
--        ELSE 'Economy'
--    END
--FROM Orders;


--5.Upsert records into the OrderSummary table to update existing rows or insert new ones:
--MERGE INTO OrderSummary AS target
--USING Orders AS source
--ON target.Order_ID = source.Order_ID
--WHEN MATCHED THEN
--    UPDATE SET Total_Amount = source.Total_Amount, Quantity = source.Quantity
--WHEN NOT MATCHED THEN
--    INSERT (Order_ID, Customer_Name, Product, Quantity, Total_Amount)
--    VALUES (source.Order_ID, source.Customer_Name, source.Product, source.Quantity, source.Total_Amount);

--6.Update the CATEGORY in the Orders table based on the average Total_Amount
--UPDATE Orders
--SET CATEGORY = 'High Value'
--WHERE Total_Amount > (
--    SELECT AVG(Total_Amount)
--    FROM Orders
--);

--7.Insert the total number of orders per customer into a CustomerSummary table:
--INSERT INTO CustomerSummary (Customer_Name, OrderCount)
--SELECT Customer_Name, COUNT(Order_ID)
--FROM Orders
--GROUP BY Customer_Name;

--8.Remove duplicate orders where all attributes are identical:
--WITH CTE AS (
--    SELECT *, ROW_NUMBER() OVER (PARTITION BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Order_ID) AS rn
--    FROM Orders
--)
--DELETE FROM Orders
--WHERE Order_ID IN (
--    SELECT Order_ID
--    FROM CTE
--    WHERE rn > 1
--);

--9.Update the Quantity column to the cumulative quantity for each customer:
--UPDATE Orders
--SET Quantity = t.CumulativeQuantity
--FROM (
--    SELECT Order_ID, SUM(Quantity) OVER (PARTITION BY Customer_Name ORDER BY Order_Date) AS CumulativeQuantity
--    FROM Orders
--) t
--WHERE Orders.Order_ID = t.Order_ID;

--10.Insert aggregated data into a CategorySummary table:
--INSERT INTO CategorySummary (CATEGORY, TotalOrders, TotalAmount)
--SELECT CATEGORY, COUNT(Order_ID) AS TotalOrders, SUM(Total_Amount) AS TotalAmount
--FROM Orders
--GROUP BY CATEGORY;

--11.Update the CATEGORY of orders based on the average Total_Amount for each product:
--UPDATE Orders
--SET CATEGORY = 
--    CASE 
--        WHEN Total_Amount > (SELECT AVG(Total_Amount) FROM Orders WHERE Product = Orders.Product) THEN 'Premium'
--        ELSE 'Standard'
--    END;

--12.Delete duplicate rows based on all columns using a Common Table Expression (CTE):
--WITH CTE AS (
--    SELECT Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY, 
--           ROW_NUMBER() OVER (PARTITION BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY ORDER BY Order_ID) AS rn
--    FROM Orders
--)
--DELETE FROM Orders
--WHERE Order_ID IN (SELECT Order_ID FROM CTE WHERE rn > 1);

--13.Insert records into a HighValueOrders table for orders above ₹50,000, with conditional columns:
--INSERT INTO HighValueOrders (Order_ID, Customer_Name, Product, Total_Amount, Premium)
--SELECT Order_ID, Customer_Name, Product, Total_Amount, 
--       CASE 
--           WHEN Total_Amount > 100000 THEN 'VIP'
--           ELSE 'Standard'
--       END
--FROM Orders
--WHERE Total_Amount > 50000;

--14.Upsert records into a CustomerOrders table based on the existing or new orders:
--MERGE INTO CustomerOrders AS target
--USING Orders AS source
--ON target.Order_ID = source.Order_ID
--WHEN MATCHED THEN
--    UPDATE SET Quantity = source.Quantity, Total_Amount = source.Total_Amount
--WHEN NOT MATCHED THEN
--    INSERT (Order_ID, Customer_Name, Product, Quantity, Total_Amount)
--    VALUES (source.Order_ID, source.Customer_Name, source.Product, source.Quantity, source.Total_Amount);

--15.Update both CATEGORY and Quantity based on conditions:
--UPDATE Orders
--SET CATEGORY = 
--    CASE 
--        WHEN Total_Amount > 50000 THEN 'Premium'
--        WHEN Total_Amount > 20000 THEN 'Mid-Range'
--        ELSE 'Economy'
--    END,
--    Quantity = 
--    CASE 
--        WHEN Total_Amount > 50000 THEN Quantity + 1
--        ELSE Quantity
--    END;

--16.Delete all orders where the Quantity exceeds the average quantity of their category:
--DELETE FROM Orders
--WHERE Quantity > (
--    SELECT AVG(Quantity) 
--    FROM Orders o 
--    WHERE o.CATEGORY = Orders.CATEGORY
--);

--17.Insert aggregated order information into a CustomerSummary table:
--INSERT INTO CustomerSummary (Customer_Name, TotalOrders, TotalAmount)
--SELECT Customer_Name, COUNT(Order_ID) AS TotalOrders, SUM(Total_Amount) AS TotalAmount
--FROM Orders
--GROUP BY Customer_Name;

--18.Update Total_Amount in Orders by applying a discount from the Discounts table:
--UPDATE Orders
--SET Total_Amount = Total_Amount - (Total_Amount * d.Discount_Percentage / 100)
--FROM Orders o
--JOIN Discounts d
--ON o.Product = d.Product
--WHERE o.CATEGORY = 'Electronics';

--19.Delete orders that match specific criteria, such as a specific product and date:
--DELETE FROM Orders
--WHERE Product = 'Headphones' AND Order_Date BETWEEN '2023-06-15' AND '2023-07-15';

--20.Insert summary information for high-value products into a ProductSummary table:
--INSERT INTO ProductSummary (Product, TotalQuantity, TotalRevenue, Category)
--SELECT Product, SUM(Quantity) AS TotalQuantity, SUM(Total_Amount) AS TotalRevenue, 
--       CASE 
--           WHEN SUM(Total_Amount) > 100000 THEN 'Premium'
--           ELSE 'Standard'
--       END
--FROM Orders
--GROUP BY Product;








