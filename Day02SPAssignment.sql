use [AccountManagementSystem]
go

create procedure AMS.Proc_User_Insert
as begin
  insert into AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance,  MobileNumber, CreatedBy) values
  ('NAM', '1990-02-02', '2025-02-02', 600, 945624, 'Admin'),
  ('TAM', '1990-02-03', '2025-02-04', 700, 956421, 'Admin')
end

exec AMS.Proc_User_Insert

select * from AMS.[User]
go

alter procedure AMS.Proc_User_Insert
 @UserName	nvarchar(250),
 @DateOfBirth	datetime,
 @DateOfJoining	datetime,
 @Balance	decimal(10, 6),
 @MobileNumber	int,
 @CreatedBy	varchar(250)
as begin
  insert into AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance,  MobileNumber, CreatedBy) values
  (@UserName, @DateOfBirth, @DateOfJoining, @Balance, @MobileNumber, @CreatedBy)
end
go

exec AMS.Proc_User_Insert 'YAM', '1990-02-02', '2025-02-02', 500, 8465246, 'Admin'
go

alter procedure AMS.Proc_User_Insert
 @UserName	nvarchar(250),
 @DateOfBirth	datetime,
 @DateOfJoining	datetime,
 @Balance	decimal(10, 6),
 @MobileNumber	int,
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
  insert into AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance,  MobileNumber, CreatedBy) values
  (@UserName, @DateOfBirth, @DateOfJoining, @Balance, @MobileNumber, @CreatedBy)
end

exec AMS.Proc_User_Insert 'QAM', '1990-02-02', '2025-02-02', 500, 9852462


go

create procedure AMS.Proc_UserAndAddress_Insert
 @UserName	nvarchar(250),
 @DateOfBirth	datetime,
 @DateOfJoining	datetime,
 @Balance	decimal(10, 6),
 @MobileNumber	int,
 @FullAddress nvarchar(max),
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
    
   declare @UserId bigint

   insert into AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance,  MobileNumber, CreatedBy) values
  (@UserName, @DateOfBirth, @DateOfJoining, @Balance, @MobileNumber, @CreatedBy)

   set @UserId = scope_identity()

   insert into AMS.[Address](UserId, FullAddress, CreatedBy) 
   values (@UserId, @FullAddress, @CreatedBy)
end

exec AMS.Proc_UserAndAddress_Insert 'EAM', '1990-02-02', '2025-02-02', 580,  69876, 'BBSR'

select * from AMS.[User]
select * from AMS.[Address]

create procedure AMS.Proc_UserAndAllOtherTables_Insert
 @UserName	nvarchar(250),
 @DateOfBirth	datetime,
 @DateOfJoining	datetime,
 @Balance	decimal(10, 6),
 @MobileNumber	int,
 @FullAddress nvarchar(max),
 @AccountNumber int,
 @IsSaving int,
 @Amount decimal(10,6),
 @IsDebit bit,
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
    
   declare @UserId bigint
   declare @AccountID bigint

   insert into AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance,  MobileNumber, CreatedBy) values
  (@UserName, @DateOfBirth, @DateOfJoining, @Balance, @MobileNumber, @CreatedBy)

   set @UserId = scope_identity()

   insert into AMS.[Address](UserId, FullAddress, CreatedBy) 
   values (@UserId, @FullAddress, @CreatedBy)
   insert into AMS.[Account](AccountNumber, IsSaving, CreatedBy)
   values(@AccountNumber, @IsSaving, @CreatedBy)

   set @AccountID = scope_identity()

   insert into AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
   values(@UserID, @AccountID, @CreatedBy)
   
   insert into AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
   values(@AccountID, @Amount, @IsDebit, @CreatedBy)
end

exec AMS.Proc_UserAndAllOtherTables_Insert 'wAM', '1990-02-02', '2025-02-02', 580,  69876, 'BBSR', 1234, 0, 50.00, 0

select * from AMS.[User]
select * from AMS.[Address]
select * from AMS.[UserAccountMapping]
select * from AMS.[AccountTransaction]
select * from AMS.[Account]
