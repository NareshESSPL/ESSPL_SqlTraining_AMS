Create type AMS.PhoneNo from Varchar(10)


Create table STG_User
(
 userid int identity(1,1) primary key,
 username nvarchar(100),
 phoneNo AMS.PhoneNo
)

insert into STG_User values ( 'naresh', 123456890)

Create type AMS.BasicUser as table
(
 userid int identity(1,1) primary key,
 username nvarchar(100),
 phoneNo AMS.PhoneNo
)
go

--drop type AMS.BasicUser

create proc AMS.test_udt
as
begin
  declare @buser as AMS.BasicUser
  insert into @buser values ('test2', 987654322),
                            ('test2', 987654322)

  select * from @buser
end
go

Create type AMS.udt_Account as table
(
  AccountID BIGINT,
  AccountNo BIGINT
)
go

alter proc AMS.test_udt2
 @acountList AMS.udt_Account readonly
as
begin
  select * from @acountList
   --print 'hello'
end
go

declare @InputAccount AMS.udt_Account
insert into @InputAccount values(1111, 2222), (88888, 77777);
exec AMS.test_udt2 @acountList = @InputAccount
