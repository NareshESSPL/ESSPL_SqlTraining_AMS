create procedure AMS.Proc_UserAndAll_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @AddressDetail nvarchar(max),
 @IsSaving bit,
 @Amount decimal(20,2),
 @IsDebit bit,
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
    
   declare @UserID bigint
   declare @AccountID bigint

   insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

   set @UserId = scope_identity()

   insert into AMS.[Address](UserId, AddressDetail, CreatedBy) 
   values (@UserId, @AddressDetail, @CreatedBy)

   INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
   VALUES(@AccountNo, @IsSaving, @CreatedBy)

   set @AccountID = SCOPE_IDENTITY()

   INSERT INTO AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
   VALUES(@UserID, @AccountID, @CreatedBy)
   
   INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
   VALUES(@AccountID, @Amount, @IsDebit, @CreatedBy)
end

exec AMS.Proc_UserAndAll_Insert 'khusu', '2003-08-05', '2022-08-23', 8000.0, 16785678, 88264321, 'Goa', 1, 3000.0, 0;

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.Account;
SELECT * FROM AMS.UserAccountMapping;
SELECT * FROM AMS.AccountTransaction;