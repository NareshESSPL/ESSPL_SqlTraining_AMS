USE AccountManagementSystem
GO

CREATE FUNCTION AMS.GetFinalBill
(
	@Invoice FLOAT
)
RETURNS FLOAT
AS
BEGIN
	RETURN @Invoice * 0.18 + @Invoice * 0.02
END

ALTER FUNCTION AMS.GetFinalBill
(
	@Invoice FLOAT
)
RETURNS FLOAT
AS
BEGIN
	RETURN @Invoice * 0.18 + @Invoice * 0.02
END

PRINT AMS.GetFinalBill(100)

---------------------------INCLASS ASSIGNMENT------------------------------

CREATE TYPE AMS.AccountIdandNo AS TABLE
(
	AccountID VARCHAR(50),
    AccountNo VARCHAR(50)
)
GO

CREATE FUNCTION AMS.GetAccountInfo
(
	@Input VARCHAR(100)
)
RETURNS AMS.AccountIdandNo
AS
BEGIN
	DECLARE @Parsed TABLE (Pair NVARCHAR(100));
	DECLARE @buser AS AMS.AccountIdandNo

    INSERT INTO @Parsed (Pair)
    SELECT LTRIM(RTRIM(value))
    FROM STRING_SPLIT(@Input, ',');

    INSERT INTO @buser (AccountID, AccountNo)
    SELECT 
        LTRIM(RTRIM(SUBSTRING(Pair, 1, CHARINDEX(':', Pair) - 1))),
        LTRIM(RTRIM(SUBSTRING(Pair, CHARINDEX(':', Pair) + 1, LEN(Pair))))
    FROM @Parsed
    WHERE CHARINDEX(':', Pair) > 0;

	
END
---------------------------------------------INCLASS ASSIGNMENT 02-----------------------------------------------------------------
--------------------------------------to Insert 1000 Test Users with All Related Data TO USER TABLE USING SP----------------
alter proc AMS.Proc_User_Insert
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
 	@DateOfBirth [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
 	@DateOfJoining [datetime] = getdate(),
 	@Balance [decimal](10, 6) = 1000,
 	@MobileNumber [int] = 12345,
 	@CreatedBy [varchar](250) = 'testdata',
 	@CreatedDate [datetime] = getdate();
 
   declare @count int = 0;
   
   WHILE @count < =1000
   BEGIN
   --Do not delete
   select @count = @count + 1
 
   insert into AMS.[User] ([UserName], [DateOfBirth], [DateOfJoining], [Balance], [MobileNumber],[CreatedBy], [CreatedDate])
   values(@UserName + cast(@count as varchar),
          dateadd(month,1, @DateOfBirth), 
 		 dateadd(day, -1, @DateOfJoining),
 		 @Balance + @count,
 		 @MobileNumber + @count,
 		 @CreatedBy,
		 @CreatedDate
 		 )
   END
 end;
 exec AMS.Proc_User_Insert;
 select * from AMS.[User]
--------------------------------------to Insert 1000 Test Users with All Related Data TO ALL TABLE USING SP----------------
ALTER PROCEDURE AMS.Proc_UserAndAllOtherTables_Insert
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE AMS.AccountTransaction;
    TRUNCATE TABLE AMS.UserAccountMapping;

    DELETE FROM AMS.Account;
    DBCC CHECKIDENT ('AMS.Account', RESEED, 0);

    TRUNCATE TABLE AMS.[Address];

    DELETE FROM AMS.[User];
    DBCC CHECKIDENT ('AMS.[User]', RESEED, 0);
    IF OBJECT_ID('AMS.MergedUserInfo') IS NOT NULL
    BEGIN
        DELETE FROM AMS.MergedUserInfo;
        DBCC CHECKIDENT ('AMS.MergedUserInfo', RESEED, 0);
    END
    DECLARE 
        @UserName NVARCHAR(250) = 'testuser',
        @DateOfBirth DATETIME = DATEADD(MONTH, 1, CAST('1970-01-01' AS DATE)),
        @DateOfJoining DATETIME = GETDATE(),
        @Balance DECIMAL(10, 6) = 1000,
        @MobileNumber INT = 10000,
        @FullAddress NVARCHAR(MAX) = '123 Test Street, Test City',
        @AccountNumber INT = 1000,
        @IsSaving INT = 1,
        @Amount DECIMAL(10, 6) = 500.00,
        @IsDebit BIT = 0,
        @CreatedBy VARCHAR(250) = 'testdata',
        @CreatedDate DATETIME = GETDATE();

    DECLARE 
        @count INT = 1,
        @UserId BIGINT,
        @AccountID BIGINT;

    
    WHILE @count <= 1000
    BEGIN
        set @DateOfBirth = dateadd(month,1, @DateOfBirth)
		set @DateOfJoining = dateadd(day, -1, @DateOfJoining)
		set @AccountNumber = @AccountNumber + @count
		set @MobileNumber = @MobileNumber + @count
		-- Insert into User
        INSERT INTO AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy, CreatedDate)
        VALUES (
            @UserName + CAST(@count AS VARCHAR),
            @DateOfBirth,
            DATEADD(DAY, -1, @DateOfJoining),
            @Balance + @count,
            @MobileNumber + @count,
            @CreatedBy,
            @CreatedDate
        );

        SET @UserId = SCOPE_IDENTITY();

        -- Insert into Address
        INSERT INTO AMS.[Address](UserId, FullAddress, CreatedBy)
        VALUES (@UserId, @FullAddress + ' #' + CAST(@count AS VARCHAR), @CreatedBy);

        -- Insert into Account
        INSERT INTO AMS.[Account](AccountNumber, IsSaving, CreatedBy)
        VALUES(@AccountNumber + @count, @IsSaving, @CreatedBy);

        SET @AccountID = SCOPE_IDENTITY();

        -- Insert into Mapping
        INSERT INTO AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
        VALUES(@UserId, @AccountID, @CreatedBy);

        -- Insert into Transaction
        INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
        VALUES(@AccountID, @Amount + @count, @IsDebit, @CreatedBy);

        -- Optional: Insert into merged table
        INSERT INTO AMS.MergedUserInfo (
            UserId, UserName, DateOfBirth, DateOfJoining, Balance,
            MobileNumber, FullAddress, AccountID, AccountNumber,
            IsSaving, Amount, IsDebit, CreatedBy
        )
        SELECT 
            u.UserId,
            u.UserName,
            u.DateOfBirth,
            u.DateOfJoining,
            u.Balance,
            u.MobileNumber,
            a.FullAddress,
            acc.AccountId,
            acc.AccountNumber,
            acc.IsSaving,
            t.Amount,
            t.IsDebit,
            u.CreatedBy
        FROM AMS.[User] u
        JOIN AMS.[Address] a ON u.UserId = a.UserId
        JOIN AMS.UserAccountMapping map ON u.UserId = map.UserId
        JOIN AMS.Account acc ON map.AccountId = acc.AccountId
        JOIN AMS.AccountTransaction t ON acc.AccountId = t.AccountId
        WHERE u.UserId = @UserId AND acc.AccountId = @AccountID;

        SET @count = @count + 1;
    END
