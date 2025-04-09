USE AccountManagementSystem
GO

CREATE PROCEDURE AMS.Proc_User_Insert
AS
BEGIN
  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
  VALUES
  ('userA', '1990-05-10', '2025-05-10', 1000, 23456, 123456, 'admin'),
  ('userB', '1992-07-15', '2025-07-15', 1500, 34567, 654321, 'admin')
END
GO

EXEC AMS.Proc_User_Insert
GO

SELECT * FROM AMS.[User]
GO

ALTER PROCEDURE AMS.Proc_User_Insert
  @UserName NVARCHAR(250),
  @DOB DATETIME,
  @DOJ DATETIME,
  @Balance DECIMAL(10, 6),
  @AccountNo INT,
  @MobileNo INT,
  @CreatedBy VARCHAR(250)
AS
BEGIN
  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
  VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
END
GO

EXEC AMS.Proc_User_Insert 'userC', '1995-11-20', '2025-11-20', 1200, 56789, 789123, 'admin'
GO

ALTER PROCEDURE AMS.Proc_User_Insert
  @UserName NVARCHAR(250),
  @DOB DATETIME,
  @DOJ DATETIME,
  @Balance DECIMAL(10, 6),
  @AccountNo INT,
  @MobileNo INT,
  @CreatedBy VARCHAR(250) = 'defaultuser'
AS
BEGIN
  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
  VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
END
GO

EXEC AMS.Proc_User_Insert 'userD', '1993-12-10', '2025-12-10', 1300, 67890, 321654
GO

ALTER PROCEDURE AMS.Proc_UserAndAddress_Insert
  @UserName NVARCHAR(250),
  @DOB DATETIME,
  @DOJ DATETIME,
  @Balance DECIMAL(10, 6),
  @AccountNo INT,
  @MobileNo INT,
  @AddressDetail NVARCHAR(MAX),
  @CreatedBy VARCHAR(250) = 'defaultuser'
AS
BEGIN
  DECLARE @UserId BIGINT

  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
  VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

  SET @UserId = SCOPE_IDENTITY()

  INSERT INTO AMS.[Address](UserId, AddressDetail, CreatedBy)
  VALUES (@UserId, @AddressDetail, @CreatedBy)
END
GO

EXEC AMS.Proc_UserAndAddress_Insert 'userE', '1996-08-11', '2025-08-11', 1400, 78901, 654789, 'Los Angeles', 'admin'
EXEC AMS.Proc_UserAndAddress_Insert 'userF', '1998-09-14', '2025-09-14', 800, 23456, 987654, 'New York', 'admin'
EXEC AMS.Proc_UserAndAddress_Insert 'userG', '1999-03-07', '2025-03-07', 1700, 34567, 654987, 'Chicago', 'admin'
GO

SELECT * FROM AMS.[User]
SELECT * FROM AMS.[Address]
GO

ALTER PROCEDURE AMS.Proc_AccountDetail_Insert
  @AccountNo INT,
  @IsSaving BIT,
  @CreatedBy VARCHAR(250) = 'defaultuser'
AS
BEGIN
  INSERT INTO AMS.[Account] (AccountNo, IsSaving, CreatedBy)
  VALUES (@AccountNo, @IsSaving, @CreatedBy)
END
GO

EXEC AMS.Proc_AccountDetail_Insert 901, 1;
EXEC AMS.Proc_AccountDetail_Insert 202, 0;
GO

CREATE PROCEDURE AMS.Proc_UserAccountMapping_Insert
  @UserName NVARCHAR(250),
  @DOB DATETIME,
  @DOJ DATETIME,
  @Balance DECIMAL(10, 6),
  @AccountNo INT,
  @MobileNo INT,
  @IsSaving BIT,
  @CreatedBy VARCHAR(200) = 'defaultuser'
AS
BEGIN
  DECLARE @UserID BIGINT
  DECLARE @AccountID BIGINT
 
  INSERT INTO AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy)
  VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)
 
  SET @UserID = SCOPE_IDENTITY()
 
  INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
  VALUES (@AccountNo, @IsSaving, @CreatedBy)
 
  SET @AccountID = SCOPE_IDENTITY()
 
  INSERT INTO AMS.[UserAccountMapping](UserID, AccountID, CreatedBy)
  VALUES (@UserID, @AccountID, @CreatedBy)
END
GO

EXEC AMS.Proc_UserAccountMapping_Insert 'userH', '1997-05-20', '2025-05-20', 1600, 12345, 987654, 1, 'admin';
EXEC AMS.Proc_UserAccountMapping_Insert 'userI', '1996-02-05', '2025-02-05', 1900, 56789, 654321, 0, 'admin';
GO

CREATE PROCEDURE AMS.AccountTransaction_Insert
  @Amount DECIMAL,
  @AccountNo INT,
  @IsSaving BIT,
  @IsDebit BIT,
  @CreatedBy VARCHAR(200) = 'defaultuser'
AS
BEGIN
  DECLARE @AccountID BIGINT
 
  INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
  VALUES (@AccountNo, @IsSaving, @CreatedBy)
 
  SET @AccountID = SCOPE_IDENTITY()
 
  INSERT INTO AMS.[AccountTransaction](AccountID, Amount, IsDebit, CreatedBy)
  VALUES (@AccountID, @Amount, @IsDebit, @CreatedBy)
END
GO

EXEC AMS.AccountTransaction_Insert 1500, 901, 1, 1, 'admin';
EXEC AMS.AccountTransaction_Insert 2000, 202, 0, 0, 'admin';
GO

SELECT name FROM sys.tables
SELECT * FROM AMS.AccountTransaction
SELECT * FROM AMS.[Account]
SELECT * FROM AMS.UserAccountMapping
SELECT * FROM AMS.[User]
SELECT * FROM AMS.[Address]
