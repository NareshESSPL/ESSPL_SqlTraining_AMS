CREATE OR ALTER PROCEDURE AMS.InsertFullUserAccountData
    @UserName NVARCHAR(250),
    @DOB DATETIME,
    @DOJ DATETIME,
    @Balance DECIMAL(10,6),
    @MobileNo BIGINT,
    @AccountNo INT,
    @IsSaving BIT,
    @Address NVARCHAR(250),
    @Amount DECIMAL(10,6),
    @IsDebit BIT,
    @CreatedBy VARCHAR(250) = 'admin'
AS
BEGIN

    DECLARE 
    @UserName [nvarchar](250) = 'test',
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate()
	@count INT = 0;
	
    SET NOCOUNT ON;
  
  WHILE @count < =1000
  BEGIN
  --Do not delete
  select @count = @count + 1

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insert into User
        INSERT INTO AMS.[User](UserName, DOB, DOJ, Balance, MobileNo, CreatedBy)
        VALUES (@UserName, @DOB, @DOJ, @Balance, @MobileNo, @CreatedBy);

        SET @UserID = SCOPE_IDENTITY();

        -- 2. Insert into Account_New
        INSERT INTO AMS.[Account](AccountNo, IsSaving, UserID, CreatedBy)
        VALUES (@AccountNo, @IsSaving, @UserID, @CreatedBy);

        SET @AccountID = SCOPE_IDENTITY();

        -- 3. Insert into Address
        INSERT INTO AMS.[Address](UserID, AddressDetail, CreatedBy)
        VALUES (@UserID, @Address, @CreatedBy);

        -- 5. Insert into UserAccountMapping
        INSERT INTO AMS.[UserAccountMapping](UserID, AccountID, CreatedBy)
        VALUES (@UserID, @AccountID, @CreatedBy);

        -- 4. Insert into Acctransaction
        INSERT INTO AMS.AccountTransaction(Amount, IsDebit, CreatedBy)
        VALUES (@Amount, @IsDebit, @CreatedBy);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
  END;
END

EXEC AMS.InsertFullUserAccountData
    