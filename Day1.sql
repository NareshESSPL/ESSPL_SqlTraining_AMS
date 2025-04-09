use AccountManagementSystem
go
select * from sys.tables;
create table AMS.[user](
	UserId Bigint Not Null Identity(1,1) primary key,
	UserName Nvarchar(250) not null,
	DOB Datetime not null,
	DOJ datetime not null,
	Balance Decimal(10,6) null,
	MobileNo int not null,
	CreatedBy varchar(250) not null,
	CreatedDate datetime not null default getdate()

);

exec sp_help 'AMS.[user]';

create table AMS.[Account](
	AccountId bigint not null identity(1,1) primary key,
	AccountNo int not null,
	IsSaving bit not null,
	CreatedBy varchar(250) not null,
	CreatedDate datetime not null default getdate()
);
exec sp_help 'AMS.[Account]';

create table AMS.[UserAccountMapping](
	UserAccountMapping bigint not null identity(1,1) primary key,
	UserId bigint not null foreign key references AMS.[user](UserId),
	AccountId bigint not null ,
	CreatedBy varchar(250) not null,
	CreatedDate datetime not null default getdate()
);
exec sp_help 'AMS.[UserAccountMapping]';

create table AMS.[Address](
	AddressId bigint not null identity(1,1) primary key,
	UserId bigint not null foreign key references AMS.[user](UserId),
	Address NVarchar(max) not null,
	CreatedBy varchar(250) not null,
	CreatedDate datetime not null default getdate()
);
exec sp_help 'AMS.[Address]';
create table AMS.[AccountTransaction](
	AccountTransaction bigint not null identity(1,1) primary key,
	Amount decimal(10,6) not null,
	IsDebit bit not null,
	CreatedBy varchar(250) not null,
	CreateDate datetime not null default getdate()
);
exec sp_help 'AMS.[AccountTransaction]';