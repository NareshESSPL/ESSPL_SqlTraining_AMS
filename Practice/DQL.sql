--1.Retrieve all customers and their respective orders:
--SELECT Customers.Customer_Name, Orders.Product, Orders.Quantity, Orders.Total_Amount
--FROM Customers
--JOIN Orders ON Customers.Customer_Name = Orders.Customer_Name;


--2.Calculate the total amount spent by each customer:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent
--FROM Orders
--GROUP BY Customer_Name;

--3.Fetch all orders placed between '2023-06-15' and '2023-07-01':
--SELECT * 
--FROM Orders
--WHERE Order_Date BETWEEN '2023-06-15' AND '2023-07-01';

--4.Retrieve customers who ordered "Headphones":
--SELECT DISTINCT Customer_Name 
--FROM Orders
--WHERE Product = 'Headphones';

--5.Find the top 3 customers based on total spending:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent
--FROM Orders
--GROUP BY Customer_Name
--ORDER BY TotalSpent DESC
--LIMIT 3;

--6.Get the total orders and quantity for each category:
--SELECT CATEGORY, COUNT(Order_ID) AS TotalOrders, SUM(Quantity) AS TotalQuantity
--FROM Orders
--GROUP BY CATEGORY;

--7.Retrieve customers whose total spending exceeds ₹50,000:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent
--FROM Orders
--GROUP BY Customer_Name
--HAVING SUM(Total_Amount) > 50000;

--8.Identify products that have been ordered more than 5 times:
--SELECT Product, COUNT(Order_ID) AS TotalOrders
--FROM Orders
--GROUP BY Product
--HAVING COUNT(Order_ID) > 5;

--9.List all orders that do not have a matching customer (if there's a potential mismatch):
--SELECT Orders.*
--FROM Orders
--LEFT JOIN Customers ON Orders.Customer_Name = Customers.Customer_Name
--WHERE Customers.Customer_Name IS NULL;

--10.Calculate the total revenue generated for each month:
--SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Total_Amount) AS MonthlyRevenue
--FROM Orders
--GROUP BY YEAR(Order_Date), MONTH(Order_Date)
--ORDER BY Year, Month;


--11. Retrieve the customer who placed the most expensive order:
--SELECT Customer_Name, Total_Amount 
--FROM Orders 
--WHERE Total_Amount = (SELECT MAX(Total_Amount) FROM Orders);


--12.Find the total revenue and the average revenue for each category:
--SELECT CATEGORY, SUM(Total_Amount) AS TotalRevenue, AVG(Total_Amount) AS AverageRevenue
--FROM Orders
--GROUP BY CATEGORY;

--13.Retrieve categories that have generated more than ₹50,000 in total revenue:
--SELECT CATEGORY, SUM(Total_Amount) AS TotalRevenue
--FROM Orders
--GROUP BY CATEGORY
--HAVING SUM(Total_Amount) > 50000;

--14.Get the customers whose total spending is above the average spending across all customers:
--SELECT DISTINCT Customer_Name 
--FROM Orders 
--WHERE (SELECT SUM(Total_Amount) FROM Orders WHERE Customer_Name = Orders.Customer_Name) > 
--      (SELECT AVG(Total_Amount) FROM Orders);

--15.(Window Functions) Rank products based on their total quantity sold, sorted by category:
--SELECT Product, CATEGORY, SUM(Quantity) AS TotalQuantity,
--       RANK() OVER (PARTITION BY CATEGORY ORDER BY SUM(Quantity) DESC) AS Rank
--FROM Orders
--GROUP BY Product, CATEGORY;

--16.Identify customers who ordered the same product multiple times:
--SELECT Customer_Name, Product, COUNT(Order_ID) AS OrderCount
--FROM Orders
--GROUP BY Customer_Name, Product
--HAVING COUNT(Order_ID) > 1;

--17.Find customers who have placed more than one order for the same category on different dates:
--SELECT o1.Customer_Name, o1.CATEGORY, o1.Order_Date, o2.Order_Date
--FROM Orders o1
--JOIN Orders o2 
--ON o1.Customer_Name = o2.Customer_Name AND o1.CATEGORY = o2.CATEGORY AND o1.Order_Date <> o2.Order_Date;

--18.Get products that have been purchased by at least two different customers:
--SELECT DISTINCT Product 
--FROM Orders o1
--WHERE EXISTS (
--    SELECT 1 
--    FROM Orders o2
--    WHERE o1.Product = o2.Product AND o1.Customer_Name <> o2.Customer_Name
--);

--19.Find customers and their total orders and total spending, sorted by spending:
--SELECT o.Customer_Name, COUNT(o.Order_ID) AS TotalOrders, SUM(o.Total_Amount) AS TotalSpent
--FROM Orders o
--GROUP BY o.Customer_Name
--ORDER BY TotalSpent DESC;

