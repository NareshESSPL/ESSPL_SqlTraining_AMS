Use AccountManagementSystem;

Create Table TestMergeSource
(
Id Int Primary Key,
Name Varchar(200)
)

Create Table TestMergeTarget
(
Id  Int Primary Key,
Name Varchar(200),
CreatedDate DateTime
)

Insert Into TestMergeSource Values ('Mahesh')
Insert into TestMergeSource Values ('Ritwik')
Insert into TestMergeSource Values ('Aditya')

Set Identity_Insert TestmergeTarget ON
Insert Into TestMergeTarget(Id,Name) Values (9,'testInsertT')
Set Identity_Insert TestMergeTarget Off;


MERGE TestMergeTarget AS T
USING TestMergeSource AS S ON S.ID = T.ID
WHEN MATCHED THEN
    UPDATE SET T.Name = S.Name
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Name, CreatedDate) VALUES (S.Name, GETDATE())
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

Select * From TestMergeSource;

Select * From TestMergeTarget;



;With CTE_AccountAnalysis As
(
select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created 
  from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
)

Merge AMS.AccountAnalytics T
Using CTE_AccountAnalysis S
On (S.UserID = S.UserID)


-- SET OPERATIONS

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

--Delete few records and perform intersect,except and union operations on UserAccountAnalysis Table

Create Table AMS.AccountAnalytics(

UserId int,
UserName nvarchar(250),
DOB	datetime,
DOJ	datetime,
AccountNo	int,
Balance Decimal(10,6),
AccountTransactionId BIGINT,
IsSaving bit,
MobileNo	int,
AddressDetails nvarchar(max),
Amount Decimal(10,6),
IsDebit bit,
CreatedBy varchar(250)

);

INSERT INTO AMS.AccountAnalytics (
    UserId, UserName, DOB, DOJ, AccountNo, Balance, 
    AccountTransactionId, IsSaving, MobileNo, AddressDetails, 
    Amount, IsDebit, CreatedBy
)
VALUES
(1, 'John Doe', '1990-01-01', '2022-01-01', 12345, 500.75, 
 100001, 1, 9876543210, '123 Elm Street', 
 100.50, 1, 'Admin'),
(2, 'Jane Smith', '1985-05-15', '2023-03-10', 54321, 250.00, 
 100002, 0, 9123456789, '456 Oak Avenue', 
 50.25, 0, 'Manager');

 ALTER TABLE AMS.AccountAnalytics 
ALTER COLUMN MobileNo BIGINT;


--Intersect Operation
SELECT UserID,UserName  FROM AMS.[User]
INTERSECT
SELECT UserID FROM AMS.[AccountAnalytics]
ORDER BY UserID;

--get list of city we have both customer and suppier
SELECT UserID,UserName FROM AMS.[User]
UNION
SELECT UserID FROM AMS.[AccountAnalytics]
ORDER BY UserID;

SELECT UserID,UserName FROM AMS.[User]
UNION ALL
SELECT UserID FROM AMS.[AccountAnalytics]
ORDER BY UserID;

--Merge
MERGE AMS.AccountAnalytics AS target
USING AMS.[User] AS source
ON target.UserId = source.UserId

WHEN MATCHED THEN
    UPDATE SET
        target.UserName = source.UserName,
        target.DOB = source.DOB
        -- You can update more fields if needed and if they exist in `User`

WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        UserId,
        UserName,
        DOB,
        DOJ,
        AccountNo,
        Balance,
        AccountTransactionId,
        IsSaving,
        MobileNo,
        AddressDetails,
        Amount,
        IsDebit,
        CreatedBy
    )
    VALUES (
        source.UserId,
        source.UserName,
        source.DOB,
        GETDATE(),             -- Placeholder values for the sake of merge
        1000000 + source.UserId,
        0.0,
        NULL,
        1,
        9999999999,
        'Unknown',
        0.0,
        0,
        'system'
    );

/*	INSERT INTO AMS.[User] (
    UserName, DOB, DOJ, ACCOUNTNO, MOBILENO, CREATEDBY, CREATED
)
VALUES
('Ravi Kumar', '1990-05-15', '2015-06-20', 1001001, 9876543210, 'admin', GETDATE());

ALTER TABLE AMS.[User]
ALTER COLUMN MOBILENO BIGINT;
*/

-- Optional: Check the merged result
SELECT * FROM AMS.AccountAnalytics;
SELECT * FROM AMS.[User];
--------------------------------------------------------------------------------------

--TRIGGERS

--Deleted: A special table that holds the old values of the updated rows.
--Inserted: A special table that holds the new values of the updated rows.

CREATE TABLE [AppUser_History](
	[UserID] [int] NULL,
	[UserName] [varchar](250) NULL,
	[OldUserName] [varchar](250) NULL,
	[Operation] [varchar](3) NOT NULL,
	[ModifiedDate] DateTime NOT NULL,
	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
)
GO

INSERT INTO AppUser (UserID, UserName)
VALUES
(101, 'Ravi Kumar'),                
(101, 'Ravi K.'),           
(102, 'Meena Sharma'),             
(103, 'Amit Joshi'),                
(103, 'Amit J.'),           
(103, 'Amit J.');                  


Create Table [AppUser]
(
[UserID] [int] NULL,
[UserName] [Varchar](100) NULL
)


-- Check the history log
SELECT * FROM AppUser_History
ORDER BY ModifiedDate;

SELECT 
    h.UserID,
    h.OldUserName AS [Old Name],
    h.UserName AS [New Name],
    u.UserName AS [Current Name in AppUser],
    h.ModifiedDate
FROM AppUser_History h
JOIN AppUser u ON h.UserID = u.UserID
WHERE h.Operation = 'UPD'
ORDER BY h.ModifiedDate DESC;

CREATE TRIGGER trg_testALL
on AppUser
AFTER INSERT, DELETE
AS
BEGIN
 INSERT INTO AppUser_History(UserID,UserName,OldUserName,ModifiedDate,Operation)
     SELECT i.UserID, i.UserName, NULL AS OLD_USERNAME, GETDATE(), 'INS'
	 FROM INSERTED i 
	   UNION ALL
	 SELECT d.UserID, d.UserName, NULL AS OLD_USERNAME, GETDATE(), 'DEL'
	 FROM DELETED AS d
	 UNION ALL
	 SELECT  i.UserID,i.UserName, d.UserName AS OLD_USERNAME, GETDATE(), 'DEL'
	 FROM DELETED d
	 INNER JOIN  INSERTED i on d.UserID = i.UserID;
END

SELECT 
    name AS TriggerName,
    parent_class_desc AS TriggerScope,
    type_desc AS TriggerType,
    OBJECT_NAME(parent_id) AS TableOrView
FROM sys.triggers;

SELECT COUNT(*) AS TotalTriggers
FROM sys.triggers;

create table ItemType
(
  ItemTypeId int not null primary key,
  itemTypeName varchar(100) not null
)

Create Table Item
(
  ItemId Int Not Null Primary Key,
  ItemTypeId Int Not Null Foreign Key References ItemType(ItemTypeId),
  ItemName Varchar(100) Not Null
)


Insert Into Item Values (2,2, 'test2')

ALTER TRIGGER trg_InsteadOfInsert_Item
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

Select * From Item
Select * From ItemType


Create NonClustered Index IX_AccountAnalytics_Username_DOB
ON AMS.[AccountAnalytics](Username,DOB)

Select * From AMS.[AccountAnalytics] Where Username Like '%te%' And DOB> GETDATE()


