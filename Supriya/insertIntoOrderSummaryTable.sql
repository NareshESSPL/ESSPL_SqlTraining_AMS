USE [Practice]
--go

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

select * from Orders


--procedure for fetching dynamic number of records from Oders table
 create or alter proc proc_chunking
 @index int, @record_no int
 as begin
    declare @offset int
	set @offset = (@index - 1)*@record_no

	select * from Orders 
	order by Order_ID 
	offset @offset rows
	fetch next @record_no rows only;
end

exec proc_chunking 1,100
go


--procedure to insert values from orders table int orderSummary table in a series of 100 values at a time
--using temp table
create or alter proc proc_SyncOrderSummary
as begin

  declare @index bigint, @offset bigint, @record_no bigint
  set @index = 1
  set @offset = 0
  set @record_no = 100

  while @offset < 1001
  begin
    print @offset
    create table #tempTable(
      Order_ID INT PRIMARY KEY,
      Customer_Name NVARCHAR(50),
      Product NVARCHAR(50),
      Quantity INT,
      Order_Date DATE,
      Total_Amount DECIMAL(10, 2),
      CATEGORY NVARCHAR(50)
    );

    insert into #tempTable 
    exec proc_chunking @index,@record_no

    merge OrderSummary t using #tempTable s on s.Order_ID = t.Order_ID
    when matched 
    then update set t.Customer_Name = s.Customer_Name,
                 t.Product = s.Product,
				 t.Quantity = s.Quantity,
				 t.Order_Date = s.Order_Date,
				 t.Total_Amount = s.Total_Amount,
				 t.CATEGORY = s.CATEGORY

    when not matched by target 
    then insert(Order_ID ,Customer_Name ,Product ,Quantity ,Order_Date ,Total_Amount ,CATEGORY)
    values (s.Order_ID ,s.Customer_Name ,s.Product ,s.Quantity,s.Order_Date ,s.Total_Amount ,s.CATEGORY);

	set @offset += 100
	set @index += 1
	drop table #tempTable
  end
end
go

--using table type
create type table_type as table (
      Order_ID INT PRIMARY KEY,
      Customer_Name NVARCHAR(50),
      Product NVARCHAR(50),
      Quantity INT,
      Order_Date DATE,
      Total_Amount DECIMAL(10, 2),
      CATEGORY NVARCHAR(50)
)

create or alter proc proc_SyncOrderSummary
as begin

  declare @index bigint, @offset bigint, @record_no bigint
  set @index  = 1
  set @offset = 0
  set @record_no = 100

  while @offset < 1001
  begin
    print @offset
    declare @ChunkedTable as table_type

    insert into @ChunkedTable 
    exec proc_chunking @index,@record_no

    merge OrderSummary t using @ChunkedTable s on s.Order_ID = t.Order_ID
    when matched 
    then update set t.Customer_Name = s.Customer_Name,
                 t.Product = s.Product,
				 t.Quantity = s.Quantity,
				 t.Order_Date = s.Order_Date,
				 t.Total_Amount = s.Total_Amount,
				 t.CATEGORY = s.CATEGORY

    when not matched by target 
    then insert(Order_ID ,Customer_Name ,Product ,Quantity ,Order_Date ,Total_Amount ,CATEGORY)
    values (s.Order_ID ,s.Customer_Name ,s.Product ,s.Quantity,s.Order_Date ,s.Total_Amount ,s.CATEGORY);

	set @offset += 100
	set @index += 1

  end
end

 select * from OrderSummary
 go

