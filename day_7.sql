USE Testing;
GO

select * from ams.[User]
select * from ams.[Address]


BEGIN TRY
 BEGIN TRAN

 SET IDENTITY_INSERT AMS.[User] ON
  INSERT INTO AMS.[User] (userid, username, dob, doj, accountno, mobileno, createdby) values (2021, 'Suraj Sah', '2004-02-02 00:00:00.000', '2020-02-02 00:00:00.000', 2001, 4836, 'suraj');
  SET IDENTITY_INSERT AMS.[User] OFF
  
  SET IDENTITY_INSERT AMS.[Address] ON
  INSERT INTO AMS.[Address] (addressid, userid, AddressDetail, CreatedBy) values (2001, 2020, 'Nepal', 'surajsah');
  SET IDENTITY_INSERT AMS.[Address] OFF
  
  COMMIT TRAN

END TRY

BEGIN CATCH
  ROLLBACK TRAN
  PRINT 'Error while inserting data'

  DECLARE @ErrorMessage nvarchar(MAX)
  set @ErrorMessage = 
	    'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + ' ' +
        'ERROR_MESSAGE : ' + ERROR_MESSAGE() + ' ' +
        'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) + ' ' +
        'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) + ' ' +
        'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200))
  
  PRINT 'Error Message : ' + @ErrorMessage



USE Testing;
GO

CREATE TABLE TextExcep
(
  id INT
);

--Creating Log Table'
CREATE TABLE ErrorLog
(
  ID BIGINT IDENTITY(1, 1) PRIMARY KEY,
  Source VARCHAR(200),
  Message NVARCHAR(MAX),
  CreatedAt DATETIME2
);

INSERT INTO TextExcep VALUES ('Nepal');

-- Exception Handling
BEGIN TRY

  INSERT INTO TextExcep VALUES ('Nepal');

END TRY

BEGIN CATCH
  
  DECLARE @Message NVARCHAR(MAX)
  SELECT @Message = 
        'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + 
        'ERROR_MESSAGE : ' + ERROR_MESSAGE() +
        'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) +
        'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) +
        'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200)) 
		
  INSERT INTO ErrorLog VALUES('Query', @Message, GETUTCDATE())

  PRINT 'Exception happened.Please refer the error log table'

END CATCH
GO
select * from ErrorLog;




CREATE TABLE [Emp] (
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

INSERT INTO [Emp] ([Name], DeptId, Salary)
VALUES ('Beau', 2, 4000);
GO

SELECT *, 
ROW_NUMBER() OVER(ORDER BY Salary) AS RowNumber, Salary,
RANK() OVER(ORDER BY Salary) AS [Rank], Salary,
DENSE_RANK() OVER(ORDER BY Salary) AS [DenseRank]
FROM Emp;

SELECT DEPTID, 
SUM(Salary) OVER(PARTITION BY DEPTID) AS [SUM],
MIN(Salary) OVER(PARTITION BY DEPTID) AS [MIN],
MAX(Salary) OVER(PARTITION BY DEPTID) AS [MAX]
FROM Emp GROUP BY DEPTID;
GO





USE Testing;
GO


BEGIN TRY

 BEGIN TRAN
  insert into Itemtype(ItemtypeId, ItemtypeName) values (111, 'testtype')
  insert into Item(ItemId, ItemtypeId, Itemname) values (199, 879, 'testtype')
 
 COMMIT TRAN

END TRY
BEGIN CATCH
  
  ROLLBACK
  print 'rolledback'

  DECLARE @Message NVARCHAR(MAX)
  SELECT @Message = 
        'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + 
        'ERROR_MESSAGE : ' + ERROR_MESSAGE() +
        'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) +
        'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) +
        'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200)) 
		
  INSERT INTO ErrorLog VALUES('Query', @Message, GETUTCDATE())

  PRINT 'Exception happened.Please refer the error log table'

END CATCH

select * from Item
select * from ItemType




USE Testing;
GO

-- Create the stored procedure
CREATE PROC proc_TestOutputParam
(
    @Input XML,
    @Output VARCHAR(100) OUTPUT
)
AS
BEGIN
    -- Extract the last name from the XML input
    SET @Output = @Input.value('(/xml/User/LName)[1]', 'VARCHAR(100)')
END

-- Declare input and output variables
DECLARE @InputParam XML, @OutputParam VARCHAR(100)

-- Initialize the input XML
SET @InputParam = '<xml>
 <User>
  <FName>Naresh</FName>
  <LName>Pradhan</LName>
 </User>
</xml>'

-- Execute the stored procedure
EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT

-- Print the output parameter to see the last name
PRINT @OutputParam
GO
-----------------------------------------------------------


--Sample Example
declare @TestxmlType xml
set @TestXmlType = 
'<xml>
	<User>
	   <FName></FName>
	   <LName></LName>
	</User>
</xml>'

select @TestxmlType
GO

CREATE PROC proc_TestOutputParam1
(
 @Input1 int,
 @Input2 varchar(10)
)
AS
BEGIN
   print @Input1
END

declare @Input1Param int, @Input2Param varchar(10)

set @Input1Param = 1
set @Input2Param = 'testing'

select @Input1Param = 1, @Input2Param = 2

EXEC proc_TestOutputParam1 '1', 2

EXEC proc_TestOutputParam1 @Input2 = @Input2Param, @Input1 = @Input1Param