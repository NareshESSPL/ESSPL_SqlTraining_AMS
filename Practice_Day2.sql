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

insert into Employees values(5, 'John', 'Doe', 'Manager', '75000.00')
 insert into Employees values(6, 'John', 'Doe', 'Manager', '75000.00')
 insert into Employees values(7, 'John', 'Doe', 'Manager', '75000.00')


WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY  FirstName, LastName, Position, Salary ORDER BY FirstName ) AS row_num,
		   rank() OVER (PARTITION BY  FirstName, LastName, Position, Salary ORDER BY FirstName ) AS erank
    FROM Employees
)
 
SELECT *  
FROM CTE
---WHERE row_num > 1;


select
*,
count(*) over (PARTITION BY  FirstName, LastName, Position, Salary ORDER BY FirstName ) CountForGroup
FROM Employees



---------------join-----------find employee id with duplicate records  using 3 different ways------------
SELECT 
    E1.EmployeeID AS Employee1_ID,
    E1.FirstName AS Employee1_Name,
    E2.EmployeeID AS Employee2_ID,
    E2.FirstName AS Employee2_Name
FROM 
    Employees E1
right JOIN 
    Employees E2
ON 
    E1.EmployeeID = E2.EmployeeID and
	 E1.FirstName = E2.FirstName and
	 E1.LastName = E2.LastName;
	--- E1.Salary = E2.Salary;

---------without using join---------------------------------
SELECT * 
FROM Employees E1
WHERE EXISTS (
    SELECT TOP 1 * 
    FROM Employees E2
    WHERE E1.EmployeeID != E2.EmployeeID
);




DELETE FROM Employees
WHERE EmployeeID NOT IN (
    SELECT MIN(EmployeeID)
    FROM Employees
    GROUP BY FirstName, LastName, Position, Salary
);
select * from orders

-----------update the quantity column to the cumulative quantity for each customer------------------------------

UPDATE Orders
SET Quantity = Cumulative.CumulativeQuantity
FROM Orders
INNER JOIN (SELECT 
    Customer_Name, 
    sum(Quantity) OVER (PARTITION BY Customer_Name ORDER BY Customer_Name) AS CumulativeQuantity
FROM Orders) as Cumulative
ON Orders.Customer_Name = Cumulative.Customer_Name;
select * from orders

---------------------------temp table ue on order and order summary-------------------------------
---------PAGINATION TOPIC-------
--Question:- suppose their are 14  name of students so by using pagignation u have to do grp of 3 

USE [Practice]
 go
-----temp table-------------- 
 CREATE OR ALTER proc CreateDummyrecordsForOrder
  @MaxCount BIGINT =1000
 as
 begin
   truncate table Orders
   
 
   declare 
     @Order_ID int,
 	@Customer_Name nvarchar(50) ,
 	@Product nvarchar(50) ,
 	@Quantity int ,
 	@Order_Date date ,
 	@Total_Amount decimal(10, 2) ,
 	@CATEGORY nvarchar(50) 
 
   declare @count int = 0;
 
   set @Order_Date = '1990-01-01'
   
   WHILE @count < = @MaxCount
   BEGIN
   --Do not delete
   select @count = @count + 1
 
   set @Order_ID = @count
   set @Customer_Name = 'TestName' + cast(@count as varchar)
   set @Product = 'Product' + cast(@count as varchar)
   set @Quantity = 2
   set @Order_Date = dateadd(day, -1, @Order_Date)
   set @Total_Amount = 1000
   set @CATEGORY = 'A'
 
   INSERT INTO [dbo].[Orders]
            ([Order_ID]
            ,[Customer_Name]
            ,[Product]
            ,[Quantity]
            ,[Order_Date]
            ,[Total_Amount]
            ,[CATEGORY])
      VALUES
            (@Order_ID
            ,@Customer_Name
            ,@Product
            ,@Quantity
            ,@Order_Date
            ,@Total_Amount
            ,@CATEGORY)
 
 end
 END
 -----------------------SP----------------------------------------
ALTER PROCEDURE Orders_Pagination
    @index INT,         
    @Noofrows INT        
AS
BEGIN
   
    DECLARE @Offset INT;
    SET @Offset = (@index - 1) * @Noofrows;

    SELECT Order_ID, Customer_Name, Quantity,Order_Date,Total_Amount,CATEGORY
    FROM Orders
    ORDER BY Order_ID
    OFFSET @Offset ROWS FETCH NEXT @Noofrows ROWS ONLY;
END;

EXEC CreateDummyrecordsForOrder @MaxCount = 1000;
EXEC Orders_Pagination @index = 2, @Noofrows = 3;



-------SP2----------------

ALTER PROCEDURE NewOrders_Pagination
    @index INT = 1,         
    @Noofrows INT  = 100      
AS
BEGIN

    IF OBJECT_ID('tempdb..#Results') IS NOT NULL
      DROP TABLE #Results

    CREATE TABLE #TempOrders
	(
            Order_ID INT,
            Customer_Name NVARCHAR(50),
            Quantity INT,
            Order_Date DATE,
            Total_Amount DECIMAL(10, 2),
            CATEGORY NVARCHAR(50)
    )

	
    INSERT INTO #TempOrders 
    EXEC Orders_Pagination @index = @index, @Noofrows = @Noofrows;

   
    WHILE exists (SELECT top 1 * FROM #TempOrders)
    BEGIN
               
        -- Merge operation
        MERGE OrderSummary AS T
        USING #TempOrders AS S
        ON T.Order_ID = S.Order_ID
        WHEN MATCHED THEN
            UPDATE SET 
                T.Customer_Name = S.Customer_Name,
                T.Quantity = S.Quantity,
                T.Total_Amount = S.Total_Amount,
                T.Order_Date = S.Order_Date,
                T.CATEGORY = S.CATEGORY
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (Order_ID, Customer_Name, Quantity, Order_Date, Total_Amount, CATEGORY)
            VALUES (S.Order_ID, S.Customer_Name, S.Quantity, S.Order_Date, S.Total_Amount, S.CATEGORY);

        -- Increment index for next batch
        SET @index += 1;

		TRUNCATE TABLE #TempOrders
					
        INSERT INTO #TempOrders 
        EXEC Orders_Pagination @index = @index, @Noofrows = @Noofrows;

    END;
	

    -- Drop the temporary table
    DROP TABLE #TempOrders;

END;


EXEC NewOrders_Pagination @index = 2, @Noofrows = 3;

select * from OrderSummary



---EXEC CreateDummyrecordsForOrder @MaxCount = 1000;
--EXEC Orders_Pagination @index = 2, @Noofrows = 3;

TRUNCATE TABLE OrderSummary










select * from orders
select * from OrderSummary

select * from 	Employees