--20. Get the total quantity sold for each product in each category:
--SELECT CATEGORY, Product, SUM(Quantity) AS TotalQuantity
--FROM Orders
--GROUP BY CATEGORY, Product
--ORDER BY CATEGORY, TotalQuantity DESC;

--21.Find Customers with Multiple Orders Across Categories
--SELECT Customer_Name, COUNT(DISTINCT CATEGORY) AS CategoryCount
--FROM Orders
--GROUP BY Customer_Name
--HAVING COUNT(DISTINCT CATEGORY) > 1;

--22.Find the top revenue-generating product in each category:
--WITH ProductRevenue AS (
--    SELECT CATEGORY, Product, SUM(Total_Amount) AS TotalRevenue
--    FROM Orders
--    GROUP BY CATEGORY, Product
--)
--SELECT CATEGORY, Product, TotalRevenue
--FROM ProductRevenue
--WHERE (CATEGORY, TotalRevenue) IN (
--    SELECT CATEGORY, MAX(TotalRevenue)
--    FROM ProductRevenue
--    GROUP BY CATEGORY
--);

--23.Retrieve the last order placed by each customer:
--SELECT o1.Customer_Name, o1.Product, o1.Order_Date, o1.Total_Amount
--FROM Orders o1
--WHERE o1.Order_Date = (
--    SELECT MAX(o2.Order_Date)
--    FROM Orders o2
--    WHERE o2.Customer_Name = o1.Customer_Name
--);

--24.Find orders where the total amount exceeds the average revenue of the corresponding category:
--SELECT Order_ID, Customer_Name, Product, CATEGORY, Total_Amount
--FROM Orders
--WHERE Total_Amount > (
--    SELECT AVG(Total_Amount)
--    FROM Orders o2
--    WHERE o2.CATEGORY = Orders.CATEGORY
--);

--25.Rank customers based on their total spending across all orders:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent,
--       RANK() OVER (ORDER BY SUM(Total_Amount) DESC) AS SpendingRank
--FROM Orders
--GROUP BY Customer_Name;

--26.Find all orders for a specific customer (Ananya) where the order is either in the "Electronics" category or the quantity is more than 3:
--SELECT *
--FROM Orders
--WHERE Customer_Name = 'Ananya' AND (CATEGORY = 'Electronics' OR Quantity > 3);


--27.Calculate the revenue contribution of each customer as a percentage of the total revenue:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent,
--       (SUM(Total_Amount) * 100.0 / (SELECT SUM(Total_Amount) FROM Orders)) AS RevenuePercentage
--FROM Orders
--GROUP BY Customer_Name;

--28.Identify gaps (In Days) between consecutive orders for each customer:
--WITH OrderGaps AS (
--    SELECT Customer_Name, Order_Date, 
--           LAG(Order_Date) OVER (PARTITION BY Customer_Name ORDER BY Order_Date) AS PreviousDate
--    FROM Orders
--)
--SELECT Customer_Name, Order_Date, PreviousDate, 
--       DATEDIFF(DAY, PreviousDate, Order_Date) AS GapDays
--FROM OrderGaps
--WHERE PreviousDate IS NOT NULL;

--29.Find the category with the highest average spending per order:
--SELECT CATEGORY, AVG(Total_Amount) AS AvgSpending
--FROM Orders
--GROUP BY CATEGORY
--ORDER BY AvgSpending DESC
--LIMIT 1;

--30.List customers whose specific orders exceed their average order spending:
--SELECT o.Customer_Name, o.Order_ID, o.Total_Amount, AvgSpending.AverageSpent
--FROM Orders o
--JOIN (
--    SELECT Customer_Name, AVG(Total_Amount) AS AverageSpent
--    FROM Orders
--    GROUP BY Customer_Name
--) AvgSpending
--ON o.Customer_Name = AvgSpending.Customer_Name
--WHERE o.Total_Amount > AvgSpending.AverageSpent;

--31. Retrieve the top 3 customers based on the number of orders they have placed:
--SELECT Customer_Name, COUNT(Order_ID) AS TotalOrders
--FROM Orders
--GROUP BY Customer_Name
--ORDER BY TotalOrders DESC
--LIMIT 3;

--32.Fetch categories that generate the most revenue:
--SELECT CATEGORY, SUM(Total_Amount) AS TotalRevenue
--FROM Orders
--GROUP BY CATEGORY
--ORDER BY TotalRevenue DESC;

--33.List customers who spent more than ₹50,000 in multiple categories:
--SELECT Customer_Name, CATEGORY, SUM(Total_Amount) AS TotalSpent
--FROM Orders
--GROUP BY Customer_Name, CATEGORY
--HAVING SUM(Total_Amount) > 50000;

--34.Fetch products ordered more than 5 times by different customers:	
--SELECT Product, COUNT(Order_ID) AS TotalOrders
--FROM Orders
--GROUP BY Product
--HAVING COUNT(Order_ID) > 5;

