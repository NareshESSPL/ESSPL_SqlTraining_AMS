--Resource procedure

/*
testing commenting work also in This way
*/

USE AccountManagementSystem
Go
/* creating the procedure*/

create procedure AMS.Proc_User_Insert
as begin 
	insert into AMS.[User](username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
	values('test','2009-09-24','2009-10-24',8999,688768988,986114149,'Vikash'),
	('test2','2009-09-24','2009-10-24',8999,688768988,986114149,'Vikash')
	end

exec AMS.Proc_User_Insert;

select * from AMS.[User]
go


/*Altering the procedure*/

alter Procedure AMS.Proc_User_Insert
@UserName	nvarchar(250),
@DOB	datetime,
@DOJ	datetime,
@Balance	decimal,
@AccountNo	int,
@MobileNo	int,
@CreatedBy varchar(255)
 as begin 
	INSERT INTO AMS.[User](username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
	values(@username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	end

	exec AMS.Proc_User_Insert 'testing','1999-09-07','1999-09-17',7777,8979879,985555142,'Jhon';

	select * from AMS.[User]
	go 

/*alter Procedure AMS.Proc_User_insert
@UserName	nvarchar(250),
@DOB	datetime,
@DOJ	datetime,
@Balance	decimal,
@AccountNo	int,
@MobileNo	int,
@CreatedBy varchar(250) = 'default user'
 as begin 
	INSERT INTO AMS.[User](username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
	values(@username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	end */
	 

create procedure AMS.Proc_UserAndAddress_Insert
	@UserName	nvarchar(250),
	@DOB	datetime,
	@DOJ	datetime,
	@Balance	decimal(10,6),
	@AccountNo	int,
	@MobileNo	int,
	@AddressDetail nvarchar(max),
	@CreatedBy varchar(250) = 'defaultuser'
	as begin 

		 declare @userId bigint

		 insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
		 values(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
	
	set @UserID = scope_identity()

	INSERT INTO AMS.[Address](UserId,AddressDetail,CreatedBy)
	values(@UserId,@AddressDetail,@CreatedBy)
	end

	exec  AMS.Proc_UserAndAddress_Insert 'Nitish','2008-09-16','2008-08-27',9999,87777009,9898,'hello','Brok'

	select * from AMS.[Address];
	
	select * from AMS.[User];

	delete from AMS.[Address] where CreatedBy= 'm';

	DROP PROCEDURE AMS.Proc_user_Insert;

	/*adding procedure for the Account table */

	create procedure AMS.Proc_All_Tables_Insert
		@UserName	nvarchar(250),
		@DOB	datetime,
		@DOJ	datetime,
		@Balance	decimal(10,6),
		@MobileNo	int,
		@AccountNo	int,
		@IsSaving   bit,
		@AddressDetail   nvarchar(250),
		@Amount    decimal(10,6),
		@IsDebit   bit,
		@CreatedBy	varchar(250)
	as begin

	declare @UserID	bigint

		INSERT INTO AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
		values(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
			
	set @UserID = scope_identity()

		INSERT INTO AMS.[Address](UserId,AddressDetail,CreatedBy)
		values(@UserId,@AddressDetail,@CreatedBy)

	declare @AccountID bigint

		INSERT INTO AMS.Account(AccountNo,IsSaving,CreatedBy)
		values(@AccountNo,@IsSaving,@CreatedBy)

	set @AccountID = scope_identity()

		INSERT INTO AMS.AccountTransaction(AccountID,Amount,IsDebit,CreatedBy)
		values(@AccountID,@Amount,@IsDebit,@CreatedBy)

		INSERT INTO AMS.UserAccountMapping(UserID,AccountID,CreatedBy)
		values(@UserID,@AccountID,@CreatedBy)
	end

	--Inserting values
	exec AMS.Proc_All_Tables_Insert 'Test1','2000-09-19','2000-10-20',4444,98611411,982767,0,'BBSR',3000,0,'me'
	
	exec AMS.Proc_All_Tables_Insert 'Test2','2001-09-19','2001-10-20',4444,98611411,982767,0,'BBSR',3000,0,'me'

	exec AMS.Proc_All_Tables_Insert 'Test3','2002-09-19','2002-10-20',4444,98611411,982767,0,'BBSR',3000,0,'me'
	
	exec AMS.Proc_All_Tables_Insert 'Test4','2003-09-19','2003-10-20',5555,98611411,982767,0,'CTC',3020,1,'me'
	
	exec AMS.Proc_All_Tables_Insert 'Test5','2004-09-19','2004-10-20',5555,98611411,982767,0,'CTC',3020,1,'me'


	select * from AMS.[User];
	select * from AMS.[Address];
	select * from AMS.Account;
	select * from AMS.UserAccountMapping;
	select * from AMS.AccountTransaction;
		
