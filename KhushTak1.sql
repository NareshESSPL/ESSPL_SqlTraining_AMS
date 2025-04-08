create table [User]
(

 UserID BigInt Identity(1,1) Not Null primary key,
  UserName NVarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  MobileNo Int Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null Default getDate(),

);

Select * from [User];
drop table [User];


create table [ACCOUNT]
(

 AccountID BigInt  Not Null Identity(1,1)  primary key,
  AccountNo int Not Null,
  IsSaving Bit Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null Default getDate(),

);
Select * from account;
drop table account;

create table [UserAccountMapping]
(

 UserAccoutMapping BigInt  Not Null Identity(1,1) primary key,
   UserID BigInt  Not Null,
  AccountID BigInt  Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null Default getDate(),

);
Select * from UserAccountMapping;
drop table UserAccountMapping;

create table [Address]
(

 AddressID BigInt  Not Null Identity(1,1) primary key,
  UserID BigInt Not Null,
  Address NVarchar(max) Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null Default getDate(),

);
Select * from Address;
drop table Address;

create table [AccountTransaction]
(

 AccountTransaction BigInt  Not Null Identity(1,1) primary key,
  Amount Decimal(10,6) Not Null,
  IsDebit Bit Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null Default getDate(),

);
Select * from AccountTransaction;
