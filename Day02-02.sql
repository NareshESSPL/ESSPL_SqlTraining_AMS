use AccountManagementSystem
go 

Create Procedure AMS.Proc_All_Table
@UserName nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal(10,6),
@AccountNo int,
@IsSaving bit,
@MobileNo int,
@Address nvarchar(max),
@Amount Decimal(10,6),
@IsDebit bit,
@CreatedBy varchar(250) ='defaultUser'

as begin

declare @userID bigint
declare @AccountID bigint

insert into AMS.[User](UserName,DOB,DOJ,Balance,MobileNo,CreatedBy) values
(@UserName, @DOB, @DOJ, @Balance, @MobileNo, @CreatedBy)

set @UserID = SCOPE_IDENTITY()
set @AccountID = SCOPE_IDENTITY()

insert into [Account] (AccountNo,IsSaving,CreatedBy)
values(@AccountNo,@IsSaving,@CreatedBy)

insert into AMS.[UserAccountMapping] (UserID,AccountID,CreatedBy)
values (@UserID,@AccountID,@CreatedBy)

end
 exec AMS.Proc_All_Table 'testing', '2025-02-02','2025-02-02', 500, 123,1, 9845,'test address', 600,1

 select*from[User];
 select*from[Account];
 select*from[UserAccountMapping];