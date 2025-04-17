use AccountManagementSystem1
go
CREATE PROC proc_TestOutputParam
(
@input1 int,
@input2 int
)
AS
BEGIN
   print @input1
END

declare @input1param int, @input2param int

set @input1param = 1
set @input2param = 2

select @input1param = 1, @input2param = 2;

exec proc_TestOutputParam @input1 = @input1param , @input2 = @input2param;

----------------------------------------------------------
declare @TestxmlType xml
set @TestXmlType = 
'<xml>
	<User>
	   <FName></FName>
	   <LName></LName>
	</User>
</xml>'

select @TestxmlType

ALTER PROC proc_TestOutputParam
(
 @Input XML,
 @Output VARCHAR(100) OUTPUT
)
AS
BEGIN
  SET @Output = 'testing'
END
DECLARE @InputParam varchar(max), @OutputParam VARCHAR(100)
SET @InputParam = ('<xml>
	<User>
	   <FName>Naresh</FName>
	   <LName>Pradhan</LName>
	</User>
</xml>')

declare @start int, @end int;
set @start = CHARINDEX('<LName>',@InputParam) + LEN('<LName>');
set @end = CHARINDEX('</LName>',@InputParam);
set @OutputParam = SUBSTRING(@InputParam,@start,@end - @start);

PRINT @OutputParam

--------------------------------------------
create table TextEXcep
(
id int
)
create table ErrorLog
(
id bigint identity(1,1) primary key,
Source Varchar(200),
Message NVarchar(MAX),
CreatedAt DateTime2,
)

insert into  TextExcep values('sadas');
go
begin try

insert into TextEXcep values('sadas');
end try
begin catch

declare @Message NVARCHAR(MAX);
select @Message = 
       'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200))+
	   'ERROR_MESSAGE : ' + ERROR_MESSAGE()+
	   'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) +
	   'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200))+
	   'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200))

	   print ERROR_MESSAGE()

insert into ErrorLog values('Query','error',GETUTCDATE());

print'Exception happened.Please refer to the log table'
end catch

-----------------------------------------
BEGIN TRY

 BEGIN TRAN
  insert into AMS.[User](UserName,DOB,DOJ,AccountNo,MobileNo,CreatedBy)
  values ('Ayush','2002-02-23','2021-01-24',786999,78588,'Admin');
  insert into AMS.[Address](UserID,AddressDetail,CreatedBy)
  values(3,'BBSR','Admin');


 
 COMMIT TRAN

END TRY
BEGIN CATCH
  
  ROLLBACK
  print 'rolledback'

END CATCH
select * from AMS.[User];
select * from AMS.[Address];


-----------------------------------[
-->row num
-->rank
-->dense rank
CREATE TABLE [dbo].[Emp] (
    [EmpId] INT NOT NULL IDENTITY(1, 1),
    [Name] VARCHAR(255) NULL,
    [DeptId] INT NULL,
    [Salary] INT NULL,
    PRIMARY KEY ([EmpID])
);
GO
TRUNCATE TABLE [Emp]
INSERT INTO [Emp] ([Name], DeptId, Salary)
VALUES
  ('Britanni',3,1000),
  ('Julian',2,2000),
  ('Dolan',3,3000),
  ('Jonah',4,4000),
  ('Fulton',2,5000),
  ('Scarlett',4,1000),
  ('Bernard',2,2000),
  ('Chancellor',1,3000),
  ('Dalton',4,4500),
  ('Len',1,5000),
  ('Bree',4,1000),
  ('Cooper',1,2000),
  ('Nora',4,3000),
  ('Gareth',3,4000),
  ('Beau',2,5000);  

select * ,
ROW_NUMBER() OVER(PARTITION BY DeptId ORDER BY Salary) As RowNumber,
RANK() OVER(PARTITION BY DeptId ORDER BY Salary) As [Rank],
DENSE_RANK() OVER(PARTITION BY DeptId ORDER BY Salary) As [DenseRank]
From [dbo].[Emp];

select * ,
ROW_NUMBER() OVER(ORDER BY Salary) As RowNumber,
RANK() OVER(ORDER BY Salary) As [Rank],
DENSE_RANK() OVER(ORDER BY Salary) As [DenseRank]
From [dbo].[Emp];


with CTE_Name as
(
      select year(u.DOB) as YEAR_Col , u.Balance as BALANCE from AMS.[AccountAnalytics] u
)

select * ,
ROW_NUMBER() OVER(PARTITION BY YEAR_COL ORDER BY BALANCE) As RowNumber,
RANK() OVER(PARTITION BY YEAR_COL ORDER BY BALANCE) As [Rank],
DENSE_RANK() OVER(PARTITION BY YEAR_COL ORDER BY BALANCE) As [DenseRank]
From CTE_Name;