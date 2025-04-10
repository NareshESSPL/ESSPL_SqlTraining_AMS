use AccountManagementSystem;

drop table AMS.[UserAccountMapping];
drop table AMS.[AccountTransaction];
drop table AMS.[Account];
drop table AMS.[Address];
drop table AMS.[User];
drop table AMS.[CreditCard];
drop table AMS.[CreditCardOffer];
drop table AMS.[Employee];

CREATE TABLE AMS.[User]
(
  UserID BigInt Identity(1,1) Not Null,
  UserName NVarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  AccountNo Int Not Null,
  MobileNo BigInt Not Null,
  CreatedBy Varchar(250) Not Null,
  Created DateTime Not Null,
 );

ALTER TABLE AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID]  PRIMARY KEY  (UserID);

ALTER TABLE AMS.[User]
ADD CONSTRAINT DF_AMS_User_Created DEFAULT GETDATE() FOR Created;

CREATE PROCEDURE AMS.InsertUser
    @UserName NVARCHAR(250),
    @DOB DATETIME,
    @DOJ DATETIME,
    @Balance DECIMAL(10,6) = NULL,
    @AccountNo INT,
    @MobileNo BIGINT,
    @CreatedBy VARCHAR(250),
    @Created DATETIME = NULL
AS
BEGIN
    IF @Created IS NULL
        SET @Created = GETDATE();

    INSERT INTO AMS.[User] 
    (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy, Created)
    VALUES 
    (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy, @Created);
END;

-- 1
EXEC AMS.InsertUser 
    @UserName = N'John Doe',
    @DOB = '1990-01-15',
    @DOJ = '2015-06-01',
    @Balance = 1234.8901,
    @AccountNo = 1001,
    @MobileNo = 987654,
    @CreatedBy = 'admin';

-- 2
EXEC AMS.InsertUser 
    @UserName = N'Jane Smith',
    @DOB = '1985-12-20',
    @DOJ = '2026-01-01',
    @Balance = NULL,
    @AccountNo = 1002,
    @MobileNo = 912345,
    @CreatedBy = 'system',
    @Created = '2026-01-01';

-- 3
EXEC AMS.InsertUser 
    @UserName = N'Robert Brown',
    @DOB = '1975-05-30',
    @DOJ = '2010-03-15',
    @Balance = 0.123456,
    @AccountNo = 1003,
    @MobileNo = 9988776655,
    @CreatedBy = 'admin',
    @Created = '1975-05-30';

-- 4
EXEC AMS.InsertUser 
    @UserName = N'Nikhil Ramesh Chandrashekharanathan',
    @DOB = '1992-09-09',
    @DOJ = '2018-12-12',
    @Balance = 9874.3211,
    @AccountNo = 1004,
    @MobileNo = 9112233445,
    @CreatedBy = 'hr_team',
    @Created = '2025-01-01';

-- 5
EXEC AMS.InsertUser 
    @UserName = N'Meena Kumari',
    @DOB = '2000-07-07',
    @DOJ = '2000-07-07',
    @Balance = 500.50000,
    @AccountNo = 1005,
    @MobileNo = 9001122334,
    @CreatedBy = 'support';

-- 6
EXEC AMS.InsertUser 
    @UserName = N'Alex Thomas',
    @DOB = '1992-02-29',
    @DOJ = '2020-10-10',
    @Balance = 123.000456,
    @AccountNo = 1006,
    @MobileNo = 9090909090,
    @CreatedBy = 'admin';

select * from AMS.[User];

CREATE TABLE AMS.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);


ALTER TABLE AMS.Account
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR Created;

CREATE PROCEDURE AMS.InsertAccount
    @AccountNo INT,
    @IsSaving BIT,
    @CreatedBy VARCHAR(250)
AS
BEGIN
    INSERT INTO AMS.Account (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy);
END;

EXEC AMS.InsertAccount @AccountNo = 1003, @IsSaving = 1, @CreatedBy = 'admin';

