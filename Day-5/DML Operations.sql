/*
Created By : Suraj Kumar Sah
DML Operations
*/

/*
Inserting Data into the Table
*/

sp_help 'ams.[user]'
sp_help 'ams.[address]'
sp_help 'ams.[account]'
sp_help 'ams.[useraccountmapping]'
sp_help 'ams.[accounttransaction]'
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
use testing
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

-- Executing the Stored Procedure
EXEC [AMS].[TestSP]
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

/*
  Query
*/

select * from ams.[user];

declare 
 @dob [datetime] = dateadd(month, 1, cast('1970-01-01' as Date))

print @dob
----------------------
declare @date datetime

-- to find user id and age
declare 
SELECT
    UserID,
    CASE
        WHEN MONTH(GETDATE()) > MONTH(dob) OR (MONTH(GETDATE()) = MONTH(dob) AND DAY(GETDATE()) >= DAY(dob))
        THEN DATEDIFF(YEAR, dob, GETDATE())
        ELSE DATEDIFF(YEAR, dob, GETDATE()) - 1
    END AS Age
FROM
    AMS.[User];

----------------
SELECT
    UserID,
    CASE
        WHEN DATEDIFF(YEAR, dob, GETDATE()) between 10 and 20 THEN 'A'
        WHEN DATEDIFF(YEAR, dob, GETDATE()) between 20 and 30 THEN 'B'
        WHEN DATEDIFF(YEAR, dob, GETDATE()) between 30 and 40 THEN 'C'
		WHEN DATEDIFF(YEAR, dob, GETDATE()) > 40 THEN 'D'
        ELSE 'Invalid Age'
    END AS AgeGroup, DOB, DATEDIFF(YEAR, dob, GETDATE()) AS Age
FROM
    AMS.[User]
	order by AgeGroup asc;
GO

----- Using Subquery
select distinct
 case
   when Age > 10 and Age < 20 then 'A'
   when age > 20 and age < 30 then 'B'
   when age > 30 and age < 40 then 'C'
   when age > 40 then 'D'
   else 'Invalid Age' 
end as AgeGroup
from
   (Select userid, DATEDIFF(YEAR, dob, GETDATE()) as Age, dob from ams.[User])
   AS x;
Go
--------------
--Other Way
select userid, dob, 
case
   when DATEDIFF(YEAR, dob, GETDATE()) > 10 and DATEDIFF(YEAR, dob, GETDATE()) < 20 then 'A'
   when DATEDIFF(YEAR, dob, GETDATE()) > 20 and DATEDIFF(YEAR, dob, GETDATE()) < 30 then 'B'
   when DATEDIFF(YEAR, dob, GETDATE()) > 30 and DATEDIFF(YEAR, dob, GETDATE()) < 40 then 'C'
   when DATEDIFF(YEAR, dob, GETDATE()) > 40 then 'D'
   else 'Invalid Age' 
end as AgeGroup
   from ams.[User]
Go
----------------------------------
-- Find the Average Balance

select avg(balance) AverageBalance, AgeGroup from(
select u.userid, u.dob, a.balance, 
case
   when DATEDIFF(YEAR, dob, GETDATE()) > 10 and DATEDIFF(YEAR, dob, GETDATE()) < 20 then 'A'
   when DATEDIFF(YEAR, dob, GETDATE()) > 20 and DATEDIFF(YEAR, dob, GETDATE()) < 30 then 'B'
   when DATEDIFF(YEAR, dob, GETDATE()) > 30 and DATEDIFF(YEAR, dob, GETDATE()) < 40 then 'C'
   when DATEDIFF(YEAR, dob, GETDATE()) > 40 then 'D'
   else 'Invalid Age' 
end AgeGroup
   from ams.[User]  u  
JOIN AMS.[UserAccountMapping] am on u.userid = am.userid
JOIN AMS.[Account] a on am.AccountID = a.AccountID)
as x group by x.AgeGroup;
   
GO
------------------------------------------------
