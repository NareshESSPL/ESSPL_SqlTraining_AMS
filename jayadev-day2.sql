use AccountManagement
go

sp_help 'AM.[UserAccountMapping]'
go
sp_help 'AM.[AccountTransaction]'
go
alter procedure AM.Proc_Userdetails_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
  insert into AM.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
  (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
end
go
EXEC AM.Proc_Userdetails_Insert 'user1', '2025-03-01', '2025-03-01', 600, 456, 1111, 'system';
EXEC AM.Proc_Userdetails_Insert 'user2', '2025-03-05', '2025-03-05', 700, 789, 2222, 'system';
EXEC AM.Proc_Userdetails_Insert 'user3', '2025-03-10', '2025-03-10', 800, 101, 3333, 'system';

go
select * from AM.[Address]
go
alter procedure AM.Proc_Addressdetail_Insert
   @UserName	nvarchar(250),
   @DOB	datetime,
   @DOJ	datetime,
   @Balance	decimal(10, 6),
   @AccountNo	int,
   @MobileNo	int,
   @AddressDetail	nvarchar(max),
   @CreatedBy	varchar(250) = 'defaultuser'
AS begin
    declare @UserID bigint
    insert into AM.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo,CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo,@CreatedBy)
    set @UserID = SCOPE_IDENTITY()
    INSERT INTO AM.[Address](UserID, AddressDetail, CreatedBy)
    VALUES (@UserID, @AddressDetail, @CreatedBy);
end
EXEC AM.Proc_Addressdetail_Insert  'user4', '2025-03-01', '2025-03-01', 600, 456, 1111,'bangalore';
EXEC AM.Proc_Addressdetail_Insert  'user3', '2025-03-01', '2025-03-01', 600, 456, 1111,'mumbai';
EXEC AM.Proc_Addressdetail_Insert  'user6', '2025-03-01', '2025-03-01', 600, 456, 1111,'hydrabad';

go
alter procedure AM.Proc_AccountDetail_Insert
    @AccountNo	int,
    @IsSaving   bit,
    @CreatedBy	varchar(250) = 'defaultuser'
AS BEGIN
   insert into AM.[Account] (AccountNo,IsSaving ,CreatedBy) values (@AccountNo,@IsSaving,@CreatedBy)

END

EXEC AM.Proc_AccountDetail_Insert 801,1
EXEC AM.Proc_AccountDetail_Insert 101,0
go
create procedure AM.Proc_UserAccountMapping_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @IsSaving   bit,
 @CreatedBy varchar(200) = 'defaultuser'

as begin
    declare @UserID bigint
	declare @AccountID bigint
    insert into AM.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo,CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo,@CreatedBy)
    set @UserID = SCOPE_IDENTITY()
    INSERT INTO AM.[Account](AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);
	set @AccountID = SCOPE_IDENTITY()
	INSERT INTO AM.[UserAccountMapping](UserID, AccountID, CreatedBy)
    VALUES (@UserID, @AccountID, @CreatedBy);
end

exec AM.Proc_UserAccountMapping_Insert 'esspluser', '2025-03-01', '2025-03-01', 680, 450, 1181,1

go
create procedure AM.AccountTransaction_Insert
 @Amount decimal,
 @AccountNo int,
 @IsSaving bit,
 @IsDebit  bit,
 @CreatedBy varchar(200) = 'defaultuser'

as begin
	declare @AccountID bigint
    INSERT INTO AM.[Account](AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);
	set @AccountID = SCOPE_IDENTITY()
	INSERT INTO AM.[AccountTransaction](AccountID, Amount, IsDebit, CreatedBy)
    VALUES (@AccountID, @Amount, @IsDebit,@CreatedBy);
end

exec AM.AccountTransaction_Insert 999,100,1,1

select name from sys.tables
select * from AM.AccountTransaction
select * from AM.[Account]
select * from AM.UserAccountMapping
select * from AM.[User]
select * from AM.[Address]