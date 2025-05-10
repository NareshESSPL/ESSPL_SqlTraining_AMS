/*Find Users who does not have account with join/subquery,
Find User, Account detail for User who has avrerage salary of more than 10000*/

Create database UserAccountMapping

use UserAccountMapping

create Schema UM;

------------------------------------------------------------------------

--Creating Tables User, Account, UserAccountMapping


--User
CREATE TABLE UM.[User] (
    UserID BIGINT NOT NULL IDENTITY(1,1),
    UserName NVARCHAR(250) NOT NULL,
    DOB DATETIME NOT NULL,
    DOJ DATETIME NOT NULL,
    Balance DECIMAL(10,6) NULL,
    MobileNo INT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_UM_User_UserID]  PRIMARY KEY  (UserID)
);

SELECT * FROM UM.[User]

INSERT INTO UM.[User] (UserName, DOB, DOJ, Balance, MobileNo, CreatedBy)
VALUES 
('Apit', '1990-01-01', '2020-01-01', 15000.00, 12345678, 'admin'),
('Bhupi', '1985-03-05', '2019-06-01', 9900.00, 12345691, 'admin'),
('Creed', '1992-07-10', '2021-03-20', 12000.00, 12367892, 'admin'),
('Divu', '1994-09-15', '2021-07-11', 10000.00, 12367893, 'admin');

ALTER TABLE UM.[User]
ALTER COLUMN Balance DECIMAL(12,2);

DELETE FROM UM.[User];
DBCC CHECKIDENT ('UM.[User]', RESEED, 0);


--Account

CREATE TABLE UM.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT [PK_UM_Account_UserID]  PRIMARY KEY  (AccountID)
);

INSERT INTO UM.Account (AccountNo, IsSaving, CreatedBy)
VALUES 
(10101, 1, 'admin'),
(10102, 0, 'admin'),
(10103, 1, 'admin');
SELECT * FROM UM.Account


--UserAccountMapping
CREATE TABLE UM.UserAccountMapping (
    UserAccountMapping BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
	CONSTRAINT [PK_UM_UserAccountMappingID]  PRIMARY KEY  (UserAccountMapping),
	CONSTRAINT [FK_UM_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES UM.[User](UserID),
	CONSTRAINT [FK_UM_UserAccountMapping_AccountID] FOREIGN KEY (UserID) REFERENCES UM.Account(AccountID)
);

INSERT INTO UM.UserAccountMapping (UserID, AccountID, CreatedBy)
VALUES
(1, 1, 'admin'),
(3, 2, 'admin');

DELETE FROM UM.UserAccountMapping;
DBCC CHECKIDENT ('UM.UserAccountMapping', RESEED, 0);

SELECT * FROM UM.UserAccountMapping

----------------------------------------------------------------------------------------------------

--PROCEDURE TO MAKE JOIN BETWEEN THE User, Account, UserAccountMapping

CREATE PROCEDURE GetUserAccountDetails
AS
BEGIN
    SELECT * FROM UM.[User] u
    JOIN UM.UserAccountMapping map ON u.UserID = map.UserID
    JOIN UM.Account a ON map.AccountID = a.AccountID;
END;

EXEC GetUserAccountDetails;


-----------------------------------------------------------------------------

--find the users who does not have accounts

SELECT * FROM UM.[User] u
LEFT JOIN UM.UserAccountMapping map ON map.UserID = u.UserID
WHERE map.AccountID IS NULL;


------------------------------------------------------------------------------

--Find User, Account detail for User who has avrerage balance of more than 10000

SELECT u.UserID, u.UserName, u.Balance, a.AccountNo, a.IsSaving
FROM UM.[User] u
JOIN UM.UserAccountMapping map ON u.UserID = map.UserID
JOIN UM.Account a ON map.AccountID = a.AccountID
WHERE u.UserID IN (
    SELECT UserID
    FROM UM.[User]
    GROUP BY UserID
    HAVING AVG(Balance) > 10000
);