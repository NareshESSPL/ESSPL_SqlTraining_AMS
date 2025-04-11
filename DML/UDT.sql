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
  insert into @buser values (1, 'test2', 987654322),
                            (2, 'test2', 987654322)

  select * from @buser
end