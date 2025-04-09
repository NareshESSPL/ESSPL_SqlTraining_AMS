USE [AccountManagementSystem]
GO

/*
   Created Date:
   Created By:
   Desc : 
*/
create procedure AMS.Proc_User_Insert
as begin
  insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
  ('test', '1997-02-02', '2025-02-02', 600, 12345, 987654, 'testUser'),
  ('test1', '1997-02-03', '2025-02-04', 700, 12345, 987654, 'testUser2')
end

exec AMS.Proc_User_Insert

select * from AMS.[User]
go

alter procedure AMS.Proc_User_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @CreatedBy	varchar(250)
as begin
  insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
  (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
end
go

EXEC AMS.Proc_User_Insert 'testing', '2025-02-02', '2025-02-02', 500, 123, 9876, 'testuser'
go

alter procedure AMS.Proc_User_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @CreatedBy	varchar(250) = 'defaultuser',
as begin
  insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
  (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
end

EXEC AMS.Proc_User_Insert 'testing', '2025-02-02', '2025-02-02', 500, 123, 9876


go

create procedure AMS.Proc_UserAndAddress_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @AddressDetail nvarchar(max),
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
    
   declare @UserId bigint

   insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

   set @UserId = scope_identity()

   insert into AMS.[Address](UserId, AddressDetail, CreatedBy) 
   values (@UserId, @AddressDetail, @CreatedBy)
end

EXEC AMS.Proc_UserAndAddress_Insert 'testing', '2025-02-02', '2025-02-02', 500, 123, 9876, 'test address'

select * from AMS.[User]
Select * from AMS.[Address]