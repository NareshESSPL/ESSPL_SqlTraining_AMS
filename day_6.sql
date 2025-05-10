select * from AMS.[AccountAnalytics];

create nonclustered index IX_AccountAnalytics_Username_DOB
ON AMS.[AccountAnalytics] (UserName, DOB);

select * from AMS.[AccountAnalytics] where username like '%60%' and dob > '2000-01-01';


USE Testing;

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.[UserAccountMapping];
SELECT * FROM AMS.[AccountTransaction];

-- Creating AccountAnalytics Table
create table AMS.AccountAnalytics(
 AccountAnalyticsId  bigint identity(1,1),
 UserId bigint,
 UserName	nvarchar(250),
 DOB	datetime,
 DOJ	datetime,
 AccountId bigint,
 AccountNo	int,
 MobileNo	int,
 AddressId bigint,
 AddressDetail nvarchar(max),
 IsSaving bit,
 AccountTransactionID bigint,
 Amount decimal(20,2),
 IsDebit bit,
 CreatedBy	varchar(250),
 created Datetime default getDate()
 );
GO
/*
create proc AMS.[proc_AccountAnalytics]
 as begin 
   
   insert into AMS.AccountAnalytics
     select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID

   select * from AMS.AccountAnalytics

end
EXEC AMS.[proc_AccountAnalytics]
*/

-- delete from AMS.[AccountAnalytics];

-- Creating CTE to extract data from all 5 tables

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


MERGE AMS.[AccountAnalytics] t
using cte_AccountAnalytics s
 ON (t.AccountTransactionID = s.AccountTransactionID) 

 when matched
   then 
   UPDATE set t.UserID = s.UserID, t.UserName = s.UserName, t.DOB = s.DOB , t.DOJ= s.DOJ, t.AccountID = s.AccountID, t.AccountNo = s.AccountNo, t.MobileNo = s.MobileNo, t.AddressID = s.AddressID, t.AddressDetail = s.AddressDetail, t.IsSaving = s.IsSaving, t.Amount = s.Amount, t.IsDebit = s.IsDebit, t.CreatedBy = s.CreatedBy, t.Created = s.Created

 when not matched by target
  then insert (UserID, UserName, DOB, DOJ, AccountID, AccountNo, MobileNo, AddressID, AddressDetail, IsSaving, Amount, IsDebit, CreatedBy, Created) Values (s.UserID, s.UserName, s.DOB, s.DOJ, s.AccountID, s.AccountNo, s.MobileNo, s.AddressID, s.AddressDetail, s.IsSaving, s.Amount, s.IsDebit, s.CreatedBy, s.Created)


 when not matched by source
  then delete;


GO;

/*
Simple Example
*/
create table testMergeSource
(
  id int identity(1,1) primary key,
  name varchar(200)
);

create table testMergeTarget
(
  id int primary key,
  name varchar(200),
  CreatedDate DateTime,
);

insert into testMergeSource values ('naresh')
insert into testMergeSource values ('suresh')
insert into testMergeSource values ('mahesh')
--
set identity_insert testMergeTarget ON;
insert into testMergeTarget(id, [name])  values (9, 'Kappa');
set identity_insert testMergeTarget OFF;


select * from testMergeSource;
select * from testMergeTarget;

merge testMergeTarget t
using testMergeSource s ON s.id = t.id

when matched
 then update set t.name = s.name

when not matched by target
 then insert (name) values (s.name)

 when not matched by source
  then delete;

--Updating Data
update testMergeSource set name = 'Suraj' where id=3;



USE Testing;
GO

CREATE TABLE [AppUser_History](
	[UserID] [int] NULL,
	[UserName] [varchar](250) NULL,
	[OldUserName] [varchar](250) NULL,
	[Operation] [varchar](3) NOT NULL,
	[ModifiedDate] DateTime NOT NULL,
	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
)
GO


--Deleted: A special table that holds the old values of the updated rows.

--Inserted: A special table that holds the new values of the updated rows.

