-- Stored Procedure for Pagination of from Order table and craete a temp table
-- and put into the order_summery by dividing the data that alredy happen and to insert into the 
--Ordersummery.

﻿USE [Practice]
go

CREATE proc CreateDummyrecordsForOrder
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


Exec CreateDummyrecordsForOrder;

select * from Orders

--truncate table Orders

----------data extracting from Orders
-- Creating a stored procedure to retrieve data from the Top_Orders table in chunks
--craete a procedure insert into temp table the extracted chunk data from Orders

------------------------------------------------
--drop proc spPagination
create or alter procedure spPagination
(
	@Pagen int,
	@RowN int
)
as
begin
	DECLARE @PageNumber AS INT
	DECLARE @RowsOfPage AS INT
	SET @PageNumber= @Pagen
	SET @RowsOfPage= @RowN
	SELECT * FROM Orders
	ORDER BY  Order_ID
	OFFSET (@PageNumber-1)*@RowsOfPage ROWS
	FETCH NEXT @RowsOfPage ROWS ONLY
end


--Exec spPagination 1,100
go

sp_help 'Orders'
--since data types are different	
truncate table OrderSummary
go
--drop PROCEDURE spMergeOrderSummary
create or alter PROCEDURE spMergeOrderSummary
AS
BEGIN
    DECLARE @PageNumber INT = 1;
    DECLARE @RowsOfPage INT = 100;
    
    CREATE TABLE #TempOrders
    (
  Order_ID INT PRIMARY KEY,
  Customer_Name NVARCHAR(50),
  Product NVARCHAR(50),
  Quantity INT,
  Order_Date DATE,
  Total_Amount DECIMAL(10, 2),
  CATEGORY NVARCHAR(50)
    );

	INSERT INTO #TempOrders
        EXEC spPagination @PageNumber, @RowsOfPage

    WHILE Exists(SELECT 1 FROM #TempOrders)
    BEGIN
            INSERT INTO OrderSummary (Order_ID, Customer_Name,Product, Quantity, Total_Amount, Order_Date,CATEGORY)
				SELECT
					Order_ID,
					Customer_Name,
					Product,
					Quantity,
					Total_Amount,
					Order_Date,
					CATEGORY
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
select * from OrderSummary;
select * from Orders



			
