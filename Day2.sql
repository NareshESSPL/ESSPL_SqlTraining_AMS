insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
values
	('Soumya Ranjan Patra','2002-04-01 04:50:00','2025-04-03 09:50:00',180,359,565,'Soumya'),
	('Jaydev Patra','2002-09-01 04:50:00','2025-04-03 09:50:00',800,879,879,'Soumya');
	go
select * from AMS.[User];
go
sp_help 'AMS.Account';
insert into AMS.[Account](AccountNo,IsSaving,CreatedBy)
values
	(180,0,'Soumya'),
	(181,1,'Soumya');
sp_rename 'AMS.Account.CreatedDate','Created','COLUMN';
alter table AMS.Account 
add constraint df_account_id default getdate() for Created;
select * from AMS.Account;

dbcc checkdb ('AccountManagementSystem');
go
dbcc help ('checkdb');
go

create procedure AMS.Proc_User_Insert
as begin 
	insert into AMS.[User](Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy )values ('test','2002-08-25','2025-03-11',1780.0000,343,356,'admin');
end
exec AMS.Proc_User_Insert
select * from AMS.[User];
go
alter procedure AMS.Proc_User_Insert
	@UserName nvarchar(250),
	@DOB datetime,
	@DOJ datetime,
	@Balance decimal,
	@AccountNo int,
	@MobileNo int,
	@CreatedBy varchar(250) = 'defaultuser'
as begin
	insert into AMS.[User](Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values (@Username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	end
exec AMS.Proc_User_Insert 'testing','1999-01-01','1999-01-05',300,234,564

exec sp_help 'AMS.Proc_User_Insert';
exec sp_help 'AMS.[Address]';
create procedure AMS.Proc_UserAddress_Insert
	@UserName Nvarchar(250),
	@DOB datetime,
	@DOJ datetime,
	@Balance decimal,
	@AccountNo int,
	@MobileNo int,
	@AddressDetail nvarchar(max),
	@CreatedBy varchar(250) = 'defaultuser'
as begin
	declare @UserId Bigint
	insert into AMS.[User](Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values (@Username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	set @UserId = SCOPE_IDENTITY()
	insert into AMS.[Address](UserId,AddressDetail,CreatedBy) values (@UserId,@AddressDetail,@CreatedBy)
	
end

exec AMS.Proc_UserAddress_Insert 'testing1','1999-01-02','1999-02-05',300,234,564,'sbp'

select * from AMS.[Address]
select * from AMS.[User]

create procedure AMS.Proc_UserAccount_Insert
	@UserName nvarchar(250),
	@DOB datetime,
	@DOJ datetime,
	@Balance decimal,
	@AccountNo int,
	@IsSaving bit,
	@MobileNo int,
	@CreatedBy varchar(250) = 'defaultuser'
as begin
	declare @UserId Bigint
	insert into AMS.[User](Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values (@Username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	set @UserId = SCOPE_IDENTITY()
	insert into AMS.[Account](AccountNo,IsSaving,CreatedBy) values (@AccountNo,@IsSaving,@CreatedBy)
	
end
exec sp_help 'AMS.[Account]';
go
exec AMS.Proc_UserAccount_Insert 'testing2','1999-01-02','1999-02-05',300,234,564,1
select * from AMS.[Account]
go

select * from sys.tables;
go

Alter procedure AMS.Proc_UserAccountTransaction_Insert
	@Amount decimal,
	@IsDebit bit,
	@AccountNo int,
	@IsSaving bit,
	@CreatedBy varchar(250) = 'defaultuser'
as begin
	
	declare @AccountId Bigint
	insert into AMS.[Account](AccountNo,IsSaving,CreatedBy) values (@AccountNo,@IsSaving,@CreatedBy)
	set @AccountId= SCOPE_IDENTITY()
	insert into AMS.[AccountTransaction](AccountId,Amount,IsDebit,CreatedBy) values (@AccountId,@Amount,@IsDebit,@CreatedBy)
	
end
exec sp_help 'AMS.[AccountTransaction]';
exec AMS.Proc_UserAccountTransaction_Insert 201,1,333,1
select * from AMS.AccountTransaction;
select * from AMS.Account

select * from AMS.[User]
go

select * from sys.tables;
go

exec sp_help 'AMS.[UserAccountMapping]';
create procedure AMS.Proc_UserAccountMapping_Insert
	@UserName nvarchar(250),
	@DOB datetime,
	@DOJ datetime,
	@Balance decimal,
	@AccountNo int,
	@MobileNo int,
	@IsSaving bit,
	@CreatedBy varchar(250) = 'defaultuser'
as begin
	declare @UserID bigint
	declare @AccountID bigint
	insert into AMS.[User](Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values (@Username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	set @UserID = SCOPE_IDENTITY()
	insert into AMS.[Account](AccountNo,IsSaving,CreatedBy) values (@AccountNo,@IsSaving,@CreatedBy)
	set @AccountId= SCOPE_IDENTITY()
	insert into AMS.UserAccountMapping (UserID,AccountID,CreatedBy) values (@UserID,@AccountID,@CreatedBy)
end
exec AMS.Proc_UserAccountMapping_Insert 'test4','2002-01-04','2025-01-04',354,333,888,1
select * from AMS.UserAccountMapping
select * from AMS.Account
select * from AMS.[User]