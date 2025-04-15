/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for User table insertion
*/
CREATE PROCEDURE AMS.Proc_User_Insert
@UserName NVARCHAR(250),
@DOB DATETIME,
@DOJ DATETIME,
@Balance DECIMAL(10,6),
@AccountNo INT,
@MobileNo BIGINT,
@CreatedBy VARCHAR(250) = 'DefaultUser'

AS BEGIN
    -- Insert into User table
    INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
    VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy);
END

-- Example execution
EXEC AMS.Proc_User_Insert 'SampleUser', '1990-01-01', '2025-04-08', 5000.00, 1011, 9876543210;
GO



/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for Address table insertion
*/
CREATE PROCEDURE AMS.Proc_Address_Insert
@UserName NVARCHAR(250),
@DOB DATETIME,
@DOJ DATETIME,
@Balance DECIMAL(10,6),
@AccountNo INT,
@MobileNo BIGINT,
@AddressDetail NVARCHAR(MAX),
@CreatedBy VARCHAR(250) = 'DefaultUser'

AS BEGIN
    DECLARE @UserId BIGINT

	-- Insert into User table
    INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
    VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy);

	SET @UserId = SCOPE_IDENTITY();

    -- Insert into Address table
    INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
    VALUES (@UserId, @AddressDetail, @CreatedBy);
END

-- Example execution
EXEC AMS.Proc_Address_Insert 'SampleUser', '1990-01-01', '2025-04-08', 5000.00, 1011, 9876543210, '';
GO

/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for Account table insertion
*/
CREATE PROCEDURE AMS.Proc_Account_Insert
@AccountNo INT,
@IsSaving BIT,
@CreatedBy VARCHAR(250) = 'DefaultUser'

AS BEGIN
    -- Insert into Account table
    INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);
END

-- Example execution
EXEC AMS.Proc_Account_Insert 1011, 1;
GO

/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for AccountTransaction table insertion
*/
CREATE PROCEDURE AMS.Proc_AccountAndAccountTransaction_Insert
@AccountNo INT,
@IsSaving BIT,
@Amount DECIMAL(10, 6),
@IsDebit BIT,
@CreatedBy VARCHAR(250) = 'DefaultUser'

AS BEGIN
	DECLARE @AccountId BIGINT;
    -- Insert into Account table
    INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);

	SET @AccountId = SCOPE_IDENTITY();
	-- Insert into AccountTransaction table
    INSERT INTO AMS.[AccountTransaction] (AccountID, Amount, IsDebit, CreatedBy)
    VALUES (@AccountId, @Amount, @IsDebit, @CreatedBy);
END

-- Example execution
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1011, 1, 4050, 1;
GO

/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for UserAccountMapping table insertion
*/
CREATE PROCEDURE AMS.Proc_UserAccountMapping_Insert
@UserName NVARCHAR(250),
@DOB DATETIME,
@DOJ DATETIME,
@Balance DECIMAL(10,6),
@AccountNo INT,
@MobileNo BIGINT,
@IsSaving BIT,
@Amount DECIMAL(10, 6),
@IsDebit BIT,
@CreatedBy VARCHAR(250) = 'DefaultUser'

AS BEGIN
    DECLARE @UserId BIGINT;
	DECLARE @AccountId BIGINT;
	-- Insert into User table
    INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
    VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy);

    -- Insert into Account table
    INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);

	SET @UserId = SCOPE_IDENTITY();
	SET @AccountId = SCOPE_IDENTITY();

	-- Insert into UserAccountMapping table
    INSERT INTO AMS.[UserAccountMapping] (UserID, AccountID, CreatedBy)
    VALUES (@UserId, @AccountId, @CreatedBy);
END

-- Example execution
EXEC AMS.Proc_UserAccountMapping_Insert 'SampleUser', '2002-02-02', '2024-02-06', 3469, 1014, 9341904345, 1, 1000, 1;
GO