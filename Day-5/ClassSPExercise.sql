/*
Created By : Suraj Kumar Sah
Desc : creating tables using 
*/
use AccountManagementSystem;
go
create schema test;
go;


Select * into test.[User] from AMS.[User];
Select * into test.[Account] from AMS.[Account];
Select * into test.[Address] from AMS.[Address];
Select * into test.[UserAccountMapping] from AMS.[UserAccountMapping]
Select * into test.[AccountTransaction] from AMS.[AccountTransaction];
go

sp_help 'test.[user]'
sp_help 'test.[account]'
sp_help 'test.[address]'
sp_help 'test.[accounttransaction]'
sp_help 'test.[USERaccountmapping]'
go

create proc AMS.TestSP
as
begin
  truncate table AMS.AccountTransaction;
  truncate table AMS.UserAccountMapping;
  
  delete from AMS.Account;
  DBCC CHECKIDENT ('AMS.Account', RESEED, 0)
  
  truncate table AMS.[Address]
  
  delete from AMS.[User]
  DBCC CHECKIDENT ('AMS.[User]', RESEED, 0)


  declare 
    @UserName [nvarchar](250) = 'test',
	@DOB [datetime] = dateadd(month, 1, cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate(),
	@AddressDetail nvarchar(max) = 'TestAddress';

  declare @count int = 0;
  
  WHILE @count < =1000
  BEGIN
  --Do not delete
  select @count = @count + 1

  -- Scope Identity
  	declare @Userid BIGINT, @Accountid BIGINT;

  insert into AMS.[User] ([UserName], [DOB], [DOJ], [Balance], [AccountNo], [MobileNo], [CreatedBy], [Created])
  values(@UserName + cast(@count as varchar),
         dateadd(month,1, @DOB), 
		 dateadd(day, -1, @DOJ),
		 @Balance + @count,
		 @AccountNo + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 );
	set @Userid = SCOPE_IDENTITY();

	insert into AMS.[Address] ([Userid], [AddressDetail], [CreatedBy], [Created])
  values(
         @Userid,
		 @AddressDetail,
		 @CreatedBy,
		 @Created
		 );
  END

 select * from AMS.[User]
 select * from AMS.[Address]

end

exec test.TestSP
