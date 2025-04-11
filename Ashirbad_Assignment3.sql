

CREATE DATABASE AccountManagementSystem
GO

USE AccountManagementSystem
GO

CREATE SCHEMA AMS;
GO



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

CREATE TABLE AMS.[Address] (
    AddressID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AddressDetail NVARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);


ALTER TABLE AMS.[Address]
ADD CONSTRAINT PK_AMS_Address_AddressID PRIMARY KEY (AddressID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;




CREATE TABLE AMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT PK_AMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;




CREATE TABLE AMS.AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
    AccountID BIGINT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

-------------------------------------------------------------------------------




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
EXEC AMS.Proc_User_Insert 'Hari sahu', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210;
EXEC AMS.Proc_User_Insert 'ram sahu', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211;
EXEC AMS.Proc_User_Insert 'gedala suresh', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212;
EXEC AMS.Proc_User_Insert 'Davi barik', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213;
EXEC AMS.Proc_User_Insert 'amith sahu', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214;
EXEC AMS.Proc_User_Insert 'raja sahani', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215;
GO



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
EXEC AMS.Proc_Address_Insert 'Hari sahu', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210, 'berhampur';
EXEC AMS.Proc_Address_Insert 'ram sahu', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211, 'cuttack';
EXEC AMS.Proc_Address_Insert 'gedala suresh', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212, 'agra';
EXEC AMS.Proc_Address_Insert 'Davi barik', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213, 'Biranchipur';
EXEC AMS.Proc_Address_Insert 'amith sahu', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214, '';
EXEC AMS.Proc_Address_Insert 'raja sahani', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215, 'ramapur';
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
EXEC AMS.Proc_Address_Insert 'Hari sahu', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210, 'berhampur';
EXEC AMS.Proc_Address_Insert 'ram sahu', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211, 'cuttack';
EXEC AMS.Proc_Address_Insert 'gedala suresh', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212, 'agra';
EXEC AMS.Proc_Address_Insert 'Davi barik', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213, 'Birchipur';
EXEC AMS.Proc_Address_Insert 'amith sahu', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214, '';
EXEC AMS.Proc_Address_Insert 'raja sahani', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215, 'ramapur';

GO



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


EXEC AMS.Proc_UserAccountMapping_Insert 'hari sahu', '1985-01-15', '2025-01-01', 1000.00, 1010, 9876543210, 1, 150.00, 1;
EXEC AMS.Proc_UserAccountMapping_Insert 'ram sahu', '1990-02-20', '2025-02-01', 2000.00, 1011, 9876543211, 0, 50.00, 0;
EXEC AMS.Proc_UserAccountMapping_Insert 'gedala suresh', '1995-03-25', '2025-03-01', 3000.00, 1012, 9876543212, 1, 200.00, 1;
EXEC AMS.Proc_UserAccountMapping_Insert 'Davi barik', '1988-04-30', '2025-04-01', 4000.00, 1013, 9876543213, 0, 100.00, 0;
EXEC AMS.Proc_UserAccountMapping_Insert 'amith sahu', '1992-05-05', '2025-05-01', 5000.00, 1014, 9876543214, 1, 300.00, 1;
EXEC AMS.Proc_UserAccountMapping_Insert 'raja sahani', '1980-06-10', '2025-06-01', 6000.00, 1015, 9876543215, 0, 150.00, 0;

GO


 
/*
 JOINING  User, Account and UserAccountMapping table
*/
CREATE PROCEDURE AMS.Proc_GetUserAccountDetails
AS
BEGIN
    SELECT 
        U.UserID,
        U.UserName,
        U.DOB,
        U.DOJ,
        U.Balance,
        A.AccountID,
        A.AccountNo,
        A.IsSaving,
        UAM.CreatedBy AS MappingCreatedBy
    FROM 
        AMS.[User] U
    JOIN 
        AMS.UserAccountMapping UAM ON U.UserID = UAM.UserID
    JOIN 
        AMS.Account A ON UAM.AccountID = A.AccountID;
END

EXEC AMS.Proc_GetUserAccountDetails;


/*
Q-2.  account for user with more than average balance
*/
CREATE PROCEDURE AMS.Proc_GetUsersWithAboveAverageBalance
AS
BEGIN
    DECLARE @AverageBalance DECIMAL(10, 6);

    SELECT @AverageBalance = AVG(Balance) FROM AMS.[User];

    SELECT 
        U.UserID,
        U.UserName,
        U.Balance,
        A.AccountID,
        A.AccountNo,
        A.IsSaving
    FROM 
        AMS.[User] U
    JOIN 
        AMS.UserAccountMapping UAM ON U.UserID = UAM.UserID
    JOIN 
        AMS.Account A ON UAM.AccountID = A.AccountID
    WHERE 
        U.Balance > @AverageBalance;
END

EXEC AMS.Proc_GetUsersWithAboveAverageBalance;


/*
Q-3. Find users who doesn't have address
*/
CREATE PROCEDURE AMS.Proc_GetUsersWithoutAddress AS
BEGIN
    
    SELECT 
        U.UserID,
        U.UserName,
        U.DOB,
        U.DOJ,
        U.Balance,
        U.MobileNo
    FROM 
        AMS.[User] U
    LEFT JOIN 
        AMS.[Address] A ON U.UserID = A.UserID
    WHERE 
        A.AddressID IS NULL;
END

EXEC AMS.Proc_GetUsersWithoutAddress;