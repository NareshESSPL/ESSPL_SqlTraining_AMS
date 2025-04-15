/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for User TABLE insertion
*/

CREATE DATABASE AccountManagementSystem
GO

USE AccountManagementSystem
GO

CREATE SCHEMA AMS;
GO


-- Creating User Table
CREATE TABLE AMS.[User]
(
  UserID BIGINT IDENTITY(1,1) NOT NULL,
  UserName NVARCHAR(250) NOT NULL,
  DOB DATETIME NOT NULL,
  DOJ DATETIME NOT NULL,
  Balance DECIMAL(10,6),
  AccountNo INT NOT NULL,
  MobileNo BIGINT NOT NULL,
  CreatedBy VARCHAR(250) NOT NULL,
  Created DATETIME NOT NULL,
 );

-- Adding Constraints Primary key and Default datetime
ALTER TABLE AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID]  PRIMARY KEY  (UserID);

ALTER TABLE AMS.[User]
ADD CONSTRAINT DF_AMS_User_Created DEFAULT GETDATE() FOR Created;


-- Creating Account Table
CREATE TABLE AMS.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

-- Adding Cnstraints Primary key and Default datetime
ALTER TABLE AMS.Account
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR Created;


-- Creating Address Table
CREATE TABLE AMS.[Address] (
    AddressID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AddressDetail NVARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

-- Adding Constraints Primary key, Foreign key and Default datetime
ALTER TABLE AMS.[Address]
ADD CONSTRAINT PK_AMS_Address_AddressID PRIMARY KEY (AddressID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;



-- Creating UserAccountMapping Table
CREATE TABLE AMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);

-- Adding Constraints Primary key, Foreign key and Default datetime
ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT PK_AMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;



-- Creating AccountTransaction Table
CREATE TABLE AMS.AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
    AccountID BIGINT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

-- Adding Constraints Primary key, Foreign key and Default datetime
ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

-------------------------------------------------------------------------------

-- Inserting Data into the tables
SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[AccountTransaction];
SELECT * FROM AMS.[UserAccountMapping];

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
@CreatedBy VARCHAR(250) = 'system'

AS BEGIN
    -- Insert into User table
    INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
    VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy);
END

-- Example execution
EXEC AMS.Proc_User_Insert 'Alice Johnson', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210;
EXEC AMS.Proc_User_Insert 'Bob Smith', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211;
EXEC AMS.Proc_User_Insert 'Charlie Brown', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212;
EXEC AMS.Proc_User_Insert 'David Wilson', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213;
EXEC AMS.Proc_User_Insert 'Eva Green', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214;
EXEC AMS.Proc_User_Insert 'Frank White', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215;
GO


/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure for Account table insertion
*/
CREATE PROCEDURE AMS.Proc_Account_Insert
    @AccountNo INT,
    @IsSaving BIT,
    @CreatedBy VARCHAR(250) = 'system'
AS 
BEGIN
    -- Insert into Account table
    INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);
END

--Example Execution
EXEC AMS.Proc_Account_Insert 1010, 1;
EXEC AMS.Proc_Account_Insert 1011, 0;
EXEC AMS.Proc_Account_Insert 1012, 1;
EXEC AMS.Proc_Account_Insert 1013, 0;
EXEC AMS.Proc_Account_Insert 1014, 1;
EXEC AMS.Proc_Account_Insert 1015, 0;


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
@CreatedBy VARCHAR(250) = 'system'

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
EXEC AMS.Proc_Address_Insert 'Alice Johnson', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210, 'Maple St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'Bob Smith', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211, 'Oak St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'Charlie Brown', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212, 'Pine St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'David Wilson', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213, 'Birch St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'Eva Green', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214, '';
EXEC AMS.Proc_Address_Insert 'Frank White', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215, 'Elm St, Springfield, IL';
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
    @CreatedBy VARCHAR(250) = 'system'
AS 
BEGIN
    DECLARE @UserId BIGINT;
    
    -- Insert into User table
    INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
    VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy);
    
    SET @UserId = SCOPE_IDENTITY();
    
    -- Insert into Address table
    INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
    VALUES (@UserId, @AddressDetail, @CreatedBy);
END

--Example Execution
EXEC AMS.Proc_Address_Insert 'Alice Johnson', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210, 'Maple St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'Bob Smith', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211, 'Oak St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'Charlie Brown', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212, 'Pine St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'David Wilson', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213, 'Birch St, Springfield, IL';
EXEC AMS.Proc_Address_Insert 'Eva Green', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214, '';
EXEC AMS.Proc_Address_Insert 'Frank White', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215, 'Elm St, Springfield, IL';

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
    @CreatedBy VARCHAR(250) = 'system'
AS 
BEGIN
    DECLARE @AccountId BIGINT;
    
    -- Insert into Account table
    INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);
    
    SET @AccountId = SCOPE_IDENTITY();
    
    -- Insert into AccountTransaction table
    INSERT INTO AMS.[AccountTransaction] (AccountID, Amount, IsDebit, CreatedBy)
    VALUES (@AccountId, @Amount, @IsDebit, @CreatedBy);
END

-- Example Execution
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1010, 1, 150.00, 1, 'system';
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1011, 0, 50.00, 0, 'system';
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1012, 1, 200.00, 1, 'system';
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1013, 1, 100.00, 0, 'system';
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1014, 0, 300.00, 1, 'system';
EXEC AMS.Proc_AccountAndAccountTransaction_Insert 1015, 0, 150.00, 0, 'system';



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
@CreatedBy VARCHAR(250) = 'system'

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
EXEC AMS.Proc_UserAccountMapping_Insert 'Alice Johnson', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210, 1, 150.00, 1;
EXEC AMS.Proc_UserAccountMapping_Insert 'Bob Smith', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211, 0, 50.00, 0;
EXEC AMS.Proc_UserAccountMapping_Insert 'Charlie Brown', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212, 1, 200.00, 1;
EXEC AMS.Proc_UserAccountMapping_Insert 'David Wilson', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213, 0, 100.00, 0;
EXEC AMS.Proc_UserAccountMapping_Insert 'Eva Green', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214, 1, 300.00, 1;
EXEC AMS.Proc_UserAccountMapping_Insert 'Frank White', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215, 0, 150.00, 0;

GO