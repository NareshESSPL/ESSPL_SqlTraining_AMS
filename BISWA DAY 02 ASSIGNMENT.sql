DROP DATABASE BankSystem

USE BankSystem
go

CREATE SCHEMA BS;
GO

CREATE TABLE BS.[User](
UserID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
DateOfBirth DATETIME NOT NULL,
DateOfJoining DATETIME NOT NULL,
Balance DECIMAL(10,6),
MobileNumber BIGINT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE ()
);

select * from BS.[User];

	DELETE FROM BS.[User] 
	DBCC CHECKIDENT ('BS.[User]', RESEED,0)



CREATE TABLE BS.[Account](
AccountID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
AccountNo INT NOT NULL,
UserName NVARCHAR(250) NOT NULL,
IsSaving BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

select * from BS.[Account];


	delete from bs.Account
	DBCC CHECKIDENT ('BS.[Account]', RESEED, 0)






CREATE TABLE BS.[UserAccountMapping](
UserAccountMappingID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																													
AccountID BIGINT NOT NULL,		
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()

CONSTRAINT FK_UserAccountMapping_User FOREIGN KEY(UserID)
REFERENCES BS.[User](UserID),
CONSTRAINT
FK_UserAccountMapping_Account FOREIGN KEY (AccountID)
REFERENCES BS.[Account](AccountID)
);

select * from BS.[UserAccountMapping];

	delete from bs.UserAccountMapping
	DBCC CHECKIDENT ('BS.[UserAccountMapping]', RESEED, 0)




CREATE TABLE BS.[Address](
AddressID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,
Address NVARCHAR(MAX) NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Address_User
FOREIGN KEY(UserID)
REFERENCES BS.[User](UserID)
);

select * from BS.[Address];

	--	Delete from AMS.[Address];

	--DBCC CHECKIDENT ('AMS.[Address]', RESEED, 0)




CREATE TABLE BS.[AccountTransaction](
AccountTransactionID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
AccountID BIGINT NOT NULL,
Amount DECIMAL(10,6) NOT NULL,
IdDebt BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Transaction_Account
FOREIGN KEY(AccountID)
REFERENCES BS.[Account](AccountID)
);

select * from BS.[AccountTransaction];

	--Delete from AMS.[AccountTransaction];

	--DBCC CHECKIDENT ('AMS.[AccountTransaction]', RESEED, 0)




GO

CREATE PROCEDURE Proceed_four
    @UserName NVARCHAR(250),
    @DOB DATETIME,
    @DOJ DATETIME,
    @Balance DECIMAL(10, 6),
    @AccountNo INT,
    @IsSaving BIT,
    @MobileNo BIGINT,
    @Address NVARCHAR(MAX),
    @Amount DECIMAL(10, 6),
    @IdDebt BIT,
    @CreatedBy VARCHAR(250) = 'defaultUser'
AS
BEGIN
    DECLARE @UserID BIGINT
    DECLARE @AccountID BIGINT

    INSERT INTO BS.[User] (UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy, CreatedDate)
    VALUES (@UserName, @DOB, @DOJ, @Balance, @MobileNo, @CreatedBy, CURRENT_TIMESTAMP)

    SET @UserID = SCOPE_IDENTITY()

    INSERT INTO BS.[Account] (UserName, AccountNo, IsSaving, CreatedBy, CreatedDate)
    VALUES (@UserName, @AccountNo, @IsSaving, @CreatedBy, CURRENT_TIMESTAMP)

    SET @AccountID = SCOPE_IDENTITY()

    INSERT INTO BS.[UserAccountMapping] (UserID, AccountID, CreatedBy, CreatedDate)
    VALUES (@UserID, @AccountID, @CreatedBy, CURRENT_TIMESTAMP)

    INSERT INTO BS.[Address] (UserID, Address, CreatedBy, CreatedDate)
    VALUES (@UserID, @Address, @CreatedBy, CURRENT_TIMESTAMP)

    INSERT INTO BS.[AccountTransaction] (AccountID, Amount, IdDebt, CreatedBy, CreatedDate)
    VALUES (@AccountID, @Amount, @IdDebt, @CreatedBy, CURRENT_TIMESTAMP)
END
GO

--SELECT * FROM sys.objects WHERE type = 'P' AND name = 'Proceed_four';

EXEC Proceed_four 'Ravi Kumar', '1990-05-15', '2025-04-09', 100.0, 789, 1, 9876543210, 'Mumbai, Maharashtra', 500.0, 0;
EXEC Proceed_four 'Ayesha Singh', '1985-08-20', '2025-04-09', 200.0, 123, 0, 9876123456, 'Delhi, India', 1000.50, 1;
EXEC Proceed_four 'Manoj Reddy', '1992-11-25', '2025-04-09', 150.0, 456, 1, 9101112131, 'Hyderabad, Telangana', 1500.0, 0;
EXEC Proceed_four 'Priya Sharma', '1995-02-14', '2025-04-09', 250.0, 789, 1, 8445566778, 'Bengaluru, Karnataka', 2000.55, 0;
EXEC Proceed_four 'Rahul Patel', '1987-07-30', '2025-04-09', 180.0, 321, 0, 9034567890, 'Ahmedabad, Gujarat', 1200.66, 1;

GO

SELECT * FROM BS.[User];
SELECT * FROM BS.[Account];
SELECT * FROM BS.[UserAccountMapping];
SELECT * FROM BS.[Address];
SELECT * FROM BS.[AccountTransaction];
