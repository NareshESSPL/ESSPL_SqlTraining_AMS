/*
MERGE, RANK and SET Operations
*/

USE Testing;
go
/*
Merge Statement
-helps in performing the repetitive tasks by a single query, which means that when we want to INSERT, DELETE and UPDATE data from a table. 
-The MERGE statement comes in handy because It does three operations through a single MERGE statement.
*/
SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[UserAccountMapping];
SELECT * FROM AMS.[AccountTransaction];

CREATE TABLE TestMergeSource
(
 id int identity(1,1) primary key,
 name varchar(200)
)

CREATE TABLE TestMergeTarget
(
 id int  primary key,
 name varchar(200),
 CreatedDate DATETIME,
 )
INSERT INTO TestMergeSource VALUES ('Abinas')

INSERT INTO TestMergeSource VALUES ('Nandu')

INSERT INTO TestMergeSource VALUES ('Kappa')
select * from TestMergeSource

--Update TestMergeSource set name = 'testupdates12' where id = 3
SET IDENTITY_INSERT TestMergeTarget ON
INSERT INTO TestMergeTarget(id, [name]) VALUES(12,'Chilika')
SET IDENTITY_INSERT TestMergeTarget OFF


/*Test data*/
;with cte_AccountAnalytics
AS
(
 select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
)
/*
MERGE TestMergeTarget t
 USING TestMergeSource s ON s.id = t.id

 WHEN MATCHED
      THEN UPDATE SET
	     t.name =  s.name

 WHEN NOT MATCHED BY TARGET
      THEN INSERT (id, name) VALUES (s.id, s.[name])

 WHEN NOT MATCHED BY SOURCE
      THEN DELETE;
*/
SELECT * FROM AMS.[ACCOUNTANALYTICS]

MERGE AMS.AccountAnalytics t
using cte_AccountAnalytics s
 ON (t.AccountTransactionID = s.AccountTransactionID) 

 when matched
   then 
   UPDATE set t.UserID = s.UserID, t.UserName = s.UserName, t.DOB = s.DOB , t.DOJ= s.DOJ, t.AccountID = s.AccountID, t.AccountNo = s.AccountNo, t.MobileNo = s.MobileNo, t.AddressID = s.AddressID, t.AddressDetail = s.AddressDetail, t.IsSaving = s.IsSaving, t.Amount = s.Amount, t.IsDebit = s.IsDebit, t.CreatedBy = s.CreatedBy, t.Created = s.Created

 when not matched by target
  then insert (UserID, UserName, DOB, DOJ, AccountID, AccountNo, MobileNo, AddressID, AddressDetail, IsSaving, Amount, IsDebit, CreatedBy, Created) Values (s.UserID, s.UserName, s.DOB, s.DOJ, s.AccountID, s.AccountNo, s.MobileNo, s.AddressID, s.AddressDetail, s.IsSaving, s.Amount, s.IsDebit, s.CreatedBy, s.Created)


 when not matched by source
  then delete;


SELECT * FROM  TestMergeTarget;
-------------------------------------------------------------
-- SET Operation
Create table Customer
(
  CustomerID BIGINT IDENTITY(1,1) NOT NULL Primary key,
  CustomerName VARCHAR(100) NOT NULL,
  PINCODE INT,
  City VARCHAR(200) NULL
)
go

Create table Supplier
(
  SupplierID BIGINT IDENTITY(1,1) NOT NULL Primary key,
  SupplierName VARCHAR(100) NOT NULL,
  PINCODE INT,
  City VARCHAR(200) NULL
)
go

insert into Customer values('Naresh', 111, 'BBSR')
insert into Customer values('Suresh', 111, 'BBSR')
insert into Customer values('Paresh', 222, 'CTC')
insert into Customer values('Mahesh', 111,'JPR')
insert into Customer values('Mahesh', 000,NULL)

insert into Supplier values('Panda and Co', 111, 'BBSR')
insert into Supplier values('Das and Co', 123, 'BBSR')
insert into Supplier values('Nayak and Co', 777, 'CTC')
insert into Supplier values('Aditya Groups', 111,'KJR')

--get list of city we have both customer and suppier
SELECT PINCODE, City FROM Customer
UNION
SELECT PINCODE, City FROM Supplier
ORDER BY City;

SELECT PINCODE, City FROM Customer
UNION ALL
SELECT PINCODE, City FROM Supplier
ORDER BY City;

--Only present in fist table
SELECT PINCODE, City FROM Customer
EXCEPT
SELECT PINCODE, City FROM Supplier
ORDER BY City;


--Must present in both table
SELECT PINCODE, City  FROM Customer
INTERSECT
SELECT PINCODE, City FROM Supplier
ORDER BY City;
---------------------------------------------------------------------------------------------------
/*
--Q. Perform Set operations'
- Union
- Union All
- Intersect
- Except
     wih user and accountanalysis table for user names
*/

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[AccountAnalytics];