EXEC AMS.InsertAccount @AccountNo = 1003, @IsSaving = 0, @CreatedBy = 'admin';

EXEC AMS.InsertAccount @AccountNo = 1004, @IsSaving = 0, @CreatedBy = 'hr_team';

EXEC AMS.InsertAccount @AccountNo = 1001, @IsSaving = 1, @CreatedBy = 'hr_team';

EXEC AMS.InsertAccount @AccountNo = 1008, @IsSaving = 1, @CreatedBy = 'john_admin';

EXEC AMS.InsertAccount @AccountNo = 1009, @IsSaving = 0, @CreatedBy = 'system';

EXEC AMS.InsertAccount @AccountNo = 2004, @IsSaving = 1, @CreatedBy = 'hr_team';

EXEC AMS.InsertAccount @AccountNo = 3003, @IsSaving = 0, @CreatedBy = 'admin';

select * from AMS.[Account];

CREATE TABLE AMS.[Address] (
    AddressID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AddressDetail NVARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT PK_AMS_Address_AddressID PRIMARY KEY (AddressID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

CREATE PROCEDURE AMS.InsertAddress
    @UserID BIGINT,
    @AddressDetail NVARCHAR(MAX),
    @CreatedBy VARCHAR(250)
AS
BEGIN
    INSERT INTO AMS.Address (UserID, AddressDetail, CreatedBy)
    VALUES (@UserID, @AddressDetail, @CreatedBy);
END;

EXEC AMS.InsertAddress 
    @UserID = 3,
    @AddressDetail = N'221B Baker Street, London',
    @CreatedBy = 'admin';

EXEC AMS.InsertAddress 
    @UserID = 4,
    @AddressDetail = N'Plot No 55, Sector 21, Mumbai',
    @CreatedBy = 'hr_team';

EXEC AMS.InsertAddress 
    @UserID = 5,
    @AddressDetail = N'D-1201, Lake View Apartments, Bangalore',
    @CreatedBy = 'support';

EXEC AMS.InsertAddress 
    @UserID = 7,
    @AddressDetail = N'44 Elm Street, Pune',
    @CreatedBy = 'admin';

EXEC AMS.InsertAddress 
    @UserID = 8,
    @AddressDetail = N'Green Enclave, Flat 2B, Hyderabad',
    @CreatedBy = 'john_admin';

EXEC AMS.InsertAddress 
    @UserID = 9,
    @AddressDetail = N'45 South Avenue, Delhi',
    @CreatedBy = 'system';

select * from AMS.[address];

CREATE TABLE AMS.AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
  AccountID INT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

alter table AMS.AccountTransaction alter column AccountID BIGINT NOT NULL;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

CREATE PROCEDURE AMS.InsertAccountTransaction
    @AccountID BIGINT,
    @Amount DECIMAL(10,6),
    @IsDebit BIT,
    @CreatedBy VARCHAR(250)
AS
BEGIN
    INSERT INTO AMS.AccountTransaction (AccountID, Amount, IsDebit, CreatedBy)
    VALUES (@AccountID, @Amount, @IsDebit, @CreatedBy);
END;

EXEC AMS.InsertAccountTransaction 
    @AccountID = 1, 
    @Amount = 50.12, 
    @IsDebit = 1, 
    @CreatedBy = 'admin';

EXEC AMS.InsertAccountTransaction 
    @AccountID = 2, 
    @Amount = 12.00, 
    @IsDebit = 0, 
    @CreatedBy = 'system';

EXEC AMS.InsertAccountTransaction 
    @AccountID = 3, 
    @Amount = 75.65, 
    @IsDebit = 1, 
    @CreatedBy = 'admin';

EXEC AMS.InsertAccountTransaction 
    @AccountID = 4, 
    @Amount = 250.05, 
    @IsDebit = 0, 
    @CreatedBy = 'hr_team';

EXEC AMS.InsertAccountTransaction 
    @AccountID = 5, 
    @Amount = 100.99, 
    @IsDebit = 1, 
    @CreatedBy = 'support';

EXEC AMS.InsertAccountTransaction 
    @AccountID = 6, 
    @Amount = 300.30, 
    @IsDebit = 0, 
    @CreatedBy = 'john_admin';

EXEC AMS.InsertAccountTransaction 
    @AccountID = 1, 
    @Amount = 89.09, 
    @IsDebit = 1, 
    @CreatedBy = 'admin';

select * from AMS.[AccountTransaction];

CREATE TABLE AMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT PK_AMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE c
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

CREATE PROCEDURE AMS.InsertUserAccountMapping
    @UserID BIGINT,
    @AccountID BIGINT,
    @CreatedBy VARCHAR(250)
AS
BEGIN
    INSERT INTO AMS.UserAccountMapping (UserID, AccountID, CreatedBy)
    VALUES (@UserID, @AccountID, @CreatedBy);
END;

select * from AMS.[UserAccountMapping];

EXEC AMS.InsertUserAccountMapping @UserID = 3, @AccountID = 4, @CreatedBy = 'admin';

EXEC AMS.InsertUserAccountMapping @UserID = 4, @AccountID = 8, @CreatedBy = 'hr_team';

EXEC AMS.InsertUserAccountMapping @UserID = 5, @AccountID = 1, @CreatedBy = 'support';

EXEC AMS.InsertUserAccountMapping @UserID = 7, @AccountID = 3, @CreatedBy = 'admin';

EXEC AMS.InsertUserAccountMapping @UserID = 5, @AccountID = 2, @CreatedBy = 'john_admin';

EXEC AMS.InsertUserAccountMapping @UserID = 9, @AccountID = 9, @CreatedBy = 'system';

CREATE PROCEDURE AMS.Proc_GetUserAccountDetails
AS
BEGIN
    SELECT 
        U.UserID,
        U.UserName,
        U.DOB,
        U.DOJ,
        U.Balance,
        A.AccountID,
        A.AccountNo,
        A.IsSaving,
        UAM.CreatedBy AS MappingCreatedBy
    FROM 
        AMS.[User] U
    JOIN 
        AMS.UserAccountMapping UAM ON U.UserID = UAM.UserID
    JOIN 
        AMS.Account A ON UAM.AccountID = A.AccountID;
END
EXEC AMS.Proc_GetUserAccountDetails;

CREATE PROCEDURE AMS.Proc_GetUsersWithAboveAverageBalance
AS
BEGIN
    -- Declare a variable to hold the average balance
    DECLARE @AverageBalance DECIMAL(10, 6);

    -- Calculate the average balance
    SELECT @AverageBalance = AVG(Balance) FROM AMS.[User];

    -- Select users with balance greater than the average balance along with their account details
    SELECT 
        U.UserID,
        U.UserName,
        U.Balance,
        A.AccountID,
        A.AccountNo,
        A.IsSaving
    FROM 
        AMS.[User] U
    JOIN 
        AMS.UserAccountMapping UAM ON U.UserID = UAM.UserID
    JOIN 
        AMS.Account A ON UAM.AccountID = A.AccountID
    WHERE 
        U.Balance > @AverageBalance;
END

EXEC AMS.Proc_GetUsersWithAboveAverageBalance;

CREATE PROCEDURE AMS.Proc_GetUsersWithoutAddress AS
BEGIN
    -- Select users who do not have an associated address
    SELECT 
        U.UserID,
        U.UserName,
        U.DOB,
        U.DOJ,
        U.Balance,
        U.MobileNo
    FROM 
        AMS.[User] U
    LEFT JOIN 
        AMS.[Address] A ON U.UserID = A.UserID
    WHERE 
        A.AddressID IS NULL;
END

EXEC AMS.Proc_GetUsersWithoutAddress;
