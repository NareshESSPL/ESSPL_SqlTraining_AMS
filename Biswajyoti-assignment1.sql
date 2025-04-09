CREATE DATABASE AccountManagementSystem
go

USE AccountManagementSystem
go

CREATE SCHEMA AMS;
GO

CREATE TABLE AMS.[User](
UserID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
DateOfBirth DATETIME NOT NULL,
DateOfJoining DATETIME NOT NULL,
Balance DECIMAL(10,6),
MobileNumber INT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

ALTER TABLE AMS.[User]
ALTER COLUMN MobileNumber BIGINT;

select * from AMS.[User];

INSERT INTO AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy, CreatedDate)
VALUES
    ('Jane', '1990-01-01', '2025-04-08', 1000.50, 1234567890, 'Admin', CURRENT_TIMESTAMP),
    ('Anant', '1985-03-15', '2025-04-08', NULL, 9876543210, 'Admin', CURRENT_TIMESTAMP),
    ('Brown', '1992-07-22', '2025-04-08', 500.00, 1122334455, 'Admin', CURRENT_TIMESTAMP);





CREATE TABLE AMS.[Account](
AccountID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
IsSaving BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

select * from AMS.[Account];

INSERT INTO AMS.[Account] (UserName, IsSaving, CreatedBy, CreatedDate)
VALUES
    ( 'ABC', 0, 'Admin', CURRENT_TIMESTAMP),
    ('DHF', 1, 'Admin', CURRENT_TIMESTAMP),
    ('adsd', 1, 'Admin', CURRENT_TIMESTAMP);





CREATE TABLE AMS.[UserAccountMapping](
UserAccountMappingID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																													
AccountID BIGINT NOT NULL,		
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()

CONSTRAINT FK_UserAccountMapping_User FOREIGN KEY(UserID)
REFERENCES AMS.[User](UserID),
CONSTRAINT
FK_UserAccountMapping_Account FOREIGN KEY (AccountID)
REFERENCES AMS.[Account](AccountID)
);

select * from AMS.[UserAccountMapping];
INSERT INTO AMS.[UserAccountMapping] (UserID, AccountID, CreatedBy, CreatedDate)
VALUES
    ( 11, 1, 'Admin', CURRENT_TIMESTAMP),
    ( 12, 2, 'Admin', CURRENT_TIMESTAMP),
    ( 13, 3, 'Admin', CURRENT_TIMESTAMP);




CREATE TABLE AMS.[Address](
AddressID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,
Address NVARCHAR(MAX) NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Address_User
FOREIGN KEY(UserID)
REFERENCES AMS.[User](UserID)
);

select * from AMS.[Address];

INSERT INTO AMS.[Address] (UserID, Address, CreatedBy, CreatedDate)
VALUES
    ( 11,  'Vani vihar', 'Admin', CURRENT_TIMESTAMP),
    ( 12, 'jaydev vihar' , 'Admin', CURRENT_TIMESTAMP),
    ( 13, 'acharya vihar', 'Admin', CURRENT_TIMESTAMP);





CREATE TABLE AMS.[AccountTransaction](
AccountTransactionID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
AccountID BIGINT NOT NULL,
Amount DECIMAL(10,6) NOT NULL,
IdDebt BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Transaction_Account
FOREIGN KEY(AccountID)
REFERENCES AMS.[Account](AccountID)
);

select * from AMS.[AccountTransaction];

INSERT INTO AMS.[AccountTransaction] (AccountID, Amount, IdDebt, CreatedBy, CreatedDate)
VALUES
    ( 1, 1000.50, 0, 'Admin', CURRENT_TIMESTAMP),
    ( 2, 100, 1, 'Admin', CURRENT_TIMESTAMP),
    ( 3, 500.00, 0, 'Admin', CURRENT_TIMESTAMP);








