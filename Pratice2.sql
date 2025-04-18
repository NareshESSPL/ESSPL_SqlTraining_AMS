use Practice

insert into Employees values(5, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values(6, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values(7, 'John', 'Doe', 'Manager', '75000.00')

--RANK

;with dlt_empl
as
(
select *,
rank() over(partition by FirstName,LastName order by EmployeeID) as rankings
from Employees
)
delete from dlt_empl where rankings > 1

-- JOIN


DELETE E1
FROM Employees E1
JOIN Employees E2
ON E1.FirstName = E2.FirstName
   AND E1.LastName = E2.LastName
   AND E1.EmployeeID > E2.EmployeeID;


delete FROM Employees
WHERE EXISTS (
    SELECT TOP 1 *
    FROM Employees e2
    WHERE Employees.FirstName = e2.FirstName
      AND Employees.LastName = e2.LastName
      AND Employees.EmployeeID > e2.EmployeeID
)

select * from Orders
insert into Orders values(112,'Ananya','Laptop',1,'2023-06-15',55000,'Electronics','HighValue')

-- using group by
select Customer_Name,sum(Quantity) as sum_total_Quantity
from Orders
group by Customer_Name

-- using over 

select Customer_Name,sum(Quantity) over(partition by Customer_Name order by Customer_Name) as sum_total_Quantity
from Orders 

-- update 

UPDATE Orders
SET Quantity = (
    SELECT SUM(Quantity)
    FROM Orders AS ioo
    WHERE ioo.Customer_Name = Orders.Customer_Name
)
--JOIN

UPDATE Orders
SET Quantity = Too.QuantitySum
FROM Orders AS T
JOIN (
    SELECT Customer_Name, SUM(Quantity) AS QuantitySum
    FROM Orders
    GROUP BY Customer_Name
) AS Too
ON T.Customer_Name = Too.Customer_Name;


select sum(Quantity) from Orders

select * from OrderSummary

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

go
alter proc spPagination
(
	@Pagen int,
	@RowN int
)
as
begin
	DECLARE @PageNumber AS INT
	DECLARE @RowsOfPage AS INT
	SET @PageNumber=@Pagen
	SET @RowsOfPage=@RowN
	SELECT * FROM Orders
	ORDER BY  Order_ID
	OFFSET (@PageNumber-1)*@RowsOfPage ROWS
	FETCH NEXT @RowsOfPage ROWS ONLY
end


spPagination 1,100
go

sp_help 'Orders'
truncate table OrderSummary
go

alter PROCEDURE spMergeOrderSummary
AS
BEGIN
    DECLARE @PageNumber INT = 1;
    DECLARE @RowsOfPage INT = 100;
    DECLARE @HasRecords BIT = 1;
    
    CREATE TABLE #TempOrders
    (
        Order_ID INT PRIMARY KEY,
		Customer_Name NVARCHAR(50),
		Product nvarchar(50),
		Quantity INT,
		Order_Date DATE,
		Total_Amount DECIMAL(10, 2),
		CATEGORY nvarchar(50),
		ValueCategory nvarchar(10)
    );

	INSERT INTO #TempOrders
        EXEC spPagination @PageNumber, @RowsOfPage

    WHILE Exists(SELECT 1 FROM #TempOrders)
    BEGIN
            INSERT INTO OrderSummary (Order_ID, Customer_Name, Total_Quantity, Total_Amount, Order_Date)
				SELECT
					Order_ID,
					Customer_Name,
					Quantity,
					Total_Amount,
					Order_Date
				FROM #TempOrders


            TRUNCATE TABLE #TempOrders;

            SET @PageNumber = @PageNumber + 1;

			INSERT INTO #TempOrders
        EXEC spPagination @PageNumber, @RowsOfPage
        
    END;

    DROP TABLE #TempOrders;
END
go
Exec spMergeOrderSummary;
go

-- table variable

ALTER PROCEDURE spMergeOrderSummary
AS
BEGIN
    DECLARE @PageNumber INT = 1;
    DECLARE @RowsOfPage INT = 100;

    DECLARE @TempOrders TABLE
    (
        Order_ID INT PRIMARY KEY,
        Customer_Name NVARCHAR(50),
        Product NVARCHAR(50),
        Quantity INT,
        Order_Date DATE,
        Total_Amount DECIMAL(10, 2),
        CATEGORY NVARCHAR(50),
        ValueCategory NVARCHAR(10)
    );

    INSERT INTO @TempOrders
    EXEC spPagination @PageNumber, @RowsOfPage;

    WHILE EXISTS(SELECT 1 FROM @TempOrders)
    BEGIN
        INSERT INTO OrderSummary (Order_ID, Customer_Name, Total_Quantity, Total_Amount, Order_Date)
        SELECT
            Order_ID,
            Customer_Name,
            Quantity,
            Total_Amount,
            Order_Date
        FROM @TempOrders;

        DELETE FROM @TempOrders;

        SET @PageNumber = @PageNumber + 1;

        INSERT INTO @TempOrders
        EXEC spPagination @PageNumber, @RowsOfPage
    END
END
GO

EXEC spMergeOrderSummary;
GO