END;
exec AMS.Proc_UserAndAllOtherTables_Insert
exec AMS.Proc_SelectallTables
SELECT * FROM AMS.MergedUserInfo


CREATE TABLE AMS.MergedUserInfo
(
    MergedID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserId BIGINT,
    UserName NVARCHAR(250),
    DateOfBirth DATETIME,
    DateOfJoining DATETIME,
    Balance DECIMAL(10, 6),
    MobileNumber BIGINT,
    FullAddress NVARCHAR(MAX),
    AccountID BIGINT,
    AccountNumber INT,
    IsSaving INT,
    Amount DECIMAL(10,6),
    IsDebit BIT,
    CreatedBy VARCHAR(250),
    CreatedDate DATETIME DEFAULT GETDATE()
);


SELECT * FROM AMS.MergedUserInfo

-----------------------------introduce a coloumn as mvc(most valuable customer) with balance more than average balance 
-----------------------------based on age group and do a ranking based on that
SELECT 
case  when Age > 10 and Age < 20  then 'A'
	  when Age > 20 and Age < 30 then 'B'
	  when Age > 30 and Age < 45 then 'C'
	  when Age > 45 then 'D'
else 'Invalid age'
end
FROM 
(
	SELECT UserName, DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age FROM AMS.MergedUserInfo
) as x
------------------------------OPTIMIZED------------------------------
SELECT UserId, UserName, 
case  when DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 10 and DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 20  then 'A'
	  when DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 20 and DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 30 then 'B'
	  when DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 30 and DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 45 then 'C'
	  when DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 45 then 'D'
else 'Invalid age'
end AgeGroup
FROM AMS.MergedUserInfo
-------------------------------GROUPING BY AGE-----------------------
SELECT 
  CASE  
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 10 AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 20 THEN 'A'
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 20 AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 30 THEN 'B'
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 30 AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 45 THEN 'C'
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 45 THEN 'D'
    ELSE 'Invalid age'
  END AS AgeGroup,
  COUNT(*) AS TotalUsers
FROM AMS.MergedUserInfo
GROUP BY 
  CASE  
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 10 AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 20 THEN 'A'
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 20 AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 30 THEN 'B'
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 30 AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 45 THEN 'C'
    WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 45 THEN 'D'
    ELSE 'Invalid age'
  END;

