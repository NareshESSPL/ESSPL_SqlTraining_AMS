CREATE DATABASE AccountManagementSystem;
USE AccountManagementSystem;

CREATE SCHEMA ams;

CREATE TABLE ams.[User]
(
UserID Bigint  NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserName Nvarchar(250) NOT NULL,
DateOfBirth DATETIME NOT NULL,
DateOfJoining DATETIME NOT NULL,
Balance Decimal(10,2) NULL,
MobileNo int NOT NULL,
CreatedBy varchar(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE ams.Account(
AccountID Bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
AccountNo int NOT NULL,
isSaving Bit NOT NULL,
CreatedBy varchar(250) NOT NULL,
CreateDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE ams.USERAccountMapping
(UserAccountMapping Bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserID Bigint NOT NULL FOREIGN KEY REFERENCES ams.[User] (UserID),
AccountID Bigint NOT NULL FOREIGN KEY REFERENCES ams.Account(AccountID),
CreatedBy varchar(250) NOT NULL,
CreateDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE ams.Address(
AddressID Bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
UserID Bigint NOT NULL FOREIGN KEY REFERENCES ams.[User] (UserID),
Address Nvarchar(max) NOT NULL,
CreatedBy Varchar(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE ams.AccountTransaction(
AccountTransaction Bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
Amount Decimal(10,6) NOT NULL,
isDebit Bit NOT NULL,
CreatedBy varchar(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

insert into ams.[User] (UserName,DateOfBirth,DateOfJoining,Balance,MobileNo,CreatedBy)
Values ('Alice sharma','1995-06-15','2020-02-13',5000.00,994839283,'Admin');
insert into ams.[User] (UserName,DateOfBirth,DateOfJoining,Balance,MobileNo,CreatedBy)
Values ('Bittu kumar','1999-03-19','2020-02-13',2340.00,954849333,'Admin');

insert into ams.Account(AccountNo,isSaving,CreatedBy)
Values
(101001,1,'Admin'),
(101002,0,'Admin');



insert into ams.USERAccountMapping(UserID,AccountID,CreatedBy)
Values
(1,1,'Admin'),
(2,2,'Admin');

insert into ams.Address (UserID,Address,CreatedBy)
values
(1,'123 park street , Delhi','Admin'),
(2,'456 Main Road, Patna', 'Admin');

insert into ams.AccountTransaction(Amount, isDebit,CreatedBy)
Values
(1000.00,1,'Admin'),
(1500.00,0,'Admin');