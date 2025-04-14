alter proc AMS.TestSP
as
begin
  truncate table AMS.AccountTransaction
  
  truncate table AMS.UserAccountMapping
  
  delete from AMS.Account
  DBCC CHECKIDENT ('AMS.Account', RESEED, 0)
  
  truncate table AMS.[Address]
  
  delete from AMS.[User]
  DBCC CHECKIDENT ('AMS.[User]', RESEED, 0)


  declare 
    @UserName [nvarchar](250) = 'test',
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate();

  declare @count int = 0;
  
  WHILE @count < =1000
  BEGIN
  --Do not delete
  select @count = @count + 1

  insert into AMS.[User] ([UserName], [DOB], [DOJ], [Balance], [AccountNo], [MobileNo],[CreatedBy],[Created])
  values(@UserName + cast(@count as varchar),
         dateadd(month,1, @DOB), 
		 dateadd(day, -1, @DOJ),
		 @Balance + @count,
		 @AccountNo + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 )
  END

   select * from AMS.[User]
end