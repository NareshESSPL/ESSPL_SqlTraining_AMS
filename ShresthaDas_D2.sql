Create database AccountManagementSystem

use AccountManagementSystem

create Schema AMS;

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

SET IDENTITY_INSERT AMS.[User] OFF


INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
VALUES ('Brat Tom', '1987-05-22' , '1999-05-04', 4000.0, 34, 89367284, 'god'),
	('Allen grand', '1989-07-02', '1999-06-04', 4770.0, 88, 89453074, 'god');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
VALUES ('Brat Tom', '1987-05-22' , '2005-05-14', 4000.0, 34, 89367284, 'god');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
VALUES ('Brat m', '1987-05-22' , '2005-05-14', 4000.0, 24, 89367284, 'god');

SELECT * FROM AMS.[User];

DELETE FROM AMS.[User];
DBCC CHECKIDENT ('AMS.[User]', RESEED, 6);

----------------------------------------------

CREATE TABLE AMS.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL
);


ALTER TABLE AMS.Account
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR CreatedDate;

SELECT * FROM AMS.Account;

INSERT INTO AMS.Account (AccountNo, IsSaving, CreatedBy)
VALUES (34, 0, 'god'),
	(88, 1, 'god');


DELETE FROM AMS.Account;
DBCC CHECKIDENT ('AMS.Account', RESEED, 0);


--------------------------------------------

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


INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
VALUES (1, 'wyiefgi', 'god'),
	(2, 'syefgyag', 'god');

DELETE FROM AMS.[Address];
DBCC CHECKIDENT ('AMS.[Address]', RESEED, 0);

SELECT * FROM AMS.[Address];


----------------------------------------------------------

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


INSERT INTO AMS.[UserAccountMapping] (UserID, AccountID, CreatedBy)
VALUES (1, 1, 'god'),
	(2, 2, 'god');

SELECT * FROM AMS.[UserAccountMapping];


--------------------------------------------

CREATE TABLE AMS.AccountTransaction (
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


INSERT INTO AMS.AccountTransaction (AccountID, Amount, IsDebit, CreatedBy)
VALUES (1, 1113, 0, 'god'),
	(2, 2368, 0, 'god');

SELECT * FROM AMS.AccountTransaction;


DELETE FROM AMS.AccountTransaction;
DBCC CHECKIDENT ('AMS.AccountTransaction', RESEED, 0);