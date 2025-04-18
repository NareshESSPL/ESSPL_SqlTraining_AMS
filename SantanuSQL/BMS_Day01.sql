
-- Creating an database with the name 'bankingmanagementsystem'
CREATE DATABASE BankingManagementSystem;
go

-- Using the database
USE BankingManagementSystem;
GO

-- Creating an schema for better understanding the view
CREATE SCHEMA BMS;
GO



-- Creating an table with the name 'user'
CREATE TABLE BMS.[User]
(
UserID BigInt Identity(1,1) Not Null PRIMARY KEY,
Username NVarchar(250) Not Null,
DOB DateTime Not Null,
DOJ DateTime Not Null,
Balance Decimal(10,6) Null,
MobileNo Int Not Null,
CreatedBy Varchar(250) Not Null,
Created DateTime Not Null DEFAULT GETDATE()
);
GO

SELECT * FROM BMS.[User];


-- Creating an table with the name 'account'
CREATE TABLE BMS.[Account]
(
Username NVarchar(250) Not Null,
AccountID BigInt Identity(1,1) Not Null PRIMARY KEY,
AccountNo Int NOT Null,
IsSaving Bit Not Null,
CreatedBy Varchar(250)	Not Null,
Created	DateTime Not Null DEFAULT GETDATE()
);
GO

SELECT * FROM BMS.[Account]; 

alter table bms.account set accountNO null


-- Creating an table with the name 'UserAccountMapping'
CREATE TABLE BMS.[UserAccountMapping]
(
  Username NVarchar(250) Not Null,
  UserAccountMappingID BigInt Not Null Identity(1,1) Primary Key,
  UserID BigInt Not Null,
  AccountID BigInt Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null Default GETDATE(),

-- Setting the foriegn key constraint userID to relate 'useraccountmapping' and 'user' table
  CONSTRAINT FK_User_UserID FOREIGN KEY (UserID) REFERENCES BMS.[User],

-- Setting the foriegn key constraint userID to relate 'useraccountmapping' and 'account' table
  CONSTRAINT FK_Account_AccountID FOREIGN KEY (AccountID) REFERENCES BMS.Account
);
GO

SELECT * FROM BMS.[UserAccountMapping]; 


-- Creating an table with the name 'Address'
CREATE TABLE BMS.[Address]
(
Username NVarchar(250) Not Null,
AddressID	BigInt	Not Null IDENTITY(1,1)	Primary Key,
UserID	BigInt	Not Null,
Address	NVarchar(max)	Not Null,		
CreatedBy	Varchar(250)	Not Null,	
CreatedDate	DateTime	Not Null	Default GETDATE()

-- Setting the foriegn key constraint to relate userId in both address and user table respectively
CONSTRAINT FK_U_UserID FOREIGN KEY (UserID) REFERENCES BMS.[User]
);
GO

EXEC SP_RENAME 'Adress.Address','Address.AddressDetails','COLUMN';

SELECT * FROM BMS.[Address]; 

CREATE TABLE BMS.[AccountTransaction]
(
Username NVarchar(250) Not Null,
AccountTransaction	BigInt	Not Null IDENTITY(1,1)	Primary Key,
Amount	Decimal(10,6)	Not Null,		
IsDebit	Bit	Not Null,		
CreatedBy	Varchar(250)	Not Null,		
CreatedDate	DateTime	Not Null	Default GETDATE()	
);
GO

SELECT * FROM BMS.[AccountTransaction]; 

