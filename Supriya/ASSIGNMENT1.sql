create database SupriyaTask1;
go

use SupriyaTask1;
go


Create database AccountManagementSystem
go

use AccountManagementSystem
go

create Schema AMS;
go

CREATE TABLE AMS.[User]
(
  UserID BigInt Identity(1,1) Not Null,
  UserName NVarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  AccountNo Int Not Null,
  MobileNo Int Not Null,
  CreatedBy Varchar(250) Not Null,
  Created DateTime Not Null,
 )

ALTER TABLE AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID]  PRIMARY KEY  (UserID);

ALTER TABLE AMS.[User]
ADD CONSTRAINT DF_AMS_User_Created DEFAULT GETDATE() FOR Created;

--ALTER TABLE AMS.[User]
--ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.AMS_User(UserID);

 ;

 SELECT * FROM AMS.[User];
 

 INSERT INTO AMS.[User](UserName, DOB, DOJ, Balance, AccountNO, MobileNo, CreatedBy)
 VALUES ('Supriya', '13-MARCH-2003', '03-APRIL-2025', 1800.0, 722473253, 827763245, 'ESSPL'),
        ('Puja', '12-MARCH-2003', '03-APRIL-2025', 1800.0, 79853253, 889473254, 'ESSPL');

DELETE FROM AMS.[User];
DBCC CHECKIDENT ('AMS.[User]', RESEED, 0);
GO


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
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

INSERT INTO AMS.Address(UserID, AddressDetail, CreatedBy)
VALUES(1, 'BBSR', 'Supriya'),
      (2, 'BDK', 'Puja');

SELECT * FROM AMS.Address;
go

CREATE PROCEDURE AMS.Proc_Address_Insert 
AS BEGIN
 INSERT INTO AMS.[Address](UserID, AddressDetail, CreatedBy)
 VALUES(1, 'BBSR', 'ESSPL'),
      (2, 'BDK', 'ESSPL');
END

EXEC AMS.Proc_Address_Insert;

ALTER PROCEDURE AMS.Proc_Address_Insert
 @UserID BIGINT ,
 @AddressDetail NVARCHAR(MAX),
 @CreatedBy VARCHAR(250) = 'defaultUser'
AS BEGIN
 INSERT INTO AMS.[Address](UserID, AddressDetail, CreatedBy)
 VALUES(@UserID,@AddressDetail,@CreatedBy )
END

EXEC AMS.Proc_Address_Insert 2, 'BDK';
GO

delete from AMS.[Address] WHERE AddressID between 4 and 6;

CREATE TABLE AMS.[Account] (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);


ALTER TABLE AMS.[Account]
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR Created;

INSERT INTO AMS.Account(AccountNo, IsSaving, CreatedBy)
VALUES(722473253, 1, 'ESSPL'),
      (79853253, 0, 'ESSPL');

SELECT * FROM AMS.Account;
GO



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
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

INSERT INTO AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
VALUES (1, 1, 'ESSPL'),
       (2, 2, 'ESSPL');

SELECT * FROM AMS.UserAccountMapping;
go



CREATE TABLE AMS.[AccountTransaction] (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

alter table AMS.AccountTransaction alter column AccountID BIGINT NOT NULL

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
VALUES (1, 1000, 0, 'ESSPL'),
       (2, 1500, 1, 'ESSPL');

SELECT * FROM AMS.AccountTransaction;
go

SP_HELP [User];





