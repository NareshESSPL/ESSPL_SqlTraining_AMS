USE AccountManagementSystem
GO
-----------------------------------------------XML DATATYPE------------------------------------------------------
DECLARE @TestxmlType xml
SET @TestxmlType =
'<xml>
	<User>
		<FName></FName>
		<LName></LName>
	</User>
</xml>'

SELECT @TestxmlType
---------------------------------------------------OUTPUT-----------------------------------------------------------
CREATE PROC proc_TestOutputParam
 (
  @Input XML,
  @Output VARCHAR(100) OUTPUT
 )
 AS
 BEGIN
   SET @Output = 'testing'
 END
 
 DECLARE @InputParam XML, @OutputParam VARCHAR(100)
 SET @InputParam = '<xml>
 	<User>
 	   <FName>Naresh</FName>
 	   <LName>Pradhan</LName>
 	</User>
 </xml>'

EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT
 PRINT @OutputParam

---------------------------------FIND LASTNAME USING STRING----------------------------
DECLARE @InputParam VARCHAR(MAX), @OutputParam VARCHAR(100)
 SET @InputParam = '<xml>
 	<User>
 	   <FName>Naresh</FName>
 	   <LName>Pradhan</LName>
 	</User>
 </xml>'
SELECT SUBSTRING(
    @InputParam,
    CHARINDEX('<LName>', @InputParam) + LEN('<LName>'),
    CHARINDEX('</LName>', @InputParam) - (CHARINDEX('<LName>', @InputParam) + LEN('<LName>'))
) AS LASTNAME
---------------------------------FIND LASTNAME USING XML----------------------------
DECLARE @InputParam XML, @OutputParam VARCHAR(100)
 SET @InputParam = '<xml>
 	<User>
 	   <FName>Naresh</FName>
 	   <LName>Pradhan</LName>
 	</User>
 </xml>'
 SELECT @InputParam.value('(xml/User/LName)[1]', 'NVARCHAR(100)') AS LastName;

 ----------------------------------------EXCEPTIONS-------------------------------------------------------------
 CREATE TABLE TextExcep
 (
	id INT
 )
 CREATE TABLE LogError
 (
	id BIGINT IDENTITY(1,1) PRIMARY KEY,
	Source VARCHAR(200),
	Message NVARCHAR(MAX),
	CreatedAt DATETIME2
 )

 INSERT INTO TextExcep VALUES('ADAS')
 GO

 BEGIN TRY 
	 INSERT INTO TextExcep VALUES('ADAS')
 END TRY
 BEGIN CATCH
	DECLARE @Message NVARCHAR(MAX)
	SELECT @Message = 
			'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + 
            'ERROR_MESSAGE : ' + ERROR_MESSAGE() +
            'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) +
            'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) +
            'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200))
	INSERT INTO LogError VALUES('QUERY', @Message , GETUTCDATE())
 END CATCH
 -------------------------------TRANSACTION--------------------------------------------------------
 BEGIN TRY
	BEGIN TRAN
		INSERT INTO ItemType(ItemTypeId, itemTypeName) VALUES (111, 'CAM')
		INSERT INTO Item(ItemId, ItemName, ItemTypeId) VALUES (199, 879, 'TESTTYPE')
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
 		
   INSERT INTO LogError VALUES('Query', @Message, GETUTCDATE())
 
   PRINT 'Exception happened.Please refer the error log table'
 
 END CATCH
 
 select * from Item
 select * from ItemType
 -------------------------------------------TRANSACTION IN USER AND ADDRESS TABLE-------------------------------------
 BEGIN TRY
	BEGIN TRAN
		INSERT INTO AMS.[User](UserName, MobileNumber, Balance, DateOfBirth, DateOfJoining, CreatedBy, CreatedDate) VALUES ('TOM', 12345,500.00 , '1990-04-05', '2025-04-05', 'ADMIN', GETDATE())
		INSERT INTO AMS.[Address](AddressID ,UserID, FullAddress, CreatedBy) VALUES (123, 123, 'BBS', 'ADMIN')
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
 		
   INSERT INTO LogError VALUES('Query', @Message, GETUTCDATE())
 
   PRINT 'Exception happened.Please refer the error log table'
 
 END CATCH
 ---------------------------savepoint---------------------------------------------------------
  BEGIN TRY
	BEGIN TRAN
		INSERT INTO AMS.[User](UserName, MobileNumber, Balance, DateOfBirth, DateOfJoining, CreatedBy, CreatedDate) VALUES ('TOM', 12345,500.00 , '1990-04-05', '2025-04-05', 'ADMIN', GETDATE())
		SAVE TRANSACTION SavePoint 
		INSERT INTO AMS.[Address](AddressID ,UserID, FullAddress, CreatedBy) VALUES (123, 123, 'BBS', 'ADMIN')
	COMMIT TRAN
END TRY
BEGIN CATCH
   
   ROLLBACK TRANSACTION SavePoint
   print 'rolledback TO SAVEPOINT '
 
   DECLARE @Message NVARCHAR(MAX)
   SELECT @Message = 
         'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + 
         'ERROR_MESSAGE : ' + ERROR_MESSAGE() +
         'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) +
         'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) +
         'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200)) 
 		
   INSERT INTO LogError VALUES('Query', @Message, GETUTCDATE())
 
   PRINT 'Exception happened.Please refer the error log table'
 
 END CATCH
 ----------------------------ranking----------------------------------------------------------
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
 SELECT ROW_NUMBER() OVER(ORDER BY SALARY) AS ROWNUM, 
	RANK() OVER(ORDER BY SALARY) AS RANKS,
	DENSE_RANK() OVER(ORDER BY SALARY) AS DENSERANK, 
 * FROM EMP

 SELECT ROW_NUMBER() OVER(PARTITION BY DeptId ORDER BY SALARY) AS ROWNUM, 
	RANK() OVER(PARTITION BY DeptId ORDER BY SALARY) AS RANKS,
	DENSE_RANK() OVER(PARTITION BY DeptId ORDER BY SALARY) AS DENSERANK, 
 * FROM EMP
-------------------------------TRYING RANKING IN ACCOUNT ANALYSIS FROM AMS-----------------------------------------
 SELECT YEAR(DateOfBirth), 
 ROW_NUMBER() OVER(PARTITION BY YEAR(DateOfBirth) ORDER BY Balance DESC) AS ROWNUM,
 * FROM AMS.MergedUserInfo