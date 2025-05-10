/*
  Created By : Suraj Kumar Sah
  Date : 18-04-2025
  Desc : Practice - 2 (Questions)
*/

-- Inserting Data into Employees Table
insert into Employees values(6, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values(7, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values(8, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values (4, 'Bob', 'Brown', 'Analyst', 50000.00);
insert into Employees values (5, 'Bob', 'Brown', 'Analyst', 50000.00);

--------------------------------------------------------------------------------------------


-- 9. Find the duplicates records (Including the main record which )

-- Using ROW_NUMBER()-it only gives the duplicate records excluding the main record.
WITH cte_DuplicateEmployees AS(
  SELECT *, ROW_NUMBER() OVER (Partition by FirstName, LastName, Position, Salary order by salary) AS RowNum,
     RANK() OVER (Partition by FirstName, LastName, Position, Salary order by salary) AS RankNum,
	 DENSE_RANK() OVER (Partition by FirstName, LastName, Position, Salary order by salary) AS DenseRank
	 from Employees
)
SELECT * FROM cte_DuplicateEmployees WHERE RowNum > 1;

-- Working (Using Count(*))
WITH cte_DuplicateEmployees AS(
  SELECT *, COUNT(*) OVER (Partition by FirstName, LastName, Position, Salary order by salary) AS DuplicateCount from Employees
)

SELECT * FROM cte_DuplicateEmployees WHERE DuplicateCount > 1;

-- Using self join (Finding the Duplicate records)
SELECT DISTINCT E1.EmployeeID, E1.FirstName, E1.LastName, E1.Position, E1.Salary FROM Employees E1
 INNER JOIN Employees E2 
 ON E1.FirstName = E2.FirstName AND
    E1.LastName = E2.LastName AND
	E1.Position = E2.Position AND
	E1.Salary = E2.Salary AND
	E1.EmployeeID <> E2.EmployeeID;
GO

-- Using Cor-related SubQuery
SELECT EmployeeID, FirstName, LastName, Position, Salary FROM Employees E1 
  WHERE EXISTS(
         SELECT TOP 1 * from Employees  
         WHERE E1.FirstName = FirstName AND
         E1.LastName = LastName AND
	     E1.Position = Position AND
	     E1.Salary = Salary AND
	     E1.EmployeeID <> EmployeeID
	);
GO
SELECT 1 FROM Employees

--------------------------------------------------------------------------------------------


-- 10. Update the Quantity column to the cumulative quantity for each customer (In Order table)

SELECT * FROM Orders;

-- Using Self JOIN
UPDATE Orders SET Quantity = Temp.CumulativeQuantity FROM orders O
 INNER JOIN
 (
   SELECT Customer_name, SUM(Quantity) OVER(PARTITION BY Customer_name ORDER BY Customer_name) CumulativeQuantity FROM Orders
 ) Temp
 ON Temp.Customer_name = O.Customer_name;


-- Using Co-related SubQuery
UPDATE O
SET Quantity = (
  SELECT SUM(Quantity) FROM Orders O2 
  WHERE O2.Customer_Name = O.Customer_Name
) FROM Orders O;

--------------------------------------------------------------------------------------------


-- 11. Fetch the specified no. of records from the specified index.

CREATE OR ALTER PROCEDURE Proc_Extract
@Index INT,
@NoOfRecords INT
AS
BEGIN
  DECLARE @OffsetValue INT

  SELECT * INTO #TempTable FROM Orders WHERE 1=0;
  
  SET @OffsetValue = (@Index-1) * @NoOfRecords

  SELECT * FROM Orders ORDER BY Order_ID OFFSET @OffsetValue ROWS FETCH NEXT @NoOfRecords ROWS ONLY

END

EXEC Proc_Extract @Index = 5, @NoOfRecords = 5

--------------------------------------------------------------------------------------------


-- 12. Copying Records from Orders table to OrderSummary table by Chunking (After inserting dummy data)

CREATE OR ALTER PROCEDURE Proc_Chunking
AS
BEGIN
  CREATE TABLE #TempTable
  (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)
  )

  DECLARE @ChunkSize INT = 100
  DECLARE @OffsetValue INT = 0

  WHILE 1 = 1
   BEGIN
    INSERT INTO #TempTable 
    SELECT * FROM Orders order by Order_ID OFFSET @OffsetValue ROWS FETCH NEXT @ChunkSize ROWS ONLY

	IF NOT EXISTS (SELECT 1 FROM #TempTable)
	  BREAK

  -- Merging the records from TempTable to OrderSummary
    MERGE OrderSummary OS
    USING #TempTable O ON OS.Order_ID= O.Order_ID

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
	    VALUES (O.Order_ID, O.Customer_Name, O.Product, O.Quantity, O.Order_Date, O.Total_Amount, O.CATEGORY);

	--WHEN NOT MATCHED BY SOURCE 
    -- THEN DELETE;

	 TRUNCATE TABLE #TempTable
	 SET @OffsetValue = @OffsetValue + @ChunkSize
  END
  --ENd of While loop

  DROP TABLE #TempTable
END

EXEC Proc_Chunking

SELECT * FROM OrderSummary
TRUNCATE TABLE OrderSummary

--------------------------------------------------------------------------------------------

