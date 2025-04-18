--Question 8
 select * from Employees;
 with cte_raw as(
 select *,count(*),ROW_NUMBER() OVER(partition by FirstName,LastName,Position,Salary ORDER BY Salary) AS ROWNUMBER
 --Rank() OVER(partition by FirstName,LastName,Position,Salary ORDER BY Salary) AS Rank_num
 --DENSE_RANK() OVER(partition by FirstName,LastName,Position,Salary ORDER BY Salary) AS dense_rank
 from Employees)
 --select * from cte_raw;
 
 select *,COUNT(*) OVER(partition by FirstName,LastName,Position,Salary ORDER BY Salary)COUNTFORGROUP
 from cte_raw
 where ROWNUMBER >1;
 
 select  e1.* from Employees e1
 where exists(select top 1 * from employees e2
 where e1.FirstName=e2.FirstName and e1.EmployeeID!=e2.EmployeeID)
 order by Salary;
 ------------------------
 --Question 8
 ;with cte1_order  as(
 select Customer_Name,sum(Quantity) as sum_quan
 from Orders 
 group by Customer_Name
 )
 update Orders
 set Quantity=sum_quan
 from orders o join cte1_order c on o.Customer_Name=c.Customer_Name;
 
 select * from Orders;
 update  Orders
 set Quantity =(select top 1 sum(quantity) from Orders group by Customer_Name);
 
 ------------------------
 --Question 9
 alter procedure proc_Index
 (
 	@index_no int,
 	@no_of_records int
 )
 as
 begin
 	declare @offset bigint
 	set @offset=(@index_no-1) * @no_of_records
 
 	select *
 	from orders
 	order by Total_Amount
 	OFFSET @offset rows
 	fetch next @no_of_records rows only;
 
 end
 exec proc_Index 2,4;
 
 
 create or alter procedure proc_merge_ordersummary
 as
 begin
 declare @index_no1 int, @input_no_of_records int
 
 set @index_no1 = 1;
 set @input_no_of_records =100
 
 IF OBJECT_ID('tempdb..#temp_offset') IS NOT NULL
     DROP TABLE #temp_offset
 
 create table #temp_offset (
     Order_ID INT PRIMARY KEY,
     Customer_Name NVARCHAR(50),
     Product NVARCHAR(50),
     Quantity INT,
     Order_Date DATE,
     Total_Amount DECIMAL(10, 2),
     CATEGORY NVARCHAR(50)
 )

 insert into #temp_offset
 exec proc_Index @index_no = @index_no1, @no_of_records = @input_no_of_records
 
 while exists(select top 1 * from #temp_offset)
 begin
 	
 	--merge temp into ordersummary
 	MERGE INTO Ordersummary t
 		USING #temp_offset s on t.Order_ID=s.Order_ID

 	WHEN MATCHED THEN 
 		UPDATE  SET t.Order_ID=s.Order_ID,t.Customer_Name=s.Customer_Name,t.Product=s.Product,t.Quantity=s.Quantity,
 					t.Order_Date=s.Order_Date,t.Total_Amount=s.Total_Amount,t.category=s.category
 	
	WHEN NOT MATCHED BY TARGET 
 	THEN
 	   INSERT(Order_Id,Customer_Name,Product,Quantity,Order_Date,Total_Amount,Category)
 	   VALUES(s.Order_Id,s.Customer_Name,s.Product,s.Quantity,s.Order_Date,s.Total_Amount,Category);
 
 	--clean the temp table
     --delete from #temp_offset
	 truncate table #temp_offset
	 SET @index_no1 += 1
  end
 
    drop table #temp_offset
 end
 go

 exec proc_merge_ordersummary
 truncate table ordersummary
 select * from Ordersummary
 select * from orders
 ------- --------------------------------------------------------------------------------------------------------------------------------------------
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