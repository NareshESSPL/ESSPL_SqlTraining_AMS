select*from Orders

select*from Discounts

-- 1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)
update O
set O.Total_Amount = O.Total_Amount -  O.Total_Amount*(isNull( D.Discount_Percentage,0)/100)
from Orders as O left join Discounts as D on O.Product = D.Product 



-- 2. Delete orders placed by customers who have placed more than 5 orders:
delete from Orders where  Customer_Name in
(select O.Customer_Name from Orders as O group by  O.Customer_Name having  sum(Quantity) > 0)


SELECT * FROM Orders;


-- 3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:
SELECT * INTO TopOrders FROM Orders WHERE Orders. Total_Amount > 50000

SELECT * FROM TopOrders;


--4.Conditional Insert with a CASE Statement
--insert into ProductSummary table where Category columns
--will have two type values one is 'Premium' where Total_Amount > 500
-- and  where EconomyTotal_Amount between 2000 and 50000
alter table Orders 
add  Quality varchar(250)

SELECT 
    Product,
    SUM(Total_Amount) AS Sum_Ammounnt,
    CASE 
        WHEN SUM(Total_Amount) > 50000 THEN 'Premium'
        WHEN SUM(Total_Amount) BETWEEN 2000 AND 50000 THEN 'Economy'
        ELSE 'Standard'
    END AS Category
INTO ProductSummary
FROM Orders
GROUP BY Product;

select*from ProductSummary



-- 5. Upsert records into the ordersSummary table to update existing rows or insert new one
MERGE INTO ProductSummary AS target
USING (
    SELECT Product, SUM(Total_Amount) AS TotalAmount
    FROM Orders
    GROUP BY Product
) AS source
ON target.Product = source.Product
WHEN MATCHED THEN 
    UPDATE SET 
        target.Sum_Ammounnt = source.TotalAmount,
        target.Category = CASE 
            WHEN source.TotalAmount > 50000 THEN 'Premium'
            WHEN source.TotalAmount BETWEEN 2000 AND 50000 THEN 'Economy'
            ELSE 'Standard'
        END

WHEN NOT MATCHED THEN
    INSERT (Product, Sum_Ammounnt, Category)
    VALUES (
        source.Product,
        source.TotalAmount,
        CASE 
            WHEN source.TotalAmount > 50000 THEN 'Premium'
            WHEN source.TotalAmount BETWEEN 2000 AND 50000 THEN 'Economy'
            ELSE 'Standard'
        END
    );


-- 6. Update the category in the orders table based on the average total_Amount

Select * from Orders
Declare @Avg_Amount 
set @Avg_Amount = (select avg(Total_Amount) from Orders)

update Orders 
set CATEGORY = case 
               when Total_Amount > @Avg_Amount then 'High Value'
               else 'Low Value'
			End;




-- 7. Masked
-- 1098798899898
-- 10*********98
create FUNCTION dbo.func_masked_number
(
    @input VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @maskedN VARCHAR(50)
    DECLARE @len INT = LEN(@input)

    SET @maskedN = LEFT(@input, 2) + REPLICATE('*', @len - 4) + RIGHT(@input, 2)

    RETURN @maskedN
END

SELECT dbo.func_masked_number('1098798899898') AS masked_output


-- 8.Remove duplicate orders where all attributes are identical:

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY)
VALUES (113, 'Jai', 'Headphones', 2, '2023-07-18', 4000.00, 'Electronics');

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY
               ORDER BY Order_ID
           ) AS rn
    FROM Orders
)
DELETE FROM CTE WHERE rn > 1;

select * from Orders


