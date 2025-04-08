CREATE DATABASE AccountManagementSystem;
go



USE AccountManagementSystem;
go



CREATE SCHEMA AMS;
go



CREATE TABLE AMS.[User](
UserID BIGINT IDENTITY(1, 1) PRIMARY KEY, 
UserName NVARCHAR(250) NOT NULL,
DOB DATETIME NOT NULL,
DOJ DATETIME NOT NULL,
Balance DECIMAL(10, 6),
MobileNo INT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go



CREATE TABLE AMS.[Account](
AccountID BIGINT IDENTITY(1, 1) PRIMARY KEY, 
AccountNo INT NOT NULL,
IsSaving BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go



CREATE TABLE AMS.[UserAccountMapping](
UserAccountMapping BIGINT IDENTITY(1, 1) PRIMARY KEY,
UserID BIGINT NOT NULL FOREIGN KEY REFERENCES AMS.[User],
AccountNo BIGINT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go



CREATE TABLE AMS.[Address](
AddressID BIGINT IDENTITY(1, 1) PRIMARY KEY,
UserID BIGINT NOT NULL FOREIGN KEY REFERENCES AMS.[User],
Addresss NVARCHAR(MAX) NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go




CREATE TABLE AMS.[AccountTransaction](
AccountTransaction BIGINT IDENTITY(1,1) PRIMARY KEY,
Amount DECIMAL(10,6) NOT NULL,
IsDebit BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go