CREATE TRIGGER trg_testInsert
ON AppUser
AFTER INSERT
AS
BEGIN
  INSERT INTO Appuser_History(UserID, UserName, ModifiedDate, Operation)
  SELECT i.UserID, i.UserName, getdate(), 'INS' FROM INSERTED i
END

CREATE TRIGGER trg_testUpdate
ON AppUser
AFTER UPDATE
AS
BEGIN

  INSERT INTO AppUser_History (UserID, UserName, OldUserName, ModifiedDate, Operation)
   
  SELECT i.UserID, i.UserName, d.UserName, GETDATE(),'UPD' 
 
  FROM Deleted d INNER JOIN Inserted i ON d.UserID = i.UserID;

END

--update AppUser set UserName = 'tesupf123' where userid = 11

--select * from Appuser_History

--insert into AppUser values (11, 'TestTrig')

--drop trigger trg_testUpdate
--drop trigger trg_testInsert

CREATE TRIGGER trg_Insert_AppUser_History
ON AppUser
AFTER INSERT, DELETE--, UPDATE
AS
BEGIN
 INSERT INTO AppUser_History (UserID, UserName, ModifiedDate, Operation)
   
 SELECT i.UserID, i.UserName, GETDATE(),'INS' FROM INSERTED AS i
   
   UNION ALL

 SELECT d.UserID, d.UserName, GETDATE(),'DEL' FROM DELETED AS d



END


CREATE TRIGGER trg_Update_AppUser_History
ON AppUser
AFTER UPDATE
AS
BEGIN
 INSERT INTO AppUser_History (UserID, UserName, OldUserName, ModifiedDate, Operation)
   
 SELECT i.UserID, i.UserName, d.UserName, GETDATE(),'UPD' 
 
 FROM Deleted d INNER JOIN Inserted i ON d.UserID = i.UserID;
END


CREATE TRIGGER trg_Update_AppUser_History
ON AppUser
AFTER UPDATE
AS
BEGIN
 INSERT INTO AppUser_History (UserID, UserName, OldUserName, ModifiedDate, Operation)
   
 SELECT i.UserID, i.UserName, d.UserName, GETDATE(),'UPD' 
 
 FROM Deleted d INNER JOIN Inserted i ON d.UserID = i.UserID;
END



CREATE TRIGGER trg_CRUD_AppUser_History
ON AppUser
AFTER UPDATE
AS
BEGIN

 select 
  i.UserID, i.UserName, d.UserName Oldname, getdate(),
 case 
   when d.UserID is null then 'INS' 
   when d.UserID is not null and i.UserID is null then 'DEL'
   else 'UPD'
  end as Operation
  
 FROM Inserted i LEFT JOIN Deleted d ON i.UserID = d.UserID
 
 where d.UserID is null;
END

--insert into AppUser values(9, 'testtrigger1')
--insert into AppUser values (10, 'testtrigger2')

--delete from AppUser where UserID = 9

--update AppUser set Username  = 'testtrigger3' where UserID = 10

--select * from AppUser_History

--truncate table AppUser_History
--delete from AppUser where UserID = 10

/**Disable trigger**/
--DISABLE TRIGGER dbo.trg_InsteadOfInsert_User ON DATABASE;	

--ENABLE TRIGGER dbo.trg_InsteadOfInsert_User ON DATABASE;


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


insert into Item values (1, 2, 'test1')
insert into Item values (4, 4, 'test2')

CREATE TRIGGER trg_InsteadOfInsert_Item
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


USE Testing;

Create table Customer
(
  CustomerID BIGINT IDENTITY(1,1) NOT NULL Primary key,
  CustomerName VARCHAR(100) NOT NULL,
  PINCODE INT,
  City VARCHAR(200) NULL
)
GO

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
insert into Customer values('Mahesh', 111, 'JPR')
insert into Customer values('Mahesh', 000, NULL)

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

/*
AccountTransaction
User for username

SET Operations

*/

select * from AMS.[User];
select * from AMS.[AccountAnalytics]

