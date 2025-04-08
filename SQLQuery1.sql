Create database db
go

use db
go

Create Schema AMS;
go

Create table AMS.[User]
(
UserID BigInt Identity(1,1) Not Null,
UserName Nvarchar(250) Not Null,
DOB DateTime Not Null,
DOJ DateTime Not Null,
Balance Decimal(10,6),
Mobile_No Int Not Null,
CreatedBy Varchar(250) Not Null,
CreatedDate DateTime Not Null,
)

Alter table AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID] PRIMARY KEY (UserID);

Alter table AMS.[User]
ADD CONSTRAINT [DF_AMS_User_CreatedDate] DEFAULT GETDATE() for CreatedDate;


Select * from AMS.[User];

Create Schema AMS1
go

Create table AMS1.[Account]
(
AccountID BigInt Identity(1,1) Not Null,
AccountNo Int Not Null,
IsSaving Bit Not Null,
CreatedBy Varchar(250) Not Null,
CreatedDate DateTime Not Null
)

Alter table AMS1.[Account]
ADD CONSTRAINT [PK_AMS1_Account_AccountID]
PRIMARY KEY (AccountID);

Alter table AMS1.[Account]
ADD CONSTRAINT [DF_AMS1_Account_CreatedDate]
DEFAULT GETDATE() FOR CreatedDate;

Select * from AMS1.[Account]

Create schema AMS2;
go

Create table AMS2.[UserAccountMapping]
(
UserAccountmapping BigInt Identity(1,1) Not Null,
UserID BigINT Not Null,
AccountID BigInt Not Null,
CreatedBy varchar(250)   Not Null ,
CreatedDate DateTime Not Null 
)
go



Alter table AMS2.[UserAccountMapping]
ADD CONSTRAINT [PK_AMS2_UserAccountMapping_UserAccountMapping]
PRIMARY KEY (UserAccountMapping);

Alter table AMS2.[UserAccountMapping]
ADD CONSTRAINT [DF_AMS2_UserAccountMapping_CreatedDate]
DEFAULT GETDATE() FOR CreatedDate;

Alter table AMS2.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_User_UserID] FOREIGN KEY (UserID) REFERENCES AMS.AMS_User(UserID);

Select * from AMS2.[UserAccountMapping];

Create Schema AMS3
go

Create table AMS3.[Address]
(
AddressID BigInt Identity(1,1) Not Null,
UserID BigInt Not Null,
Address NVarchar(max) Not Null,
CreatedBy Varchar(250) Not Null,
CreatedDate DateTime Not Null
)

Alter table AMS3.[Address]
ADD CONSTRAINT [PK_AMS3_Address_AddressID]
PRIMARY KEY (AddressID);

Alter table AMS3.[Address]
ADD CONSTRAINT [DF_AMS3_Address_CreatedDate]
DEFAULT GETDATE() FOR CreatedDate;

Alter table AMS3.[Address]
ADD CONSTRAINT [FK_AMS_User_UserID] FOREIGN KEY (UserID) REFERENCES AMS.AMS_User(UserID);

Select * from AMS3.[Address];

create database AMS4
go

Create table AMS4.[AccountTransaction]
(
AccountTransaction BigInt Identity(1,1) Not Null,
Amount Decimal(10,6) Not Null,
IsDebit Bit Not Null,
CreatedBy varchar(250)   Not Null ,
CreatedDate DateTime Not Null 
)
go
Alter table AMS4.[AccountTransaction]
ADD CONSTRAINT [PK_AMS4_AccountTransaction_AccountTransaction]
PRIMARY KEY (AccountTransaction);

Alter table AMS4.[AccountTransaction]
ADD CONSTRAINT [DF_AMS4_AccountTransaction_CreatedDate]
DEFAULT GETDATE() FOR CreatedDate;


Select * from AMS4.[AccountTransaction]
go