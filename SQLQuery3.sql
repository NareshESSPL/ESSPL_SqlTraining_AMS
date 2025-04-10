use db;
go
alter table sc.[User]
alter column CreatedBy varchar(250);
go
alter table sc.[User]
add AddressDetail nvarchar(max);
go
alter table sc.[User]
add UserId bigint identity(1,1)
go
alter proc proc_user_insert
@username nvarchar(250),
@DOB datetime,
@DOJ datetime,
@balance decimal,
@Accountno int,
@MobileNo int,
@AddressDetail nvarchar(max),
@CreatedBy varchar(250) = 'defaultuser'
as begin
declare @UserId bigint
insert into sc.[User] (Username, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
(@Username, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

set @UserId = scope_identity()

insert into sc.[Address](UserId, AddressDetail,CreatedBy)
values (@UserId, @AddressDetail, @CreatedBy)


end

exec proc_user_insert 'texting', '2025-02-02','2025-02-02',500,123,9876, 'ayush'
select * from sc.[User]

-------------------------------------------------------

CREATE PROCEDURE sc.Proc_UserAndAll_Insert
 @UserName NVARCHAR(250),
 @DOB DATETIME,
 @DOJ DATETIME,
 @Balance DECIMAL(10, 6),
 @AccountNo INT,
 @MobileNo INT,
 @AddressDetail NVARCHAR(MAX),
 @IsSaving BIT,
 @Amount DECIMAL(20, 2),
 @IsDebit BIT,
 @CreatedBy VARCHAR(250) = 'defaultuser'
AS
BEGIN
    DECLARE @UserID BIGINT
    DECLARE @AccountID BIGINT

    -- Insert into User table
    INSERT INTO sc.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) 
    VALUES (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

    -- Get last inserted UserID
    SET @UserID = SCOPE_IDENTITY()

    -- Insert into Address table
    INSERT INTO sc.[Address] (UserID, AddressDetail, CreatedBy) 
    VALUES (@UserID, @AddressDetail, @CreatedBy)

    -- Insert into Account table
    INSERT INTO sc.[Account] (AccountNo, IsSaving, CreatedBy)
    VALUES (@AccountNo, @IsSaving, @CreatedBy)

    -- Get last inserted AccountID
    SET @AccountID = SCOPE_IDENTITY()

    -- Insert into UserAccountMapping table
    INSERT INTO sc.UserAccountMapping (UserID, AccountID, CreatedBy)
    VALUES (@UserID, @AccountID, @CreatedBy)

    -- Insert into AccountTransaction table
    INSERT INTO sc.AccountTransaction (AccountID, Amount, IsDebit, CreatedBy)
    VALUES (@AccountID, @Amount, @IsDebit, @CreatedBy)
END

-- Execute the procedure
EXEC sc.Proc_UserAndAll_Insert 
    'Ayush', '2001-08-09', '2022-06-13', 3000.0, 12675678, 92754321, 'bgherb', 1, 8000.0, 0

-- Fetch data from tables
SELECT * FROM sc.[User];
SELECT * FROM sc.[Address];
SELECT * FROM sc.Account;
SELECT * FROM sc.UserAccountMapping;
SELECT * FROM sc.AccountTransaction;
