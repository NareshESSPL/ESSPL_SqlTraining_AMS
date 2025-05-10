Create Table AMS.AppUser(
UserId  int  identity (1,1) ,
UserName varchar(250)
);

INSERT into  AMS.AppUser values ('khushboo')
INSERT into  AMS.AppUser values ('zia')
INSERT into  AMS.AppUser values('dipu')

select * from AMS.AppUser



Create Table AMS.AppUser_History(

UserName varchar(250),
OldUserName varchar(100),
ModifiedDate DateTime ,
Operation  nvarchar(100)

check (operation='INS' or operation= 'DEL' or operation='UPD')
)
-----------------INSERT---after trigger----------------------
create trigger trg_testInsertion
on  AMS.AppUser
after insert
as
begin
insert into  AMS.AppUser_History(UserID,UserName,ModifiedDate,Operation)
select i.UserID,i.UserName,getDate(),'INS' from inserted i
end
 

-------------------DELETE----after trigger------------
create trigger trg_testDeletION
on  AMS.AppUser
after delete
as
begin
insert into  AMS.AppUser_History(UserID,UserName,ModifiedDate,Operation)
select d.UserID,d.UserName,getDate(),'DEL' from deleted d
end

-----------------------update-------after trigger---------------------
create trigger trg_testUpdatION
on  AMS.Appuser
after update
as 
begin
insert into AppUser_History(UserID,UserName,OldUserName,ModifiedDate,Operation)
select  i.UserId,i.UserName,D.UserName,getdate(),'UPD'
FROM deleted d inner join Inserted i on d.UserID=i.UserID;

END
---------------------insert,update,delete common trigger-----------after trigger-----------

create trigger trg_testCRUD_OPERATION
on  AMS.Appuser
after insert,delete,update
as 
begin
insert into AppUser_History(UserID,UserName,OldUserName,ModifiedDate,Operation)
select  i.UserId,i.UserName, NULL AS oldName,getdate(),'INS' from Inserted as i
union all
select  d.UserId,d.UserName, null as oldname, getdate(),'DEL' from Inserted as d
UNION ALL
select  i.UserId,i.UserName,D.UserName,getdate(),'UPD'
FROM deleted d inner join Inserted i on d.UserID=i.UserID;

END
-----------------------INsert--- instead of trigger ---------------
create trigger trg_CRUD
on  AMS.Appuser
instead of insert update
as 
begin
insert into AppUser_History(UserID,UserName,OldUserName,ModifiedDate,Operation)
select  i.UserId,i.UserName,D.UserName,getdate(),'UPD'
FROM deleted d inner join Inserted i on d.UserID=i.UserID;

END
-----------------------------------item code------------------------------

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

ALTER TRIGGER trg_InsteadOfInsert_Item
ON AMS.Item
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


------------- non unclustered index----------------
create nonclustered index IX_AccountAnalysis_Usename_DOB
on AMS.AccountAnalysis (UserName,DOB)

Select * from AMS.AccountAnalysis where UserName like '%et%' and DOB > getdate()

