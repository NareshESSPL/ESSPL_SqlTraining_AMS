USE BankingManagementSystem; go

-- Stored procedure to insert a new user and their associated details

CREATE PROCEDURE BMS.PROC_USER_INSERTALL
    @Username NVarchar(250),
    @DOB DateTime,
    @DOJ DateTime,
    @BALANCE Decimal(10,6),
    @AccountNo Int,
    @AccountTransaction BigInt,
    @MOBILENO BigInt,
    @Address NVarchar(max),
    @IsSaving Bit,
    @IsDebit Bit,
    @Amount Decimal(10,6),
    @CreatedBy Varchar(250) = 'admin'

 -- Declare variables to store the newly generated UserID and AccountID
	AS BEGIN
	DECLARE @UserID BIGINT
	DECLARE @AccountID BIGINT        


-- Insert basic user information into the BMS.[user] table
    INSERT INTO BMS.[user] (Username, DOB,DOJ,Balance,MobileNo,CreatedBy)
    VALUES (@Username, @DOB, @DOJ, @BALANCE, @MOBILENO, @CreatedBy)

-- Retrieve the last inserted UserID
   SET @UserId = SCOPE_IDENTITY()

-- Insert basic user information into the BMS.[address] table
   INSERT INTO BMS.[Address] (UserID,Address,CreatedBy)
   VALUES (@UserID,@Address,@CreatedBy)

-- Insert basic user information into the BMS.[account] table
   INSERT INTO BMS.[Account] (AccountID,Username,AccountNo, IsSaving, CreatedBy)
   VALUES (@AccountID,@Username,@AccountNo,@IsSaving,@CreatedBy)

-- Insert basic user information into the BMS.[account] table
   SET @AccountID = SCOPE_IDENTITY()

-- Insert user information into the BMS.[UserAccountMapping] table
   INSERT INTO BMS.[UserAccountMapping](UserID,AccountID,Username,CreatedBy)
   VALUES(@UserID,@AccountID,@Username,@CreatedBy)

-- Insert user information into the BMS.[AccountTransaction] table
   INSERT INTO BMS.[AccountTransaction](AccountTransaction,Amount,IsDebit,CreatedBy)
   VALUES(@AccountTransaction,@Amount,@IsDebit,@CreatedBy)

END;
GO

-- Execute the stored procedure
EXEC BMS.PROC_USER_INSERTALL 'Anything', 2002-07-26,2002-10-26,1325.95,56347,7,178953,'99 Ridge Lawn',0,1,50.00,'Test1';
GO

SELECT * FROM BMS.[USER];
SELECT * FROM BMS.[Address];
SELECT * FROM BMS.[Account];
SELECT * FROM BMS.[UserAccountMapping];
SELECT * FROM BMS.[AccountTransaction];
