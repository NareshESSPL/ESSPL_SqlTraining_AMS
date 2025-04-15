USE AccountManagementSystem
GO
--------------------------------------MERGE----------------------------------------------------
create table testMergeSource
 (
   id int identity(1,1) primary key,
   name varchar(200)
 )
 create table testMergeTarget
 (
   id int  primary key,
   name varchar(200),
   CreatedDate DateTime,
 )
 insert into testMergeSource values ('naresh')
 insert into testMergeSource values ('suresh')
 insert into testMergeSource values ('mahesh')

 SET IDENTITY_INSERT testMergeTarget ON
 INSERT INTO testMergeTarget(id, name)  values (9,'testInsertT')
 SET IDENTITY_INSERT testMergeTarget OFF

 MERGE testMergeTarget t
  USING testMergeSource s ON s.id= t.id
 
 WHEN MATCHED
     THEN UPDATE SET 
         t.name = s.name
 
 WHEN NOT MATCHED BY TARGET
     THEN INSERT (name) values (s.name)
 
 WHEN NOT MATCHED BY SOURCE 
     THEN DELETE;

SELECT * FROM testMergeTarget
SELECT * FROM testMergeSource
-------------------------------------TRYING MERGE IN AMS---------------------------------
;WITH cte_AccountAnalysis
AS
(
	select u.UserID,u.UserName,u.DateOfBirth,u.DateOfJoining, u.Balance, ac.AccountID,ac.AccountNumber, u.MobileNumber,a.AddressID,a.FullAddress,
 	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.CreatedDate 
    from AMS.[User] u
 	 inner join AMS.[Address] a on a.UserID = u.UserID
 	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
 	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
 	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
)

MERGE INTO AMS.MergedUserInfo AS t
USING cte_AccountAnalysis AS s
    ON t.UserID = s.UserID
WHEN MATCHED THEN 
    UPDATE SET
        t.UserName = s.UserName,
        t.DateOfBirth = s.DateOfBirth,
        t.DateOfJoining = s.DateOfJoining,
        t.Balance = s.Balance,
        t.MobileNumber = s.MobileNumber,
        t.FullAddress = s.FullAddress,
        t.AccountID = s.AccountID,
        t.AccountNumber = s.AccountNumber,
        t.IsSaving = s.IsSaving,
        t.Amount = s.Amount,
        t.IsDebit = s.IsDebit,
        t.CreatedBy = s.CreatedBy,
        t.CreatedDate = s.CreatedDate
