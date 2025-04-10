use AccountManagementSystem2

create procedure AMS.Proc_User_Insert
as begin 
 insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
 ('test','2023-12-02','2022-09-09',234,33,4555555,'om'),
 ('test2','2023-02-02','2021-09-09',934,33,4955555,'oom')
end
exec AMS.Proc_User_Insert
 select * from AMS.[User]


alter procedure AMS.Proc_User_Insert
 @UserName nvarchar(10)='bhb',@DOB datetime,@DOJ datetime,@Balance decimal,@AccountNo int,@MobileNo int,@CreatedBy varchar(10)='defaultuser'
 as begin
  insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
  (@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
end 

exec AMS.Proc_User_Insert 'test4','2023-12-02','2022-09-09',234,33,4555555


create procedure AMS.Proc_UserAndAddress_Insert
 @UserName nvarchar(10),@DOB datetime,@DOJ datetime,@Balance decimal,
 @AccountNo int,@MobileNo int,@AddressDetail nvarchar(max),@CreatedBy varchar(10)='defaultuser'
 as begin
 declare @UserId BigInt
  insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
  (@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
  set @UserId=SCOPE_IDENTITY()
  insert into AMS.[Address](UserId,AddressDetail,CreatedBy) values(@UserId,@AddressDetail,@CreatedBy)
end 
exec AMS.Proc_UserAndAddress_Insert 'testing','2025-06-13','2025-06-13',500,123,5677,'agra'
select * from AMS.[Address]
select * from AMS.[User]

create procedure AMS.Proc_Account_Insert(
 @AccountNo INT ,@IsSaving BIT,@CreatedBy VARCHAR(250),@CreatedDate DATETIME )
 as begin
  insert into AMS.[Account](AccountNo,IsSaving,CreatedBy,CreatedDate) values
  (@AccountNo,@IsSaving,@CreatedBy,@CreatedDate)
 end 
 exec AMS.Proc_Account_Insert 12,1,'ashir2','2025-03-24'
 select * from AMS.[Account]
 


 create procedure AMS.Proc_AccountTransaction_Insert(
 @AccountTransactionID BIGINT,
	@AccountID INT,
    @Amount DECIMAL(10,6),
    @IsDebit BIT,
    @CreatedBy VARCHAR(250),
    @Created DATETIME)
 as begin
  insert into AMS.[AccountTransaction](AccountTransactionID,AccountID,Amount,IsDebit,CreatedBy,Created) values
  (@AccountTransactionID,@AccountID,@Amount,@IsDebit,@CreatedBy,@Created)
 end 
 set identity_insert AMS.[Address] OFF;
 set identity_insert AMS.[AccountTransaction] ON;
 Exec AMS.Proc_AccountTransaction_Insert 4,7,234,1,'hario','2021-09-23'

 select * from AMS.[AccountTransaction]

 create procedure AMS.Proc_UserAccountMapping_Insert(
 @UserAccountMappingID BIGINT,
    @UserID BIGINT,
    @AccountID BIGINT,
    @CreatedBy VARCHAR(250),
    @Created DATETIME)
 as begin
  insert into AMS.[UserAccountMapping]( UserAccountMappingID,UserID,AccountID,CreatedBy,Created) values
  (@UserAccountMappingID,@UserID,@AccountID,@CreatedBy,@Created)
 end 
 set identity_insert AMS.[UserAccountMapping] ON;
 Exec AMS.Proc_UserAccountMapping_Insert 4,7,3,'oom','2024-12-23' 
 select * from AMS.[UserAccountMapping]

 create procedure AMS.Proc_Address_Insert(
 @AddressID BIGINT,
    @UserID BIGINT,
    @AddressDetail NVARCHAR(MAX),
    @CreatedBy VARCHAR(250),
    @Created DATETIME)
 as begin
  insert into AMS.[Address]( AddressID,
    UserID,
    AddressDetail,
    CreatedBy,
    Created) values
  (@AddressID,
    @UserID,
    @AddressDetail,
    @CreatedBy,
    @Created)
 end 
 set identity_insert AMS.[Address] ON;
 Exec AMS.Proc_Address_Insert 5,6,'bombay','seema','2024-09-23'
 select * from AMS.[Address]