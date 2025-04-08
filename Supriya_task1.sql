create database SupriyaTask1;
go

use SupriyaTask1;
go

create table [User] (
  UserID bigint identity(1,1) primary key,
  UserName nvarchar(250) not null,
  DOB dateTime not null,
  DOJ dateTime not null,
  Balance decimal(10,6),
  MobileNo int not null,
  CreatedBy varchar(250) not null,
  CreatedDate DateTime default getDate() 
);
go

create table Account (
  AccountID bigint identity(1,1) primary key,
  AccountNo int not null,
  isSaving bit not null,
  CreatedBy varchar(250) not null,
  CreatedDate DateTime default getDate() 
);
go

create table UsrerAccountMapping (
  UsrerAccountMapping bigint identity(1,1) primary key,
  UserId bigint not null,
  AccountId int not null,
  CreatedBy varchar(250) not null,
  CreatedDate DateTime default getDate(),
  foreign key(UserId) references [User](UserId) 
);
go 

create table [Address] (
  AddressID bigint identity(1,1) primary key,
  UserId bigint not null references [User](UserId),
  [Address] nvarchar(max) not null,
  CreatedBy varchar(250) not null,
  CreatedDate DateTime default getDate() 
);
go 

create table AccountTransaction (
  AccountTransaction bigint identity(1,1) primary key,
  Amount decimal(10,6) not null ,
  isDebit bit not null,
  CreatedBy varchar(250) not null,
  CreatedDate DateTime default getDate() 
);
go 

select * from Account;
go

select * from UsrerAccountMapping;
go

select * from [Address];
go

select * from AccountTransaction;
go
