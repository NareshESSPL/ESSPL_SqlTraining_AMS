--USING THE EXISTED DATABASE
use [AccountManagementSystem]
go

--CREATING SP FOR ALL 5 TABLES INPUT
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

--USING SP FOR ALL 5 TABLES INPUT
exec AMS.Proc_UserAndAllOtherTables_Insert 'wAM', '1990-02-02', '2025-02-02', 580,  69876, 'BBSR', 1234, 0, 50.00, 0
exec AMS.Proc_UserAndAllOtherTables_Insert 'ZAM', '1995-02-02', '2025-08-02', 700,  876276, 'BBSR', 5674, 0, 100.00, 0

--CREATING SP FOR ALL 5 TABLES SELECT
create procedure AMS.Proc_SelectallTables
as begin
	select * from AMS.[User]
	select * from AMS.[Address]
	select * from AMS.[UserAccountMapping]
	select * from AMS.[AccountTransaction]
	select * from AMS.[Account]
end

--USING SP FOR ALL 5 TABLES SELECT
exec AMS.Proc_SelectallTables

--FINDING USERS WHO DONT HAVE ACCOUNT WITH JOIN
select a.*
from AMS.[User] AS a
LEFT JOIN AMS.UserAccountMapping as b on a.UserID = b.UserID
where b.UserID IS NULL;

--FINDING USERS WHO DONT HAVE ACCOUNT WITH SUBQUERY
select *
from AMS.[User]
where UserID NOT IN (
    select distinct UserID
    from AMS.UserAccountMapping
);

--FINDING USER,ACCOUNT DETAILS WHOSE AVERAGE SALARY MORE THAN 500
select 
    u.UserID, u.UserName, a.AccountID, a.AccountNumber, AVG(at.Amount) AS AvgSalary
	from AMS.[User] u
	JOIN AMS.UserAccountMapping uam 
		on u.UserID = uam.UserID
	JOIN AMS.Account a 
		on uam.AccountID = a.AccountID
	JOIN AMS.AccountTransaction AS at 
		on a.AccountID = at.AccountID
group by u.UserID, u.UserName, a.AccountID, a.AccountNumber
having AVG(at.Amount) > 500;