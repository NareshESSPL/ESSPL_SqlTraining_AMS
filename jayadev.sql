create database AccountManagementSystem
go
use AccountManagementSystem
go

create schema AMS;
go

create table AMS.[User]
(
   UserId BigInt NOT NULL IDENTITY(1,1) Primary key,
   UserName Nvarchar(250) NOT NULL,
   DOB DateTime NOT NULL,
   DOJ DateTime NOT NULL,
   Balance Decimal(10,6) NULL,
   MobileNo int NOT NULL,
   CreatedBy Varchar(250) NOT NULL,
   CreatedDate DateTime NOT NULL DEFAULT GETDATE()
);

create table AMS.[Account]
(
   AccountId BigInt NOT NULL IDENTITY(1,1) Primary key,
   AccountNo Int NOT NULL,
   IsSaving  BigInt NOT NULL,
   CreatedBy Varchar(250) NOT NULL,
   CreatedDate DateTime NOT NULL DEFAULT GETDATE()
);

create table AMS.[UserAccountMapping]
(
   UsrerAccountMapping BigInt NOT NULL IDENTITY(1,1) Primary key,
   UserId BigInt NOT NULL FOREIGN KEY REFERENCES AMS.[User](UserId),
   AccountID BigInt NOT NULL,
   CreatedBy Varchar(250) NOT NULL,
   CreatedDate DateTime NOT NULL DEFAULT GETDATE()
    
);

create table AMS.[Address]
(
   AddressID BigInt NOT NULL IDENTITY(1,1) Primary key,
   UserId BigInt NOT NULL FOREIGN KEY REFERENCES AMS.[User](UserId),
   Address NVarchar(max) NOT NULL,
   CreatedBy Varchar(250) NOT NULL,
   CreatedDate DateTime NOT NULL DEFAULT GETDATE()
    
);

create table AMS.[AccountTransaction]
(
   AccountTransaction BigInt NOT NULL IDENTITY(1,1) Primary key,
   Amount BigInt NOT NULL,
   IsDebit Decimal(10,6) NOT NULL,
   CreatedBy Varchar(250) NOT NULL,
   CreatedDate DateTime NOT NULL DEFAULT GETDATE()
    
);

select name from sys.tables