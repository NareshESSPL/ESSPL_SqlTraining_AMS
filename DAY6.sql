--merge-->>always write in sp
use AccountManagementSystem1
go
-- Drop tables if they already exist
DROP TABLE IF EXISTS Test_Merge_Source;
DROP TABLE IF EXISTS Test_Merge_Target;

-- Create source table
CREATE TABLE Test_Merge_Source
(
    id INT PRIMARY KEY,
    name VARCHAR(200)
);

-- Create target table
CREATE TABLE Test_Merge_Target
(
    id INT PRIMARY KEY,
    name VARCHAR(200),
    CreatedDate DATETIME
);

-- Insert data into source table
INSERT INTO Test_Merge_Source (id, name) VALUES
(1, 'Naresh'),
(2, 'Laresh'),
(3, 'Jaresh');

-- Insert a dummy row into target table to simulate deletion case
INSERT INTO Test_Merge_Target (id, name, CreatedDate)
VALUES (9, 'testInsert', GETDATE());

-- Perform the MERGE operation
MERGE Test_Merge_Target AS t
USING Test_Merge_Source AS s
ON t.id = s.id

WHEN MATCHED THEN 
    UPDATE SET t.name = s.name

WHEN NOT MATCHED BY TARGET THEN 
    INSERT (id, name, CreatedDate)
    VALUES (s.id, s.name, GETDATE())

WHEN NOT MATCHED BY SOURCE THEN 
    DELETE;

-- Final result: select from target
SELECT * FROM Test_Merge_Target;
-------------------------------------
INSERT INTO AMS.[User] (
     UserName, DOB, DOJ, AccountNo, MobileNo, CreatedBy, Created
) VALUES
( 'John Doe', '1990-01-01', '2020-01-15', 12345, 987654, 'Admin', '2025-04-15'),
( 'Jane Smith', '1985-05-15', '2019-03-10', 54321, 91234, 'Manager', '2025-04-15'),
( 'Alice Johnson', '2000-07-20', '2023-06-01', 67890, 87654, 'Supervisor', '2025-04-15');

ALTER TABLE AMS.AccountAnalytics 
ALTER COLUMN MobileNo BIGINT;


Create Table AMS.AccountAnalytics(

UserId int,
UserName nvarchar(250),
DOB	datetime,
DOJ	datetime,
AccountNo	int,
Balance Decimal(10,6),
AccountTransactionId BIGINT,
IsSaving bit,
MobileNo int,
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
with cte_AccountAnalysis
as
(
select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created 
  from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
	 )
MERGE AMS.Account

------------------------------

--set operation--

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


select UserID,MobileNo from AMS.[User] 
union 
select UserID,MobileNo from AMS.[AccountAnalytics]
order by MobileNo



-----------------------------------------------
/*TRIGGER*/
CREATE TABLE [AppUser_History](
	[UserID] [int] NULL,
	[UserName] [varchar](250) NULL,
	[OldUserName] [varchar](250) NULL,
	[Operation] [varchar](3) NOT NULL,
	[ModifiedDate] DateTime NOT NULL,
	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
)
GO
CREATE TABLE [AppUser]
(
[UserID] int null,
[UserName] varchar(250) null

)
go
create trigger trg_testInsert
ON AppUser
after insert
as
begin
insert into AppUser_History(UserID, UserName, ModifiedDate, Operation)
select i.UserID, i.UserName, getdate(), 'INS' FROM INSERTED i
end;

create trigger trg_testUpdate
ON AppUser
after update
as 
begin
insert into AppUser_History(UserID,UserName,OldUserName,ModifiedDate,Operation)
select i.UserID, i.UserName, d.UserName, GETDATE(),'UPD'
from deleted d inner join inserted i on d.UserID = i.UserID;
end;

drop trigger trg_testInsert
drop trigger trg_testUpdate

/*To handle INSERT, UPDATE, and DELETE operations in a single trigger*/

--Method-1
CREATE TRIGGER trg_AppUser_AllActions
ON AppUser
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Handle INSERT operations
    INSERT INTO AppUser_History(UserID, UserName, ModifiedDate, Operation)
    SELECT i.UserID, i.UserName, GETDATE(), 'INS'
    FROM INSERTED i
    WHERE NOT EXISTS (SELECT 1 FROM DELETED d WHERE i.UserID = d.UserID);

    -- Handle UPDATE operations
    INSERT INTO AppUser_History(UserID, UserName, OldUserName, ModifiedDate, Operation)
    SELECT i.UserID, i.UserName, d.UserName, GETDATE(), 'UPD'
    FROM INSERTED i
    INNER JOIN DELETED d ON i.UserID = d.UserID;

    -- Handle DELETE operations
    INSERT INTO AppUser_History(UserID, UserName, ModifiedDate, Operation)
    SELECT d.UserID, d.UserName, GETDATE(), 'DEL'
    FROM DELETED d
    WHERE NOT EXISTS (SELECT 1 FROM INSERTED i WHERE i.UserID = d.UserID);
END;

--Method-2
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

------------------------------------------------------

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


insert into Item values (2,2, 'test2');


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
----------------------------------------
--non cluster index--

create nonclustered index IX_AccountAnalytics_Username_DOB
ON AMS.AccountAnalytics(Username,DOB)
select * from AMS.AccountAnalytics where username like '%te%' and DOB > GETDATE()
