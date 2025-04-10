CREATE DATABASE BankDBAssign1

CREATE TABLE [user](
	UserID BIGINT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Username NVARCHAR(250) NOT NULL,
	DOB DATETIME NOT NULL,
	DOJ DATETIME NOT NULL,
	Balance DECIMAL(10,6) NULL,
	Mobileno INT NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
	);

ALTER TABLE [user] DROP CONSTRAINT DF__user__CreatedDat__1293BD5E;

ALTER TABLE [user] DROP COLUMN CreatedDate;

ALTER TABLE [user]
ADD CreatedBY VARCHAR(250) NOT NULL;

ALTER TABLE [user]
ADD CreatedDate DATETIME NOT NULL DEFAULT GETDATE();

SELECT * FROM [user];

CREATE TABLE ACCOUNT(
	AccountID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	AccountNo INT NOT NULL,
	IsSaving BIT NOT NULL,
	CreatedBY VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
	);

Select * FROM ACCOUNT;

CREATE TABLE UsrerAccountMapping(
	UsrerAccountMapping BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	UserID BIGINT NOT NULL,
	AccountID BIGINT NOT NULL,
	CreatedBY VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_UserId] FOREIGN KEY (UserID) REFERENCES [User](UserID)
	);

SELECT * FROM UsrerAccountMapping;

/*CREATE TABLE UserAddress(
	AddressID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	UserID BIGINT NOT NULL,
	Address NVARCHAR(MAX) NOT NULL,
	CreatedBY VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [FK_Address_UserId] FOREIGN KEY (UserID) REFERENCES [User](UserID)
	);*/

/*CREATE TABLE UserAddress(
	AddressID BIGINT NOT NULL IDENTITY(1,1),
	UserID BIGINT NOT NULL,
	Address NVARCHAR(MAX) NOT NULL,
	CreatedBY VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Person PRIMARY KEY (AddressID)
	CONSTRAINT [FK_Address_UserId] FOREIGN KEY (UserID) REFERENCES [User](UserID)

	);*/

CREATE TABLE UserAddress(
	AddressID BIGINT NOT NULL IDENTITY(1,1),
	UserID BIGINT NOT NULL,
	Address NVARCHAR(MAX) NOT NULL,
	CreatedBY VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Person PRIMARY KEY (AddressID),
	CONSTRAINT [FK_Address_UserId] FOREIGN KEY (UserID) REFERENCES [User](UserID)
	);

SELECT * FROM UserAddress;

CREATE TABLE AccountTransaction(
	AccountTransaction BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Amount DECIMAL(10,6) NOT NULL,
	IsDebit BIT NOT NULL,
	CreatedBY VARCHAR(250) NOT NULL,
	CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
	);

SELECT * FROM AccountTransaction;

DROP TABLE UserAddress
