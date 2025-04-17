create table TextExcep
(
 id int
)
insert into TextExcep values ('sadas')
go

BEGIN TRY
    insert into TextExcep values ('sadas')
END TRY

BEGIN CATCH
       print 'Exception happened'
END CATCH

-----------------lock table----------
create table ErrorLog
(
id bigint identity(1,1) primary key,
source varchar(100),
messsage nvarchar(max),
CreatedAt Datetime2,

)

----print getdate()
-------print getutcdate()-------------use in lock table
insert into TextExcep values ('sadas')
go

BEGIN TRY

begin tran
   INSERT INTO ItemType (itemTypeId, itemTypeName)  values (111,'testtype')
	 insert into Item(itemId,itemTypeId,itemName) values (199,'testtype')

commit tran
END TRY

BEGIN CATCH
rollback
print 'rolledback'

declare @Meassage Nvarchar(max)

select @Meassage =
'ERROR_NUMBER :' + cast(error_number() as nvarchar(200)) +
'ERROR_MESSAGE :' + error_message() +
'ERROR_SAVERITY :' + cast(error_severity() as nvarchar(200))+
 'ERROR_STATE :' + cast(error_state() as nvarchar(200))+
 'ERROR_LINE :' + cast(error_line() as nvarchar(200))


insert into ErrorLog values('Query',@Meassage,getutcdate())
       print 'Exception happened: PLZ REFERE ERROR LOG TABLE'
END CATCH

select * from Item
select * from ItemType

SELECT * FROM ErrorLog

----------------------------------------------------
create table ErrorLog
(
id bigint identity(1,1) primary key,
source varchar(100),
messsage nvarchar(max),
CreatedAt Datetime2,

)

----print getdate()
-------print getutcdate()-------------use in lock table
insert into TextExcep values ('sadas')
go

BEGIN TRY

begin tran
   INSERT INTO ItemType (itemTypeId, itemTypeName)  values (111,'testtype')
	 insert into Item(itemId,itemTypeId,itemName) values (199,'testtype')

commit tran
END TRY

BEGIN CATCH
rollback
print 'rolledback'

declare @Meassage Nvarchar(max)

select @Meassage =
'ERROR_NUMBER :' + cast(error_number() as nvarchar(200)) +
'ERROR_MESSAGE :' + error_message() +
'ERROR_SAVERITY :' + cast(error_severity() as nvarchar(200))+
 'ERROR_STATE :' + cast(error_state() as nvarchar(200))+
 'ERROR_LINE :' + cast(error_line() as nvarchar(200))


insert into ErrorLog values('Query',@Meassage,getutcdate())
       print 'Exception happened: PLZ REFERE ERROR LOG TABLE'
END CATCH

select * from Item
select * from ItemType

SELECT * FROM ErrorLog

----------------------------------------------------savepoint------------------------

