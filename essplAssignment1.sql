create database bankings
go

use bankings
go

create table [user]
(
	userId bigint not null primary key identity(1,1),
	username nvarchar(250) not null,
	dob datetime not null,
	doj datetime not null,
	balance decimal(10,6),
	mobileNo int not null,
	createdby varchar(250) not null,
	createddate datetime not null default(getdate())
)
go

sp_help[user]
go

CREATE TABLE Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
)
go

sp_help[account]
go

create table useraccountmapping (
    useraccountmappingid bigint not null identity(1,1) primary key,
    userid bigint not null,
    accountid bigint not null,
    createdby varchar(250) not null,
    createddate datetime not null default getdate(),
    foreign key (userid) references [user](userId),
    foreign key (accountid) references account(accountid)
)
go

create table [address] (
    addressid bigint not null identity(1,1) primary key,
    userid bigint not null,
    addressname nvarchar(max) not null,
    createdby varchar(250) not null,
    createddate datetime not null default getdate(),
    foreign key (userid) references [user](userid)
)
go

create table accounttransaction (
    accounttransactionid bigint not null identity(1,1) primary key,
    amount decimal(10,6) not null,
    isdebit bit not null,
    createdby varchar(250) not null,
    createddate datetime not null default getdate()
)
go