--35.Retrieve customers who placed orders on consecutive dates:
--WITH ConsecutiveOrders AS (
--    SELECT Customer_Name, Order_Date,
--           LAG(Order_Date) OVER (PARTITION BY Customer_Name ORDER BY Order_Date) AS PreviousOrderDate
--    FROM Orders
--)
--SELECT Customer_Name, Order_Date, PreviousOrderDate
--FROM ConsecutiveOrders
--WHERE DATEDIFF(DAY, PreviousOrderDate, Order_Date) = 1;

--36.Retrieve customers who placed at least one order in every category:
--SELECT Customer_Name
--FROM Orders
--GROUP BY Customer_Name
--HAVING COUNT(DISTINCT CATEGORY) = (SELECT COUNT(DISTINCT CATEGORY) FROM Orders);

--37.Calculate the average amount spent for each product:
--SELECT Product, AVG(Total_Amount) AS AverageSpent
--FROM Orders
--GROUP BY Product;

--38.Retrieve the top product by revenue for each category:
--SELECT CATEGORY, Product, SUM(Total_Amount) AS Revenue
--FROM Orders
--GROUP BY CATEGORY, Product
--ORDER BY CATEGORY, Revenue DESC;

--39.List customers whose orders exceed their average spending:
--SELECT o.Customer_Name, o.Order_ID, o.Total_Amount, AvgSpent.AverageAmount
--FROM Orders o
--JOIN (
--    SELECT Customer_Name, AVG(Total_Amount) AS AverageAmount
--    FROM Orders
--    GROUP BY Customer_Name
--) AvgSpent
--ON o.Customer_Name = AvgSpent.Customer_Name
--WHERE o.Total_Amount > AvgSpent.AverageAmount;

--40.Find customers who placed the highest-value single order:
--SELECT Customer_Name, MAX(Total_Amount) AS LargestOrder
--FROM Orders
--GROUP BY Customer_Name;

--41.Calculate the total revenue generated each month:
--SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Total_Amount) AS MonthlyRevenue
--FROM Orders
--GROUP BY YEAR(Order_Date), MONTH(Order_Date)
--ORDER BY Year, Month;

--42.Retrieve customers and details of their last purchase:
--SELECT o.Customer_Name, o.Product, o.Order_Date, o.Total_Amount
--FROM Orders o
--WHERE o.Order_Date = (
--    SELECT MAX(Order_Date) FROM Orders WHERE Customer_Name = o.Customer_Name
--);

--43.Find the revenue share contributed by each customer:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent,
--       (SUM(Total_Amount) * 100.0 / (SELECT SUM(Total_Amount) FROM Orders)) AS RevenuePercentage
--FROM Orders
--GROUP BY Customer_Name;

--44.Find all products ordered by more than one customer:
--SELECT DISTINCT Product
--FROM Orders o1
--WHERE EXISTS (
--    SELECT 1 FROM Orders o2
--    WHERE o1.Product = o2.Product AND o1.Customer_Name <> o2.Customer_Name
--);

--45.Retrieve orders where the total amount is above the average revenue for the category:
--SELECT Order_ID, Customer_Name, Product, CATEGORY, Total_Amount
--FROM Orders
--WHERE Total_Amount > (
--    SELECT AVG(Total_Amount) FROM Orders WHERE CATEGORY = Orders.CATEGORY
--);

--46.Rank customers based on their total spending:
--SELECT Customer_Name, SUM(Total_Amount) AS TotalSpent,
--       RANK() OVER (ORDER BY SUM(Total_Amount) DESC) AS SpendingRank
--FROM Orders
--GROUP BY Customer_Name;

--47.Find the total revenue generated for each product across all categories:
--SELECT Product, CATEGORY, SUM(Total_Amount) AS Revenue
--FROM Orders
--GROUP BY Product, CATEGORY;

--48.Identify customers who placed multiple orders within a single month:
--SELECT Customer_Name, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, COUNT(Order_ID) AS OrderCount
--FROM Orders
--GROUP BY Customer_Name, YEAR(Order_Date), MONTH(Order_Date)
--HAVING COUNT(Order_ID) > 2;

--49.Calculate the percentage revenue contribution of each category:
--SELECT CATEGORY, SUM(Total_Amount) AS TotalRevenue,
--       (SUM(Total_Amount) * 100.0 / (SELECT SUM(Total_Amount) FROM Orders)) AS RevenueShare
--FROM Orders
--GROUP BY CATEGORY;

--50.Find the top customer for each month based on revenue:
--WITH MonthlyRevenue AS (
--    SELECT Customer_Name, YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Total_Amount) AS TotalRevenue
--    FROM Orders
--    GROUP BY Customer_Name, YEAR(Order_Date), MONTH(Order_Date)
--)
--SELECT Year, Month, Customer_Name, TotalRevenue
--FROM MonthlyRevenue
--WHERE (Year, Month, TotalRevenue) IN (
--    SELECT Year, Month, MAX(TotalRevenue)
--    FROM MonthlyRevenue
--    GROUP BY Year, Month
--);

