WHEN NOT MATCHED BY TARGET THEN 
    INSERT (
        UserID,
        UserName,
        DateOfBirth,
        DateOfJoining,
        Balance,
        MobileNumber,
        FullAddress,
        AccountID,
        AccountNumber,
        IsSaving,
        Amount,
        IsDebit,
        CreatedBy,
        CreatedDate
    )
    VALUES (
        s.UserID,
        s.UserName,
        s.DateOfBirth,
        s.DateOfJoining,
        s.Balance,
        s.MobileNumber,
        s.FullAddress,
        s.AccountID,
        s.AccountNumber,
        s.IsSaving,
        s.Amount,
        s.IsDebit,
        s.CreatedBy,
        s.CreatedDate
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
 -------------------------------------SET OPERATIONS---------------------------------------------------
 CREATE TABLE Customer
 (
	CustomerID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CustomerName VARCHAR(100) NOT NULL,
	Pincode INT,
	City VARCHAR(200) NULL
 )
 CREATE TABLE Supplier
 (
	SupplierID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	SupplierName VARCHAR(100) NOT NULL,
	Pincode INT,
	City VARCHAR(200) NULL
 )

 INSERT INTO Customer VALUES ('NAM',111,'BBSR')
 INSERT INTO Customer VALUES ('YAM',111,'BBSR')
 INSERT INTO Customer VALUES ('TAM',113,'RKR')
 INSERT INTO Customer VALUES ('CAM',112,'CTC')
 INSERT INTO Customer VALUES ('SAM',114,'BAM')

 INSERT INTO Supplier VALUES ('PANDA AND CO', 111, 'BBSR')
 INSERT INTO Supplier VALUES ('RAO AND CO', 111, 'BBSR')
 INSERT INTO Supplier VALUES ('PUSPA AND CO', 114, 'BAM')
 INSERT INTO Supplier VALUES ('KAR AND CO', 112, 'CTC')

 --get list of city we have both customer and suppier
 SELECT PINCODE, City FROM Customer
 UNION
 SELECT PINCODE, City FROM Supplier
 ORDER BY City;
 
 SELECT PINCODE, City FROM Customer
 UNION ALL
 SELECT PINCODE, City FROM Supplier
 ORDER BY City;
 
 --Only present in fist table
 SELECT PINCODE, City FROM Customer
 EXCEPT
 SELECT PINCODE, City FROM Supplier
 ORDER BY City;
 
 
 --Must present in both table
 SELECT PINCODE, City  FROM Customer
 INTERSECT
 SELECT PINCODE, City FROM Supplier
 ORDER BY City;
 ------------------------------------------------SET OPERATIONS IN AMS-----------------------------------------------------
 --get list of city we have both customer and suppier
 SELECT UserName,UserID FROM AMS.[User]
 UNION
 SELECT UserName,UserID FROM AMS.MergedUserInfo
 ORDER BY UserID;
 
 SELECT UserName,UserID FROM AMS.[User]
 UNION ALL
 SELECT UserName,UserID FROM AMS.MergedUserInfo
 ORDER BY UserID;
 
 --Only present in fist table
 SELECT UserName,UserID FROM AMS.[User]
 EXCEPT
 SELECT UserName,UserID FROM AMS.MergedUserInfo
 ORDER BY UserID;
 
 
 --Must present in both table
 SELECT UserName,UserID  FROM AMS.[User]
 INTERSECT
 SELECT UserName,UserID FROM AMS.MergedUserInfo
 ORDER BY UserID;
 ------------------------------------------TRIGGER------------------------------------------------------
 ----AFTER TRIGGER------------
 CREATE TABLE [AppUser_History](
 	[UserID] [int] NULL,
 	[UserName] [varchar](250) NULL,
 	[OldUserName] [varchar](250) NULL,
 	[Operation] [varchar](3) NOT NULL,
 	[ModifiedDate] DateTime NOT NULL,
 	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
 )
 GO
 CREATE TABLE AppUser(
	[UserID] [int] NULL,
 	[UserName] [varchar](250) NULL
 )
 GO

 CREATE TRIGGER trg_testInput
 ON AppUser
 AFTER INSERT 
 AS 
 BEGIN
	INSERT INTO AppUser_History(UserID, UserName, ModifiedDate, Operation)
	SELECT  i.UserID, i.UserName, GETDATE(), 'INS' FROM inserted i
END

CREATE TRIGGER trg_AppUser_Delete
ON AppUser
AFTER DELETE
AS
BEGIN
    INSERT INTO AppUser_History(UserID, UserName, OldUserName, Operation, ModifiedDate)
    SELECT 
        d.UserID,
        NULL,
        d.UserName,
        'DEL',
        GETDATE()
    FROM deleted d;
END;

CREATE TRIGGER trg_AppUser_Update
ON AppUser
AFTER UPDATE
AS
BEGIN
    INSERT INTO AppUser_History(UserID, UserName, OldUserName, Operation, ModifiedDate)
    SELECT 
        i.UserID,
        i.UserName,
        d.UserName,
        'UPD',
        GETDATE()
    FROM inserted i
    JOIN deleted d ON i.UserID = d.UserID;
END;

CREATE or alter TRIGGER trg_AppUser_AllActions
ON AppUser
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    INSERT INTO AppUser_History(UserID, UserName, OldUserName, Operation, ModifiedDate)
    
    -- INSERT
    SELECT 
        i.UserID, 
        i.UserName, 
        NULL, 
        'INS', 
        GETDATE()
    FROM inserted i
	WHERE NOT EXISTS (
        SELECT 1 FROM deleted d WHERE d.UserID = i.UserID
    )

    UNION ALL

    -- DELETE
    SELECT 
        d.UserID, 
        NULL, 
        d.UserName, 
        'DEL', 
        GETDATE()
    FROM deleted d
	WHERE NOT EXISTS (
        SELECT 1 FROM inserted i WHERE i.UserID = d.UserID
    )

    UNION ALL 

    -- UPDATE
    SELECT 
        i.UserID, 
        i.UserName, 
        d.UserName, 
        'UPD', 
        GETDATE()
    FROM inserted i
    JOIN deleted d ON i.UserID = d.UserID
	WHERE ISNULL(i.UserName, '') <> ISNULL(d.UserName, '')
END;

INSERT INTO AppUser (UserID, UserName)
VALUES (1, 'John'), (2, 'Jane');

DELETE FROM AppUser
WHERE UserID = 2;

UPDATE AppUser
SET UserName = 'Johnny'
WHERE UserID = 1;

SELECT * FROM AppUser
SELECT * FROM AppUser_History

delete from AppUser
delete from AppUser_History
----INSTEAD OF TRIGGER---------------------
create table ItemType
 (
   ItemTypeId int not null primary key,
   itemTypeName varchar(100) not null
 )
 create table Item
 (
   ItemId int not null primary key,
   ItemTypeId int not null foreign key references ItemType(ItemTypeId),
   ItemName varchar(100) not null
 )
 insert into Item values (1,1, 'test1')
 
 CREATE OR ALTER TRIGGER trg_InsteadOfInsert_Item
 ON Item
 INSTEAD OF INSERT
 AS
 BEGIN
     IF NOT EXISTS(SELECT TOP 1 ItemTypeId  FROM ItemType)
 	BEGIN
 
 	  INSERT INTO ItemType (ItemTypeId, itemTypeName) 
 	  SELECT i.ItemTypeId, 'UNKNOWN' FROM INSERTED i 
 	END
 	  INSERT INTO Item (ItemID, ItemTypeId, ItemName) 
 	  SELECT i.ItemID, i.ItemTypeId, i.ItemName FROM INSERTED i 	  	   
 END
 
 select * from Item
 select * from ItemType
------------------------------------------------CONSTRAINT---------------------------------------------------------------
--NOT NULL - Ensures that a column cannot have a NULL value
--UNIQUE - Ensures that all values in a column are different
--PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
--FOREIGN KEY - Prevents actions that would destroy links between tables
--CHECK - Ensures that the values in a column satisfies a specific condition
--DEFAULT - Sets a default value for a column if no value is specified
--CREATE INDEX - Used to create and retrieve data from the database very quickly
------------------------------------------------NONCLUSTERED  INDEX------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_MergedUserInfo_UserName_DateOfBirth
ON AMS.MergedUserInfo( UserName, DateOfBirth )

SELECT * FROM AMS.MergedUserInfo WHERE DateOfBirth > GETDATE()