update AMS.[User] set UserName = 'suraj' where UserID = 44;
update AMS.[User] set UserName = 'kappa' where UserID = 46;
--UNION operator
select UserName from ams.[User]
UNION
select UserName from ams.[AccountAnalytics]
order by UserName;

--INTERSECT operator
select UserName from ams.[User]
INTERSECT
select UserName from ams.[AccountAnalytics]
order by UserName;

--EXCEPT operator
select UserName from ams.[User]
EXCEPT
select UserName from ams.[AccountAnalytics]
order by UserName;

select UserName from ams.[AccountAnalytics]
EXCEPT
select UserName from ams.[User]
order by UserName;

--UNION ALL operator
select UserName from ams.[User]
UNION ALL
select UserName from ams.[AccountAnalytics]
order by UserName;




USE Testing;
GO

CREATE TABLE AppUser
(
 UserID INT PRIMARY KEY,
 Username NVARCHAR(MAX),
 CreatedDate DATETIME DEFAULT GETDATE()
);


CREATE TABLE [AppUser_History](
	[UserID] [int] NULL,
	[UserName] [varchar](250) NULL,
	[OldUserName] [varchar](250) NULL,
	[Operation] [varchar](3) NOT NULL,
	[ModifiedDate] DateTime NOT NULL,
	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
);
GO

-- INSERT Triger
create trigger trg_tappUserInsert
ON AppUser
AFTER INSERT
AS
BEGIN
  insert into [AppUser_History](UserID, UserName, ModifiedDate, Operation)
  SELECT i.UserID, i.UserName, getdate(), 'INS' from inserted i;
END

--Testing
INSERT INTO AppUser (UserID, Username) VALUES (1, 'Suraj');
INSERT INTO AppUser (UserID, Username) VALUES (2, 'Kappa');
INSERT INTO AppUser (UserID, Username) VALUES (3, 'Bhalu');

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;
-------------------------------------------------------------------------------------

--DELETE Trigger
create trigger trg_tappUserDelete
ON AppUser
AFTER DELETE
AS
BEGIN
  insert into [AppUser_History](UserID, UserName, ModifiedDate, Operation)
  SELECT d.UserID, d.UserName, getdate(), 'DEL' from deleted d;
END

--Testing
DELETE FROM AppUser where UserID=3;

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;
-------------------------------------------------------------------------------------

--UPDATE Trigger
create trigger trg_tappUserUpdate
ON AppUser
AFTER UPDATE
AS
BEGIN
  insert into [AppUser_History](UserID, UserName, OldUserName, ModifiedDate, Operation)
  SELECT i.UserID, i.UserName, d.UserName,  getdate(), 'UPD' from deleted d
  INNER JOIN Inserted i ON d.UserID = i.UserID
END

--Testing
UPDATE AppUser set Username = 'Chilika Kappa' where UserID = 2;

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;

----------------------------------------------------------

-- Combined trigger for INSERT, DELETE and UPDATE
CREATE TRIGGER trg_OnAppUser
ON AppUser
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
 insert into [AppUser_History](UserID, UserName, OldUserName, ModifiedDate, Operation)

 select i.UserID, i.UserName, NULL as OldName, getdate(), 'INS' from inserted i
  UNION ALL
 select d.UserID, d.UserName, NULL as OldName, getdate(), 'DEL' from Deleted d
 INTERSECT
 select i.UserID, i.UserName, d.Username as OldName, getdate(), 'UPD' from inserted i
 LEFT JOIN Deleted d on i.UserID =d.UserID;

 select i.UserID, i.UserName, 
 CASE 
   WHEN d.UserID IS NULL THEN 'INS'
   WHEN d.UserID IS NOT NULL AND i.UserID IS NULL THEN 'DEL'
   ELSE 'UPD'
 CASE

END

--Testing
INSERT INTO AppUser (UserID, UserName) Values (20, 'Nepal');
delete from AppUser where UserID = 20;
Update AppUser set Username = 'KIIT Kappa' where UserID = 10;
delete from AppUser where UserID = 5;

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;