-- Create database and schema
CREATE DATABASE AccountManagementSystem3;
GO

USE AccountManagementSystem3;
GO

CREATE SCHEMA AMS;
GO

-- USER TABLE
CREATE TABLE AMS.[User]
(
    UserID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(250) NOT NULL,
    DOB DATETIME NOT NULL,
    DOJ DATETIME NOT NULL,
    Balance DECIMAL(10,6),
    AccountNo BIGINT NOT NULL,
    MobileNo BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL
);
GO

-- ACCOUNT TABLE
CREATE TABLE AMS.Account
(
    AccountID BIGINT IDENTITY(1,1) PRIMARY KEY,
    AccountNo BIGINT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- USERACCOUNTMAPPING TABLE
CREATE TABLE AMS.UserAccountMapping
(
    UserAccountMappingID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID),
    FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID)
);
GO

-- ADDRESS TABLE
CREATE TABLE AMS.[Address]
(
    AddressID BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    AddressLine1 NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(100),
    ZipCode NVARCHAR(20),
    FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID)
);
GO

-- INSERT sample data into User
INSERT INTO AMS.[User](UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
VALUES
('RAVI', '1990-01-01', '2020-01-01', 15000.50, 11110000, 9876543210, 'RAVI'),
('SEEMA', '1992-05-21', '2021-06-15', 8500.25, 22220000, 8765432109, 'SEEMA'),
('AMAN', '1995-08-10', '2022-03-10', 12000.00, 33330000, 7654321098, 'AMAN'),
('NISHA', '1998-12-12', '2023-09-25', 7000.00, 44440000, 6543210987, 'NISHA');
GO

-- INSERT sample data into Account
INSERT INTO AMS.Account(AccountNo, IsSaving, CreatedBy)
VALUES
(900001, 1, 'ADMIN'),
(900002, 0, 'ADMIN'),
(900003, 1, 'ADMIN'),
(900004, 1, 'ADMIN');
GO

-- INSERT sample data into UserAccountMapping
INSERT INTO AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
VALUES
(1, 1, 'ADMIN'),
(2, 2, 'ADMIN'),
(3, 3, 'ADMIN');
-- Note: NISHA (UserID = 4) not mapped to test missing mappings
GO

-- INSERT sample data into Address
INSERT INTO AMS.Address(UserID, AddressLine1, City, State, ZipCode)
VALUES
(1, '123 Green St', 'New Delhi', 'Delhi', '110001'),
(2, '456 Blue Ave', 'Mumbai', 'Maharashtra', '400001');
-- AMAN and NISHA do not have addresses
GO

-- PROCEDURE 1: Get User and Account Details
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
GO

-- PROCEDURE 2: Users with balance above average
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
GO

-- PROCEDURE 3: Users without Address
CREATE PROCEDURE AMS.Proc_GetUsersWithoutAddress
AS
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
GO

-- Execute Procedures
EXEC AMS.Proc_GetUserAccountDetails;
EXEC AMS.Proc_GetUsersWithAboveAverageBalance;
EXEC AMS.Proc_GetUsersWithoutAddress;
