CREATE DATABASE Assign3;
use Assign3;
CREATE SCHEMA SC;


---------------------------USER TABLE------------------------------------
CREATE TABLE SC.[User](
UserID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
DOB DATETIME NOT NULL,
DOJ DATETIME NOT NULL,
Balance DECIMAL(10,6) NOT NULL,
MobileNo INT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);


------------------------------------ ACCOUNT TABLE---------------------------
CREATE TABLE SC.[Account](
AccountID BIGINT IDENTITY(1,1) NOT NULL Primary key,
AccountNo INT NOT NULL,
IsSaving BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

ALTER TABLE SC.[Account] 
add AccountType VARCHAR(250)  NULL;
---------------------------UserACOUNTMAPPING TABLE------------------
CREATE TABLE SC.[UserAccountMapping](
UserAccountMapping BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,
AccountId BIGINT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (UserID) REFERENCES SC.[User](UserID)
);
---------------ADDRESS TABLE----------------------------
CREATE TABLE SC.[Address](
AddressID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserId BIGINT NOT NULL,
Address NVARCHAR(MAX) NOT NULL,
CreatedBY VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (UserId) REFERENCES SC.[User](UserID)
);
------------------------ACCOUNTTRANSACTION TABLE--------------------
CREATE TABLE SC.[AccountTransaction](
AccountTransaction BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Amount Decimal(10,6) NOT NULL,
IsDebit Bit NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

------------------------------DBCC -----------------------
DBCC CHECKIDENT('SC.[User]',reseed,1)
DBCC CHECKIDENT('SC.[Account]',reseed,1)
DBCC CHECKIDENT('SC.[UserAccountMapping]',reseed,1)
DBCC CHECKIDENT('SC.[Address]',reseed,1)
DBCC CHECKIDENT('SC.[AccountTransaction]',reseed,1)

---------------------SP FOR INSERT----------------------------------
create PROCEDURE Proc_insert_All(
@UserName nvarchar(250),
@DOB	datetime,
@DOJ	datetime,
@Balance	decimal(10, 6),
@AccountNo	int,
@IsSaving bit,
@MobileNo	int,
@Address nvarchar(max),
@Amount Decimal(10,6),
@IsDebit bit,
@CreatedBy	varchar(250))
AS BEGIN

declare @UserID bigint


declare @AccountId bigint


INSERT INTO SC.[User](UserName,DOB,DOJ,Balance,MobileNo,CreatedBy)
Values(@UserName,@DOB,@DOJ,@Balance,@MobileNo,@CreatedBy)
set @UserID=SCOPE_IDENTITY();
set @AccountId=SCOPE_IDENTITY();
insert into SC.[Account] (AccountNo,IsSaving,CreatedBy)
Values(@AccountNo,@IsSaving,@CreatedBy)

insert into SC.[UserAccountMapping] (UserID,AccountID,CreatedBy)
Values (@UserID,@AccountID,@CreatedBy)

insert into SC.[Address](UserId,Address,CreatedBy) 
values (@UserId, @Address, @CreatedBy)

insert into SC.[AccountTransaction] (Amount,IsDebit,CreatedBy)
Values (@Amount,@IsDebit,@CreatedBy)

end

EXEC Proc_insert_All 'A','2001-01-01','2001-04-04',2000,1111,1,1234,'ctc',2000,0,'gdewydg'
EXEC Proc_insert_All 'P','2006-04-11','2005-09-12',3000,2222,0,3456,'BBSR',1000,1,'dbfydg'
EXEC Proc_insert_All 'W','1991-11-21','2000-04-09',4500,5551,1,6734,'pune',4500,0,'dvdghd'
EXEC Proc_insert_All 'W','1991-11-21','2000-04-09',9000,3343,1,6734,'pune',9000,0,'dvdghd'
EXEC Proc_insert_All 'N','2025-12-22','2020-10-09',2300,2341,0,2345,'Delhi',3200,0,'bcscb'
EXEC Proc_insert_All 'A','2001-01-01','2001-04-04',2000,4441,1,1234,'ctc',2500,0,'gdewydg'
EXEC Proc_insert_All 'S','2011-01-01','2021-04-04',3000,4441,0,1234,'BBSR',2500,0,'gdewydg'
EXEC Proc_insert_All 'R','2011-11-01','1991-04-14',2600,2341,1,3234,'ctc',2500,0,'gdVGWdg'
-------------------------------------------
---------------------Procedure for insert account type---------------------------
Create PROCEDURE Insert_Acc_Type(@AccountType Varchar(250),@AccountNo int)
as 
begin 
UPDATE SC.[Account]
SET AccountType=@AccountType
Where AccountNo=@AccountNo
end
EXEC Insert_Acc_Type 'Uco',1111;
EXEC Insert_Acc_Type 'SBI',2222;
EXEC Insert_Acc_Type 'Uco',5551;
EXEC Insert_Acc_Type 'NAC',4441;
EXEC Insert_Acc_Type 'SBI',2341;
EXEC Insert_Acc_Type 'Gramya',2341;



----------------------SP FOR SELECT---------------------------
CREATE PROCEDURE Proc_Select
as begin
select * from SC.[User];
select * from SC.[Account];
select * from SC.[UserAccountMapping];
select * from SC.[Address];
select * from SC.[AccountTransaction];
end
EXEC Proc_Select

--------Find account for each user with more than avg balance
Create Procedure Account_res
as
begin
	SELECT u.UserID,u.UserName,u.Balance,a.AccountID,a.AccountType
	FROM SC.[User] u
	Join
	SC.[UserAccountMapping] map ON u.UserID=map.UserID
	join 
	SC.[Account] a on map.AccountId=a.AccountID
	join 
	(Select AVG(u.Balance) as AVG_BAL  from SC.[User] u)
	as ab on u.Balance>ab.AVG_BAL;
	end


exec Account_res;
---------------------find the users who does not have accounts----------------
select u.* from SC.[User] u
JOIN SC.[UserAccountMapping] map ON map.UserID=u.UserID
WHERE map.AccountID IS NULL
-------------------------FIND USERS ,ACCOUNT DETAIL FOR USERS WHO HAS AVERAGE BALANCE OF HAVE MORE THAN 100000
select a.AccountNo
from SC.[User] as u
join 
SC.[UserAccountMapping] as map ON u.UserID=map.UserID
join 
SC.[Account] a on map.AccountID=a.AccountId
group by u.UserID
Having AVG(u.Balance)>10000;