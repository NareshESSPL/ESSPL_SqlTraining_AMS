-------------------------
--delete duplicates

with cte1 as(
SELECT EmployeeID, FirstName, LastName, Position, Salary,
RANK() OVER (PARTITION BY FirstName ORDER BY EmployeeID) AS rank
FROM Employees
)
delete from cte1 where rank >1

-----------------------------------------------------------------------------
insert into Employees values(5, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values(6, 'John', 'Doe', 'Manager', '75000.00')
insert into Employees values(7, 'John', 'Doe', 'Manager', '75000.00')


-----------------------------------------------------------
--delete duplicates
DELETE E1 FROM Employees E1 JOIN Employees E2
ON E1.FirstName = E2.FirstName
   AND E1.LastName = E2.LastName
   AND E1.EmployeeID > E2.EmployeeID

--------------------------------------------------------------------------
--total quantity ordered per 
select Customer_Name,sum(quantity) as totalorders from orders group by Customer_Name


;WITH cte2 AS (
    SELECT Customer_Name, 
           SUM(Quantity) OVER(PARTITION BY Customer_Name) AS total_orders
    FROM Orders
)
UPDATE Orders
SET Orders.Quantity = cte2.total_orders
FROM Orders
JOIN cte2 ON Orders.Customer_Name = cte2.Customer_Name;

-----------------------------------------------------------------------------------
--update total quantity to all the clients
update Orders
set Quantity=(select SUM(quantity) from Orders)

select * from Orders

--------------------------------------------
--create the sp for the indexing
go
create PROCEDURE pagination(
	@index int,
	@get int
)
as
begin
	declare @offset int
	set @offset = (@index-1)*@get
	select * from orders order by Order_ID OFFSET @offset ROWS FETCH NEXT @get ROWS ONLY;
end

exec pagination 5,20;


--put some demo data in orders
go
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

exec CreateDummyrecordsForOrder;


select * from orders

------------------------------------------------------
--merging into order summary by calling sp inside sp

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
        EXEC pagination @PageNumber, @RowsOfPage

    WHILE Exists(SELECT 1 FROM #TempOrders)
    BEGIN
            INSERT INTO OrdersSummary (Order_ID, Customer_Name,product, Quantity, Order_Date,Total_Amount,CATEGORY,ValueCategory)
				SELECT
					Order_ID,
					Customer_Name,
					product,
					Quantity,
					Order_Date,
					Total_Amount,
					CATEGORY,
					ValueCategory
				FROM #TempOrders


            TRUNCATE TABLE #TempOrders;

            SET @PageNumber = @PageNumber + 1;

			INSERT INTO #TempOrders
        EXEC pagination @PageNumber, @RowsOfPage
        
		END;

    DROP TABLE #TempOrders;
END
go
Exec spMergeOrderSummary;
go

--------------------------------------------------------------

CREATE TABLE OrdersSummary (
    Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50),
	ValueCategory nvarchar(10) 
);

select * from orderssummary