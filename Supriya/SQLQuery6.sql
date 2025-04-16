use AccountManagementSystem

/*create table testMergeSource
(
  id int identity(1,1) primary key,
  name varchar(200)
)


create table testMergeTarget
(
  id int identity(1,1) primary key,
  name varchar(200),
  CreatedDate DateTime,
)

select * from testMergeTarget 

insert into testMergeSource values ('naresh')

insert into testMergeSource values ('suresh')

insert into testMergeSource values ('mahesh')


MERGE testMergeTarget t
 USING testMergeSource s ON s.id= t.id

WHEN MATCHED
    THEN UPDATE SET 
        t.name = s.name

WHEN NOT MATCHED BY TARGET
    THEN INSERT (name) values (s.name)

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;*/




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
go


--triggers (AFTER)
create table AMS.AppUser(
   UserId int identity(1,1),
   UserName nvarchar(100)
)

create table AMS.AppUser_Hstory(
   UserId int,
   UserName nvarchar(100),
   OldUserName nvarchar(100),
   ModifiedDate datetime,
   Operation nvarchar(100)

   check (Operation = 'INS' or Operation =  'DEL' or Operation = 'UPD')
)

insert into AMS.AppUser values ('utam')
go

/*drop trigger AMS.trg_testInsert
on AMS.AppUser
after insert 
as begin
   insert into AMS.AppUser_Hstory(UserId,UserName,ModifiedDate,Operation)
   select i.UserId,i.UserName,getDate(),'INS' from inserted i
end*/

delete from AMS.AppUser where userId = 7

update AMS.AppUser set UserName = 'subha' where UserId = 7
select * from AMS.AppUser
select * from AMS.AppUser_Hstory

alter trigger AMS.trg_CRUD_OnAppUser
on AMS.AppUser
after insert,delete,update 
as begin
   --insert
   if exists (select * from inserted) and not exists (select * from deleted) 
   begin 
     insert into AMS.AppUser_Hstory(UserId,UserName,OldUserName,ModifiedDate,Operation)
     select i.UserId,i.UserName,null,getDate(),'INS' from inserted i
   end

   --delete
   if exists (select * from deleted) and not exists (select * from inserted) 
   begin
      insert into AMS.AppUser_Hstory(UserId,UserName,OldUserName,ModifiedDate,Operation)
      select d.UserId,d.UserName,null,getdate(),'DEL' from deleted d
   end

   --update
   if exists (select * from inserted) and exists (select * from deleted) 
   begin
      insert into AMS.AppUser_Hstory(UserId,UserName,OldUserName,ModifiedDate,Operation)
      select i.UserId,i.UserName,d.UserName, GETDATE(),'UPD' from(
        deleted d join inserted i on i.UserId = d.UserId
      )
   end
end



--triggers (INSTED OF)
create table AMS.ItemType
(
  ItemTypeId int not null primary key,
  itemTypeName varchar(100) not null
)

create table AMS.Item
(
  ItemId int not null primary key,
  ItemTypeId int not null foreign key references AMS.ItemType(ItemTypeId),
  ItemName varchar(100) not null
)


insert into AMS.Item values (3,2, 'test2')

create TRIGGER AMS.trg_InsteadOfInsert_Item
ON AMS.Item
INSTEAD OF INSERT
AS
BEGIN
    IF NOT EXISTS(SELECT TOP 1 ItemTypeId  FROM AMS.ItemType)
	BEGIN

	  INSERT INTO AMS.ItemType (ItemTypeId, itemTypeName) 
	  SELECT i.ItemTypeId, 'UNKNOWN' FROM INSERTED i 

	END
	
	  INSERT INTO AMS.Item (ItemID, ItemTypeId, ItemName) 
	  SELECT i.ItemID, i.ItemTypeId, i.ItemName FROM INSERTED i 
	  	   
END

select * from AMS.Item
select * from AMS.ItemType




--non clustered index
create nonclustered index idx_AcAnalysis_UName_DOB
on AMS.AccountAnalysis (UserName,DOB)

select * from AMS.AccountAnalysis where UserName like '%tes%'


