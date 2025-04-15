/*
Created By : Suraj Kumar Sah
DESC : Triggers Notes
*/
--CREATE TRIGGER InsertTrigger
--ON YourTableName
--AFTER INSERT
--AS
--BEGIN
--    -- Your custom logic here
--    PRINT 'A new record has been inserted!'
--END
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
