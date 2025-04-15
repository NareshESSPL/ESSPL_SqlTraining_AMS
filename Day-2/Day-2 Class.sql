CREATE DATABASE AccountManagementSystem
GO

USE AccountManagementSystem
GO

CREATE SCHEMA AMS;
GO

--Creating User Table
CREATE TABLE AMS.[User]
(
  UserID BIGINT Identity(1,1) Not Null,
  UserName NVARCHAR(250) Not Null,
  DOB DATETIME Not Null,
  DOJ DATETIME Not Null,
  Balance DECIMAL(10,6),
  AccountNo INT Not Null,
  MobileNo INT Not Null,
  CreatedBy VARCHAR(250) Not Null,
  Created DATETIME Not Null,
 );

 --Changing the MobileNo data type from INT to BIGINT
ALTER TABLE AMS.[User] ALTER COLUMN MobileNo BIGINT;
 
--Adding Constraints
ALTER TABLE AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID]  PRIMARY KEY  (UserID);

ALTER TABLE AMS.[User]
ADD CONSTRAINT DF_AMS_User_Created DEFAULT GETDATE() FOR Created;



--Creating Account Table
CREATE TABLE AMS.[Account](
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

--Adding Constraints
ALTER TABLE AMS.[Account]
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR Created;



--Creating Address Table
CREATE TABLE AMS.[Address] (
    AddressID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AddressDetail NVARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

--Adding Constraints
ALTER TABLE AMS.[Address]
ADD CONSTRAINT PK_AMS_Address_AddressID PRIMARY KEY (AddressID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);



--Creating table UserAccountMapping
CREATE TABLE AMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);

--Adding Constraints
ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT PK_AMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);


--Creating Table AccountTransaction
CREATE TABLE AMS.AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

--Changing the datatype of AccountID from  INT to BIGINT
ALTER TABLE AMS.AccountTransaction ALTER COLUMN AccountID BIGINT NOT NULL

--Adding Constraints
ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);



--DML Operations
SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[Address];

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
VALUES('Surya', '2021-07-09', '2025-03-11', 4000, 1000, 4836, 'Sunil');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
VALUES('Sunil', '2021-07-09', '2025-03-11', 4000, 1000, 4836, 'Sunil');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
VALUES('Anuj', '2008-07-11', '2025-03-12', 5000, 1001, 3499, 'Anuj');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
VALUES('Suraj', '2002-02-12', '2024-04-05', 5000, 1002, 2954, 'Suraj');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
VALUES('Purushotam', '2002-02-12', '2024-04-05', 2000, 1004, 2954, 'Suraj');

INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
VALUES('Sanjay', '2002-02-12', '2024-04-05', 2050, 1005, 27954, 'SurajSah');


--Reseting the IDENTITY()
--Using DBCC
DBCC CHECKIDENT ('AMS.[User]', RESEED, 5);
sp_help 'AMS.[User]'


--Account Table
SELECT * FROM AMS.[Account];
DBCC CHECKIDENT ('AMS.[Account]', RESEED, 0);

INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
VALUES(1001, 1, 'Suraj Sah');

INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
VALUES(1000, 1, 'Suraj Sah');

INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
VALUES(1003, 1, 'Suraj Sah');


--Address Table
SELECT * FROM AMS.[Address];
DBCC CHECKIDENT ('AMS.[Address]', RESEED, 0);


INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
VALUES (1, 'KP-26, BBSR', 'Suraj Sah');

INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
VALUES (1, 'Nepal', 'Suraj Sah');

INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
VALUES (2, 'BBSR', 'Suraj Sah');

INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
VALUES (2, 'Nepal', 'Suraj Sah');



--Creating Stored Procedure
/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure without parameters
*/
go

CREATE PROCEDURE AMS.Proc_User_Insert
AS BEGIN
  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
  VALUES 
    ('test', '1997-02-02', '2025-02-03', 600, 12345, 934190, 'testUser'),
	('tes2', '1997-03-02', '2025-03-03', 700, 12345, 934190, 'testUser2')
END
EXEC AMS.Proc_User_Insert
go

select * from ams.[User]
go


--Altering
/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure with parameters
*/

ALTER PROCEDURE AMS.Proc_User_Insert
@UserName NVARCHAR(250),
@DOB	DATETIME,
@DOJ	DATETIME,
@Balance	DECIMAL(10, 6),
@AccountNo	INT,
@MobileNo	BIGINT,
@CreatedBy	VARCHAR(250) = 'DefaultUser'

AS BEGIN
  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
  VALUES 
    (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
END

EXEC AMS.Proc_User_Insert 'Suraj_Sah', '2004-02-18', '2025-04-03', 9000, 1009, 4836;

select * from ams.[User]


--Create for Address table
/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : Stored Procedure
*/
go
CREATE PROCEDURE AMS.Proc_UserAndAddress_Insert
@UserName NVARCHAR(250),
@DOB	DATETIME,
@DOJ	DATETIME,
@Balance	DECIMAL(10, 6),
@AccountNo	INT,
@MobileNo	BIGINT,
@AddressDetail NVARCHAR(MAX),
@CreatedBy	VARCHAR(250) = 'DefaultUser'

AS BEGIN
  DECLARE @UserId BIGINT

  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
  VALUES 
    (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy);

  SET @UserId = SCOPE_IDENTITY();
  
  INSERT INTO AMS.[Address] (UserID, AddressDetail, CreatedBy)
  VALUES
    (@UserId, @AddressDetail, @CreatedBy);

END

EXEC AMS.Proc_UserAndAddress_Insert 'Suraj_Sah', '2004-02-18', '2025-04-03', 9000, 1009, 4836, 'NEPAL';
EXEC AMS.Proc_UserAndAddress_Insert 'Suraj_Sah', '2004-02-18', '2025-04-03', 2000, 1010, 1826, 'BBSR';

select * from ams.[Address];
select * from ams.[User];











-- JOIN
SELECT UserName, AccountNo, Balance, MobileNo, AddressDetail AS 'Address' from AMS.[User] INNER JOIN AMS.[Address] on AMS.[User].UserID = AMS.[Address].UserID;