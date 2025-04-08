create database Bank_System;


create table [User]
(
  UserID BigInt Identity Not Null primary key,
  UserName Nvarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  MobileNo Int Not Null,
  CreatedBy Varchar(250)Not Null,
  CreatedDate DateTime Not Null default getdate(), 
);


select * from [User];

create table [Account_New]
(
  AccountID BigInt Not Null primary key,
  AccountNo Int Not Null,
  IsSaving bit Not Null,
  CreatedBy Varchar(250) Not Null,
  CreateDate Datetime Not Null default getdate(),
  );


create table [UserAccMapping]
(
  UserAccountMapping BigInt Not Null primary key,
  UserID BigInt Not Null,
  AccountID BigInt Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null default getdate(),
  constraint [fk_User_ID]
  foreign key (UserID)
  references [User](UserID)
  );

create table [Address]
(
  AddressID BigInt Not Null,
  UserID BigInt Not Null,
  Address Nvarchar(250) Not Null,
  CreatedBy Varchar(250) Not Null,
  CreateDate Datetime Not Null default getdate(),
  primary key(AddressID),
  constraint [Fk_Add_User_ID]
  foreign key (UserID) 
  references [User] (UserID)
);
select * from [Address];
create table [ Acctransaction]
(
 AccountTransaction BigInt Not Null,
 Amount Decimal(10,6) Not Null primary key,
 IsDebit Bit Not Null,
 CreatedBy Varchar(250) Not Null,
 CreatedDate Datetime Not Null default getdate(),

);
