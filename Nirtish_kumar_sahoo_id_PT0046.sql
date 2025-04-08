create database Account_Management_System;
go

use Account_Management_System;
go

create schema ASM;
go

create table ASM.[User](
UserID bigint identity(1,1) primary key ,
UserName Nvarchar(250) not null,
DOB datetime not null,
DOj datetime not null,
Balance decimal(10,6),
MobileNo Int not null,
CreatedBy varchar(250) not null,
CreatedDate datetime not null
);

exec sp_help 'ASM.[User]';
go

alter table ASM.[User]
add constraint DF_ASM_USER default getdate() for CreatedDate;
go

create table ASM.Account(
AccountID bigint identity(1,1) primary key,
AccountNo int not null,
IsSaving bit not null,
CreatedBy varchar(250) not null,
CraetedDate datetime default getdate() not null
);
 
 create table ASM.UserAccountMapping(
 UserAccountMapping bigint identity(1,1) primary key,
 UserID bigint not null foreign key references ASM.[User](UserID),
 AccountID bigint not null,
 CreatedBy varchar(250) not null,
 CraetedDate datetime default getdate() not null
 );

 exec sp_help'ASM.UserAccountMapping';
 go

 create table ASM.[Address](
AddressID bigint identity(1,1) primary key,
UserID bigint not null foreign key references ASM.[User](UserID),
Address_ nvarchar(max) not null,
CreatedBy varchar(250) not null,
CreatedDate datetime default getdate() not null
); 

exec sp_help'ASM.[Address]';

create table ASM.AccontTransaction(
AmmountTransaction bigint identity(1,1) primary key,
Amount decimal(10,6) not null,
IsDebit bit not null,
CreatedBy varchar(250) not null,
CreatedDate datetime default getdate() not null
); 



exec sp_help'ASM.[Address]';
 go
