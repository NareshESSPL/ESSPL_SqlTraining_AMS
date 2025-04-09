create procedure AMS_Proc_Table_Design
@UserName NVARCHAR(250),
@DOB DATETIME,
@DOJ	DATETIME,
@Balance DECIMAL(10, 6),
@AccountNo	INT,
@MobileNo	INT,
@Address NVARCHAR(MAX),
@IsSaving BIT,
@Amount DECIMAL(10,6),
@IsDebit BIT,
@CreatedBy VARCHAR(250) = 'defaultuser'

as begin
 declare @UserID BIGINT
 declare @Account BIGINT

 insert into [AMS].[User] (UserName, DOB, DOJ, Balance, MobileNo, CreatedBy) values (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

 set @UserID = scope_identity()
 set @AccountID = scope_identity()

 insert into [AMS].[Account](AccountNo, IsSaving, CreatedBy)
   values(@AccountNo, @IsSaving, @CreatedBy)

 insert into [AMS].[Address](UserID,Address,CreatedBy) 
   values (@UserId,@Address, @CreatedBy)

 insert into [AMS].[UserAccountMapping](UserID, AccountID, CreatedBy)
   values(@UserID, @AccountID, @CreatedBy)

 insert into [AMS].[AccountTransaction]( Amount, IsDebit, CreatedBy)
   values( @Amount, @IsDebit, @CreatedBy)

end

exec AMS_Proc_Table_Design 'Anubhab', '2000-09-25', '2020-03-11', 12345, 8765, 'BBSR', 1, 5000, 1
exec AMS_Proc_Table_Design 'Sweta', '2002-09-25', '2023-03-12', 12333, 8965, 'BBSR', 1, 5000, 1
exec AMS_Proc_Table_Design 'Biru', '2010-09-25', '2025-04-11', 12395, 8715, 'BBSR', 1, 5000, 1

select * from [AMS].[User]
select * from [AMS].[Account]
select * from [AMS].[Address]
select * from [AMS].[UserAccountMapping]
select * from [AMS].[AccountTransaction]






