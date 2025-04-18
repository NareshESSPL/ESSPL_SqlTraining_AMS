USE [Practice]
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
