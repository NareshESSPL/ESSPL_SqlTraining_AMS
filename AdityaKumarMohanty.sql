SELECT name
FROM sys.databases;

USE test;

CREATE SCHEMA AMS;

/*
User

	UserID	BigInt	Not Null	Autoincrement	Primary Key
	UserName	Nvarchar(250)	Not Null		
	DOB	DateTime	Not Null	
	DOJ	DateTime	Not Null		
	Balance	Decimal(10,6)	Nullable		
	MobileNo	Int	Not Null		
	CreatedBy	Varchar(250)	Not Null		
	CreatedDate	DateTime	Not Null	Default Current Date	

*/


CREATE TABLE AMS.[User] (
	
	UserID BIGINT NOT NULL IDENTITY(1,1) PRiMARY KEY,
	UserName NVARCHAR(250) NOT NULL,
	DOB DATETIME NOT NULL,
	DOJ DATETIME NOT NULL,
	Balance DECIMAL(10,6) NULL,
	MobileNo INT NOT NULL,
	CreatedBy DATETIME NOT NULL,
	CreeatedDate DATETIME NOT NULL DEFAULT GETDATE(),


);
/*
Account			

	AccountID	BigInt	Not Null	Autoincrement	Primary Key
	AccountNo	Int	Not Null		
	IsSaving	Bit	Not Null		
	CreatedBy	Varchar(250)	Not Null		
	CreatedDate	DateTime	Not Null	Default Current Date	

*/

CREATE TABLE AMS.Account(
	
	AcountID BIGINT NOT NULL,
	AccountNo INT NOT NULL,
	IsSaving BIT NOT NULL,
	CreatedBy VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

/*
UsrerAccountMapping		

	UsrerAccountMapping	BigInt	Not Null	Autoincrement	Primary Key
	UserID	BigInt	Not Null		Foreign Key
	AccountID	BigInt	Not Null		
	CreatedBy	Varchar(250)	Not Null		
	CreatedDate	DateTime	Not Null	Default Current Date	

*/

CREATE  TABLE AMS.UserAccountMapping (
	
	UserAccountMapping BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	UserID BIGINT NOT NULL,
	AccountID BIGINT NOT NULL,
	CreatedBy VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY(UserID) REFERENCES AMS.[User](UserID),


);

/*
Address		

	AddressID	BigInt	Not Null	Autoincrement	Primary Key
	UserID	BigInt	Not Null		Foreign Key
	Address	NVarchar(max)	Not Null		
	CreatedBy	Varchar(250)	Not Null		
	CreatedDate	DateTime	Not Null	Default Current Date	

*/

CREATE TABLE AMS.Address (
	AddressID BIGINT NOT NULL,
	UserID BIGINT NOT NULL,
	Address NVARCHAR(MAX) NOT NULL,
	CreatedBy VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	FOREIGN KEY(UserID) REFERENCES AMS.[User](UserID)
);

/*
AccountTransaction		

	AccountTransaction	BigInt	Not Null	Autoincrement	Primary Key
	Amount	Decimal(10,6)	Not Null		
	IsDebit	Bit	Not Null		
	CreatedBy	Varchar(250)	Not Null		
	CreatedDate	DateTime	Not Null	Default Current Date	

*/

CREATE TABLE AMS.AccountTransaction (
	
	AccountTransaction BIGINT NOT NULL,
	Amount DECIMAL(10,6) NOT NULL,
	IsDebit BIT NOT NULL,
	CreatedBy VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);


