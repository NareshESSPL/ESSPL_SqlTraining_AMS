/*
Created By : Suraj Kumar Sah
Date : 15-04-2025
DESC : TRIGGERS
*/

USE Testing;
GO

CREATE TABLE AppUser
(
 UserID INT PRIMARY KEY,
 Username NVARCHAR(MAX),
 CreatedDate DATETIME DEFAULT GETDATE()
);


CREATE TABLE [AppUser_History](
	[UserID] [int] NULL,
	[UserName] [varchar](250) NULL,
	[OldUserName] [varchar](250) NULL,
	[Operation] [varchar](3) NOT NULL,
	[ModifiedDate] DateTime NOT NULL,
	CHECK(operation = 'INS' or operation='DEL' or operation = 'UPD')
);
GO

-- INSERT Triger
create trigger trg_tappUserInsert
ON AppUser
AFTER INSERT
AS
BEGIN
  insert into [AppUser_History](UserID, UserName, ModifiedDate, Operation)
  SELECT i.UserID, i.UserName, getdate(), 'INS' from inserted i;
END

--Testing
INSERT INTO AppUser (UserID, Username) VALUES (1, 'Suraj');
INSERT INTO AppUser (UserID, Username) VALUES (2, 'Kappa');
INSERT INTO AppUser (UserID, Username) VALUES (3, 'Bhalu');

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;
-------------------------------------------------------------------------------------

--DELETE Trigger
create trigger trg_tappUserDelete
ON AppUser
AFTER DELETE
AS
BEGIN
  insert into [AppUser_History](UserID, UserName, ModifiedDate, Operation)
  SELECT d.UserID, d.UserName, getdate(), 'DEL' from deleted d;
END

--Testing
DELETE FROM AppUser where UserID=3;

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;
-------------------------------------------------------------------------------------

--UPDATE Trigger
create trigger trg_tappUserUpdate
ON AppUser
AFTER UPDATE
AS
BEGIN
  insert into [AppUser_History](UserID, UserName, OldUserName, ModifiedDate, Operation)
  SELECT i.UserID, i.UserName, d.UserName,  getdate(), 'UPD' from deleted d
  INNER JOIN Inserted i ON d.UserID = i.UserID
END

--Testing
UPDATE AppUser set Username = 'Chilika Kappa' where UserID = 2;

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;

----------------------------------------------------------

-- Combined trigger for INSERT, DELETE and UPDATE
CREATE TRIGGER trg_OnAppUser
ON AppUser
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
 insert into [AppUser_History](UserID, UserName, OldUserName, ModifiedDate, Operation)

 select i.UserID, i.UserName, NULL as OldName, getdate(), 'INS' from inserted i
  UNION ALL
 select d.UserID, d.UserName, NULL as OldName, getdate(), 'DEL' from Deleted d
 INTERSECT
 select i.UserID, i.UserName, d.Username as OldName, getdate(), 'UPD' from inserted i
 LEFT JOIN Deleted d on i.UserID =d.UserID;

 select i.UserID, i.UserName, 
 CASE 
   WHEN d.UserID IS NULL THEN 'INS'
   WHEN d.UserID IS NOT NULL AND i.UserID IS NULL THEN 'DEL'
   ELSE 'UPD'
 CASE

END

--Testing
INSERT INTO AppUser (UserID, UserName) Values (20, 'Nepal');
delete from AppUser where UserID = 20;
Update AppUser set Username = 'KIIT Kappa' where UserID = 10;
delete from AppUser where UserID = 5;

SELECT * FROM AppUser;
SELECT * FROM AppUser_History;