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
