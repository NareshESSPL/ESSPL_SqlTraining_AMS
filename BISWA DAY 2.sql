use AccountManagementSystem
go

create procedure AMS.Proc_User_Insert
as begin
	insert into AMS.[User](UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy, CreatedDate)
VALUES
    ('pane', '1990-02-01', '2025-05-08', 1000.50, 1234567890, 'Admin', CURRENT_TIMESTAMP);
end

exec AMS.Proc_User_Insert

alter Procedure AMS.Proc_User_Insert
@UserName NVARCHAR(250),
@DOB DATETIME,
@DOJ DATETIME,
@Balance DECIMAL(10,6),
@MobileNumber BIGINT,
@CreatedBy VARCHAR(250)
as begin
insert into AMS.[User](UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy)
VALUES
    (@UserName, @DOB ,@DOJ ,@Balance , @MobileNumber, @CreatedBy);
end

exec AMS.Proc_User_Insert 'NINJA', '1990-01-01', '2025-04-08', 1000.50, 1234567890, 'Admin'








create procedure AMS.Proc_UserAndAddress_Insert
@UserName NVARCHAR(250),
@DOB DATETIME,
@DOJ DATETIME,
@Balance DECIMAL(10,6),
@MobileNumber BIGINT,
@CreatedBy VARCHAR(250)
as begin

declare @UserId BIGINT

	insert into AMS.[User](UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy)
VALUES
    (@UserName, @DOB ,@DOJ ,@Balance , @MobileNumber, @CreatedBy);

	set @UserId =scope_identity()


insert into AMS.[User](UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy)
VALUES
    (@UserName, @DOB ,@DOJ ,@Balance , @MobileNumber, @CreatedBy);
end

exec AMS.Proc_UserAndAddress_Insert 'SUPMAN', '1990-01-01', '2025-04-08', 1000.50, 1234567890, 'Admin'

select * from AMS.[User]
