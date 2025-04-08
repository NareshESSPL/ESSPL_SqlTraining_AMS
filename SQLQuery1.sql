select name from sys.databases
go

use AccountSystem

create table AMS.[User] (UserID BigInt Identity(1,1) Not Null primary key,
UserName NVarchar(250) not null,
DOB DateTime not null,
DOJ DateTime not null,
Balance Decimal(10,6),
MobileNo int not null,
CreatedBy Varchar(250) not null,
CreatedDate DateTime Not null
) 
go 

Alter table AMS.[User]
Alter COLUMN MobileNo int not null;
go

Alter table AMS.[User]
Alter COLUMN
UserName NVarchar(250) not null;
go

select * from AMS.[User];
go

Alter Table AMS.[User]
add CONSTRAINT  DF_AMS_User_Created DEFAULT GETDATE() FOR CreatedDate;

exec sp_help 'AMS.[User]'

create table AMS.Account (AccountID BigInt Not Null identity(1,1) Primary key, 
AccountNo Int Not Null, 
IsSaving Bit Not Null,
CreatedBy Varchar(250) Not Null,
CreatedDate DateTime Not Null DEFAULT GETDATE()
)

select name from sys.tables

exec sp_help 'AMS.Account'

create table AMS.UsrerAccountMapping (
UsrerAccountMappingId BigInt identity(1,1) Not Null,
UserID BigInt Not Null,
AccountID BigInt Not Null,
CreatedBy nVarchar(250) Not Null,
CreatedDate DateTime Not Null DEFAULT GETDATE()
)

Alter table AMS.UsrerAccountMapping
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);


create table AMS.Address (
AddressID BigInt identity(1,1) Not Null primary key,
UserID BigInt Not Null FOREIGN KEY REFERENCES AMS.[User](UserID) ,
Address NVarchar(max) Not Null,
CreatedBy Varchar(250) Not Null,
CreatedDate DateTime Not Null DEFAULT GETDATE()
)

exec sp_help 'AMS.Address';

create table AMS.AccountTransaction(
AccountTransactionId BigInt identity(1,1) Not Null PRIMARY KEY,
Amount Decimal(10,6) Not Null,
IsDebit Bit Not Null,
CreatedBy Varchar(250)Not Null,
CreatedDate DateTime Not Null DEFAULT GETDATE()
)
exec sp_help 'AMS.AccountTransaction';