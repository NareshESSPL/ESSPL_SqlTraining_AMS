USE AccountManagementSystem
GO
--SEPERATE FIRST NAME AND LAST  NAME
DECLARE @Name VARCHAR(100), @FName VARCHAR(100), @LName VARCHAR(100), @Length INT

SET @Name = 'AYUSHMAN PATRO'

SET @Length = LEN(@Name)
PRINT CHARINDEX(' ',@Name, 1)
SET @FName = SUBSTRING(@Name, 1, CHARINDEX(' ',@Name) - 1)
SET @LName = SUBSTRING(@Name, CHARINDEX(' ',@Name) + 1, @Length)

SELECT @FName,@LName, @Length

PRINT @FName
PRINT @LName
PRINT @Length

--TRIMING
DECLARE @Nam VARCHAR(100)
SET @Nam =  '  AYUSHMAN PATRO  '
SELECT LEN(@Nam) WITHOUTTRIM, LEN(LTRIM(@Nam)), LEN(RTRIM(@Nam))

--CONCATING
DECLARE @FNam VARCHAR(100), @LNam VARCHAR(100)
SET @FNam = 'AYUSHMAN'
SET @LNam = 'PATRO'
SELECT CONCAT(@FNam,' ',@LNam)

----------------------------------------------------------VIEWS---------------------------------------------------------------------

CREATE VIEW AMS.vw_account as 
SELECT U.UserID, U.UserName, U.Balance, A.AccountID FROM
AMS.[User] U LEFT JOIN AMS.[UserAccountMapping] M ON U.UserID = M.UserID
LEFT JOIN AMS.[Account] A ON M.AccountID = A.AccountID
WHERE U.UserID > 1

SELECT * FROM AMS.vw_account

-----------------------------------------------------CTE-------------------------------------------------------------------------------
;WITH CTE_ACCOUNT
AS
(
	SELECT U.UserID, U.UserName, U.Balance, A.AccountID FROM
	AMS.[User] U JOIN AMS.[UserAccountMapping] M ON U.UserID = M.UserID
	JOIN AMS.[Account] A ON M.AccountID = A.AccountID 
)
-------------CTE CAN BE USED ONLY IN ONE SELECT STATEMENT JUST  AFTER DECLARING IT----------------------------------
SELECT A.UserID, A.UserName, A.Balance, A.AccountID FROM CTE_ACCOUNT A 
JOIN (
		SELECT AVG(Balance) AVERAGE_BALANCE, UserID FROM CTE_ACCOUNT GROUP BY UserID
	 )AS AVG_BAL
ON A.UserID = AVG_BAL.UserID AND A.Balance >= AVG_BAL.AVERAGE_BALANCE
------------------NOW YOU CANNOT USE CTE AGAIN------------------------------
SELECT * FROM CTE_ACCOUNT;

-----------------------CREATING, USING TYPE------------------------------------------
CREATE TYPE AMS.PhoneNumber FROM VARCHAR(10)

CREATE TABLE  STG_User
(
	userid INT IDENTITY(1,1) PRIMARY KEY,
	username nvarchar(100),
	phoneno AMS.PhoneNumber
)

INSERT INTO STG_User VALUES('AYUSHMAN', 1234567890)
----------------------CREATING A TABLE IN TYPE
CREATE TYPE AMS.BasicUser AS TABLE
(
	userid INT IDENTITY(1,1) PRIMARY KEY,
	username NVARCHAR(100),
	phoneNo AMS.PhoneNumber
)
GO

CREATE PROC AMS.test_udt
AS 
BEGIN
	DECLARE @buser AS AMS.BasicUser
	INSERT INTO @buser VALUES('SAHIL',1234567890)
	SELECT * FROM  @buser
END

EXEC AMS.test_udt

----------------------WE CAN ALSO DROP A  TYPE-----------------------------
/*
	DROP TYPE AMS.PhoneNumber
*/
------------------------------IN CLASS ASSIGNMENT(CREATE A TABLE TYPE AND INPUT A TABLELIST USING STORED PROCEDURE)----------------------------------
CREATE TYPE AMS.AccountInfo AS TABLE
(
	accountid BIGINT,
	acccountnumber BIGINT
)
GO

CREATE PROC AMS.account_udt
@accountList AMS.AccountInfo READONLY
AS 
BEGIN
	SELECT * FROM @accountList
END

DECLARE @InputAccount AMS.AccountInfo
INSERT INTO @InputAccount VALUES(1111,2222),(8888,9999);

EXEC AMS.account_udt @accountList = @InputAccount
------------------------------IF ELSE CONDITIONAL STATEMENT----------
DECLARE @Input VARCHAR(10) = 'SAD' 
IF @Input LIKE '%a%'
	PRINT 'hello'
ELSE 
	PRINT 'NO HELLO'

IF EXISTS(SELECT TOP 1 * FROM AMS.[User] WHERE UserName LIKE 'CAM')
PRINT 'HELLO'
-------------------------------
