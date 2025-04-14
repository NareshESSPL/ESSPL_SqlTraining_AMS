CREATE DATABASE AccManagement_system;
GO

USE AccManagement_system;
GO

CREATE SCHEMA AMS2;
GO
-- 1. User Table
CREATE TABLE AMS2.[User]
(
  UserID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  UserName NVARCHAR(250) NOT NULL,
  DOB DATETIME NOT NULL,
  DOJ DATETIME NOT NULL,
  Balance DECIMAL(10,6),
  MobileNo BIGINT NOT NULL,
  CreatedBy VARCHAR(250) NOT NULL,
  CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

-- 2. Account_New Table
CREATE TABLE AMS2.[Account_New]
(
  AccountID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  AccountNo INT NOT NULL,
  IsSaving BIT NOT NULL,
  UserID BIGINT NOT NULL,
  CreatedBy VARCHAR(250) NOT NULL,
  CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
  CONSTRAINT fk_User_ID FOREIGN KEY (UserID) REFERENCES AMS2.[User](UserID)
);

-- 3. Address Table
CREATE TABLE AMS2.[Address]
(
  AddressID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  UserID BIGINT NOT NULL,
  Address NVARCHAR(250) NOT NULL,
  CreatedBy VARCHAR(250) NOT NULL,
  CreateDate DATETIME NOT NULL DEFAULT GETDATE(),
  CONSTRAINT Fk_Add_User_ID FOREIGN KEY (UserID) REFERENCES AMS2.[User](UserID)
);

-- 4. Acctransaction Table
CREATE TABLE AMS2.[Acctransaction]
(
  AccountTransaction BIGINT IDENTITY(1,1) NOT NULL,
  Amount DECIMAL(10,6) NOT NULL PRIMARY KEY,
  IsDebit BIT NOT NULL,
  CreatedBy VARCHAR(250) NOT NULL,
  CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

-- 5. UserAccountMapping Table
CREATE TABLE AMS2.[UserAccountMapping]
(
  UserAccountMapping BIGINT IDENTITY(1,1) NOT NULL,
  UserID BIGINT NOT NULL,
  AccountID BIGINT NOT NULL,
  CreatedBy VARCHAR(250) NOT NULL,
  CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
  FOREIGN KEY(UserID) REFERENCES AMS2.[User](UserID),
  FOREIGN KEY(AccountID) REFERENCES AMS2.[Account_New](AccountID)
);
CREATE OR ALTER PROCEDURE AMS2.InsertFullUserAccountData
    @UserName NVARCHAR(250),
    @DOB DATETIME,
    @DOJ DATETIME,
    @Balance DECIMAL(10,6),
    @MobileNo BIGINT,
    @AccountNo INT,
    @IsSaving BIT,
    @Address NVARCHAR(250),
    @Amount DECIMAL(10,6),
    @IsDebit BIT,
    @CreatedBy VARCHAR(250) = 'admin'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserID BIGINT;
    DECLARE @AccountID BIGINT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insert into User
        INSERT INTO AMS2.[User](UserName, DOB, DOJ, Balance, MobileNo, CreatedBy)
        VALUES (@UserName, @DOB, @DOJ, @Balance, @MobileNo, @CreatedBy);

        SET @UserID = SCOPE_IDENTITY();

        -- 2. Insert into Account_New
        INSERT INTO AMS2.[Account_New](AccountNo, IsSaving, UserID, CreatedBy)
        VALUES (@AccountNo, @IsSaving, @UserID, @CreatedBy);

        SET @AccountID = SCOPE_IDENTITY();

        -- 3. Insert into Address
        INSERT INTO AMS2.[Address](UserID, Address, CreatedBy)
        VALUES (@UserID, @Address, @CreatedBy);

        -- 4. Insert into Acctransaction
        INSERT INTO AMS2.[Acctransaction](Amount, IsDebit, CreatedBy)
        VALUES (@Amount, @IsDebit, @CreatedBy);

        -- 5. Insert into UserAccountMapping
        INSERT INTO AMS2.[UserAccountMapping](UserID, AccountID, CreatedBy)
        VALUES (@UserID, @AccountID, @CreatedBy);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
EXEC AMS2.InsertFullUserAccountData
    @UserName = 'Ravi',
    @DOB = '1990-06-15',
    @DOJ = '2022-01-01',
    @Balance = 1500.75,
    @MobileNo = 98,
    @AccountNo = 10001,
    @IsSaving = 1,
    @Address = 'Hyderabad',
    @Amount = 25,
    @IsDebit = 0,
    @CreatedBy = 'system';
SELECT * FROM AMS2.[User];
SELECT * FROM AMS2.[Account_New];
SELECT * FROM AMS2.[Address];
SELECT * FROM AMS2.[Acctransaction];
SELECT * FROM AMS2.[UserAccountMapping];