SELECT UserName FROM AMS.[USER]
UNION
SELECT UserName FROM AMS.[AccountAnalytics]
ORDER BY UserName;
----------------------------------------------------------------------------------------------
/*
TRIGGER(DML Triggers only)
-are stored procedure that automatically execute in response to certain events in a 
 specific table or view in a db.
-Type of DML Triggers 
  -AFTER Trigger- Execute after DML operation is completed
  -INSTEAD OF Tigger- Replace the DML operation with custom logic
*/
CREATE TABLE AppUser
(
 UserID INT PRIMARY KEY,
 UserName NVARCHAR(MAX),
 CreatedDate DATETIME DEFAULT GETDATE()
)

CREATE TABLE [AppUser_History](
	[UserID] [int] NULL,
	[UserName] [varchar](250) NULL,
	[OldUserName] [varchar](250) NULL,
	[Operation] [varchar](3) NOT NULL,
	[ModifiedDate] DateTime NOT NULL,
	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
)
GO
--INSERT 
CREATE Trigger trg_testInsert
ON AppUser
AFTER INSERT 
AS
BEGIN
     INSERT INTO AppUser_History(UserID, UserName, ModifiedDate, Operation)
	 SELECT i.UserID, i.UserName, GETDATE(), 'INS' FROM inserted i;
END

INSERT INTO AppUser (UserID, UserName) VALUES (111,'Yeti')
INSERT INTO AppUser (UserID, UserName) VALUES (112,'Kappa')
INSERT INTO AppUser (UserID, UserName) VALUES (113,'Bhalu')

--DELETE
CREATE Trigger trg_testDelete
ON AppUser
AFTER DELETE
AS
BEGIN
     INSERT INTO AppUser_History(UserID, UserName, ModifiedDate, Operation)
	 SELECT i.UserID, i.UserName, GETDATE(), 'INS' FROM inserted i;
END
DELETE FROM AppUser WHERE UserID = 111;

--UPDATE
CREATE trigger trg_testUpdate
ON AppUser
AFTER UPDATE
AS
BEGIN
     INSERT INTO AppUser_History(UserID, UserName, ModifiedDate, Operation)
	 SELECT i.UserID, i.UserName, GETDATE(), 'INS' FROM deleted d
	 INNER JOIN INSERTED i ON d.UserID = i.UserID
END

UPDATE AppUser Set UserName = 'Chilika Kappa' WHERE UserId = 113;

Select * from AppUser;
Select * from AppUser_History;



/*
INSTEAD OF Trigger
*/
create table ItemType
(
  ItemTypeId int not null primary key,
  itemTypeName varchar(100) not null
)

create table Item
(
  ItemId int not null primary key,
  ItemTypeId int not null foreign key references ItemType(ItemTypeId),
  ItemName varchar(100) not null
)


insert into Item values (2,2, 'test2')

create TRIGGER trg_InsteadOfInsert_Item
ON Item
INSTEAD OF INSERT
AS
BEGIN
    IF NOT EXISTS(SELECT TOP 1 ItemTypeId  FROM ItemType)
	BEGIN

	  INSERT INTO ItemType (ItemTypeId, itemTypeName) 
	  SELECT i.ItemTypeId, 'UNKNOWN' FROM INSERTED i 

	END
	
	  INSERT INTO Item (ItemID, ItemTypeId, ItemName) 
	  SELECT i.ItemID, i.ItemTypeId, i.ItemName FROM INSERTED i 
	  	   
END

select * from Item
select * from ItemType

----------------------------------------------------------------------------------------------
/*
NON-CLUSTERED INDEX
*/
CREATE NONCLUSTERED INDEX IX_AccountAnalaytics_USERNAME_DOB
ON AMS.[AccountAnalytics](UserName, DOB)

SELECT * FROM AMS.[AccountAnalytics] WHERE UserName like '%60%' and dob > '2000-01-01'

------------------------------------------------------------------------------------------------------
/*
Created On- 16/04/25
Created By- Aditya Shukla
*/
declare @TestxmlType xml
set @TestXmlType = 
'<xml>
	<User>
	   <FName></FName>
	   <LName></LName>
	</User>
</xml>'

select @TestxmlType

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
------------------------------------------------------------------------------------

/*
Exception Handling
Note :
  - We must either commit or rollback the transaction while writing the transaction
  - How to know when to commit and when to rollback - exception handling
*/
CREATE TABLE TextExcep
(
  id INT
);

INSERT INTO TextExcep VALUES ('Nepal');

BEGIN TRY
  INSERT INTO TextExcep VALUES ('Nepal');
END TRY
BEGIN CATCH
  PRINT 'Exception happened'
END CATCH

------------------------------------------------------------------------------------------------
/*
RANK
*/
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
GO

SELECT *, 
ROW_NUMBER() OVER(ORDER BY Salary) AS RowNumber, Salary,
RANK() OVER(ORDER BY Salary) AS [Rank], Salary,
DENSE_RANK() OVER(ORDER BY Salary) AS [DenseRank]
FROM Emp;

SELECT *, 
SUM(Salary) OVER(PARTITION BY DEPTID) AS [SUM],
MIN(Salary) OVER(PARTITION BY DEPTID) AS [MIN],
MAX(Salary) OVER(PARTITION BY DEPTID) AS [MAX]
FROM Emp;
GO
-----------------------------------------------------------------------


