-- 1. Create the Database
CREATE DATABASE AMS_DB;
GO

-- 2. Use the Database
USE AMS_DB;
GO

-- 3. Create the Schema
CREATE SCHEMA AMS;
GO

-- 4. Create Tables

-- User Table
CREATE TABLE AMS.[User] (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100),
    DOB DATE,
    DOJ DATE,
    Balance DECIMAL(10, 2),
    MobileNo VARCHAR(15)
);

-- Account Table
CREATE TABLE AMS.Account (
    AccountID INT PRIMARY KEY,
    AccountNo VARCHAR(20),
    IsSaving BIT
);

-- UserAccountMapping Table
CREATE TABLE AMS.UserAccountMapping (
    MappingID INT PRIMARY KEY,
    UserID INT,
    AccountID INT,
    CreatedBy VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID),
    FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID)
);

-- Address Table
CREATE TABLE AMS.Address (
    AddressID INT PRIMARY KEY,
    UserID INT,
    AddressLine VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID)
);

-- 5. Insert Sample Data

-- Users
INSERT INTO AMS.[User] (UserID, UserName, DOB, DOJ, Balance, MobileNo) VALUES
(1, 'Alice', '1990-05-10', '2020-01-01', 5000.00, '1234567890'),
(2, 'Bob', '1985-03-15', '2019-06-10', 3000.00, '0987654321'),
(3, 'Charlie', '1992-11-23', '2021-07-01', 7000.00, '9876543210'),
(4, 'David', '1995-02-28', '2022-03-15', 2000.00, '6543210987');

-- Accounts
INSERT INTO AMS.Account (AccountID, AccountNo, IsSaving) VALUES
(101, 'ACC001', 1),
(102, 'ACC002', 0),
(103, 'ACC003', 1),
(104, 'ACC004', 1);

-- UserAccountMapping
INSERT INTO AMS.UserAccountMapping (MappingID, UserID, AccountID, CreatedBy) VALUES
(1, 1, 101, 'Admin'),
(2, 2, 102, 'Admin'),
(3, 3, 103, 'Admin');

-- Address (only Alice and Charlie have addresses)
INSERT INTO AMS.Address (AddressID, UserID, AddressLine, City, State, ZipCode) VALUES
(1, 1, '123 Main St', 'New York', 'NY', '10001'),
(2, 3, '456 Oak St', 'Chicago', 'IL', '60601');

-- 6. Create Stored Procedures

-- Q1: Get User-Account Details
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

-- Q2: Users With Above Average Balance
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

-- Q3: Users Without Address
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
        AMS.Address A ON U.UserID = A.UserID
    WHERE 
        A.AddressID IS NULL;
END
GO

-- 7. Execute Procedures to Test

EXEC AMS.Proc_GetUserAccountDetails;
EXEC AMS.Proc_GetUsersWithAboveAverageBalance;
EXEC AMS.Proc_GetUsersWithoutAddress;
