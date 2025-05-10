?USE [AccountManagementSystem];
GO
/****** Object:  StoredProcedure [AMS].[TestSP]    Script Date: 14-04-2025 11:40:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [AMS].[TestSP]
 @MaxCount BIGINT =1000
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
    @TempUserName [nvarchar](250) = 'test',
	@UserName [nvarchar](250),
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate(),
	@IsSaving BIT = 1,
	@Address NVARCHAR(MAX) = 'test add',
	@userID BIGINT,
	@AccountID BIGINT,
	@Amount [decimal](10, 6) = 10,
	@IsDebit BIT = 0;

  declare @count int = 0;
  
  WHILE @count < = @MaxCount
  BEGIN
  --Do not delete
  select @count = @count + 1

  set @DOB = dateadd(month,1, @DOB)
  set @UserName = @TempUserName + cast(@count as varchar)
  set @DOJ = dateadd(day, -1, @DOJ)
  set @AccountNo = @AccountNo + @count
  set @MobileNo = @MobileNo + @count

  insert into AMS.[User] ([UserName], [DOB], [DOJ], [AccountNo], [MobileNo],[CreatedBy],[Created])
  values(
         @UserName + cast(@count as varchar),
         @DOB, 
		 dateadd(day, -1, @DOJ),
		 @AccountNo + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 )
       
	   SET @UserID = SCOPE_IDENTITY();

        -- 2. Insert into Account_New
        INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
        VALUES (@AccountNo, @IsSaving, @CreatedBy);

        SET @AccountID = SCOPE_IDENTITY();

        -- 3. Insert into Address
        INSERT INTO AMS.[Address](UserID, AddressDetail, CreatedBy)
        VALUES (@UserID, @Address, @CreatedBy);

        -- 5. Insert into UserAccountMapping
        INSERT INTO AMS.[UserAccountMapping](UserID, AccountID, CreatedBy)
        VALUES (@UserID, @AccountID, @CreatedBy);

        -- 4. Insert into Acctransaction
        INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
        VALUES (@AccountID, @Amount, @IsDebit, @CreatedBy);
		
  END

   select * from AMS.[User]
   
   select * from AMS.[Address]
   
   select * from AMS.[Account]
   
   select * from AMS.[UserAccountMapping]
   
   select * from AMS.[AccountTransaction]

end