
alter PROCEDURE  AMS.proc_User_Insert
@UserName nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal(10,6),
@AccountNo int,
@MobileNo int,
@AddressDetail nvarchar(max),
@IsSaving Bit,
@Amount DECIMAL(10,6),
@IsDebit BIT,
@CreatedBy varchar(250) = 'defaultuser'
as begin
	declare @userID bigint
	declare @AccountID bigint

	insert into AMS.[User] (UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
	values(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	set @userID =SCOPE_IDENTITY()
	
	insert into AMS.Address (UserID,AddressDetail,CreatedBy)
	values(@userID,@AddressDetail,@CreatedBy)

	insert into AMS.Account(AccountNo,IsSaving,CreatedBy)
	values(@AccountNo,@IsSaving,@CreatedBy)

	set @AccountID=SCOPE_IDENTITY()

	insert into AMS.UserAccountMapping(UserID,AccountID,CreatedBy)
	values(@userID,@AccountID,@CreatedBy)

	insert into AMS.AccountTransaction(AccountID,Amount,IsDebit,CreatedBy)
	values(@AccountID,@Amount,@IsDebit,@CreatedBy)

end
go


exec AMS.proc_User_Insert 'test1','2025-02-02','2025-02-02',1.00,34,14,'testaddress',1,10.0,0
go
exec AMS.proc_User_Insert 'test2','2025-02-02','2025-02-02',1.00,35,14,'testaddress',1,10.0,0
go
exec AMS.proc_User_Insert 'test3','2025-02-02','2025-02-02',1.00,36,14,'testaddress',1,10.0,0
go
exec AMS.proc_User_Insert 'test4','2025-02-02','2025-02-02',1.00,37,14,'testaddress',1,10.0,0
go
exec AMS.proc_User_Insert 'test5','2025-02-02','2025-02-02',1.00,38,14,'testaddress',1,10.0,0
go
exec AMS.proc_User_Insert 'test6','2025-02-02','2025-02-02',1.00,39,14,'testaddress',1,10.0,0
go

select * from AMS.[User]
go

select * from AMS.Address
go

select * from AMS.Account
go

select * from AMS.UserAccountMapping
go

select * from AMS.AccountTransaction
go