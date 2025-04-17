
Use BankingManagementSystem;
Go


Create Function GetFinalBill
(
@Invoice Float
)
Returns Float
As Begin
Return @Invoice * 0.18 + @Invoice * 0.02
End;

Select * From GetFinalBill

--------------------------------------------------

Alter Function BMS.GetFinalBill
(
@Invoice Float
)
Returns Float
As Begin
Return @Invoice * 0.18 + @Invoice * 0.02 + 10
End

Print BMS.GetFinalBill(100)

--------------------------------------------------
Create Type BMS.Type_Account As Table
(
AccountId Int(20)
)

/*
Create Function BMS.Func_Account(@Accountid Int)
Returns Type_Account
As Begin
--Declare @TestVar Type_Account
--Insert Into @TestVar Values(1)
--Select @TestVar
End
*/


SELECT
    a.AccountId, 
    a.AccountNo, 
    u.Username, 
    ad.Address
FROM 
    BMS.Account 
JOIN 
    BMS.[User]
    ON u.Username = a.Username
JOIN 
    BMS.Address ad 
    ON u.AddressId = ad.AddressId;

--------------------------------------------

Create table UserAccountAnalysis
(
    UserName nvarchar,
	DOB datetime,
	DOJ datetime,
	Balance decimal,
	AccountNo int,
	MobileNo int,
	CreatedBy varchar(100),
	Created  datetime

);
GO
Create Proc BMS.TestSP
As
Begin
  Truncate Table BMS.AccountTransaction
  
  Truncate Table BMS.UserAccountMapping
  
  Delete from BMS.Account
  DBCC CHECKIDENT ('BMS.Account', RESEED, 0)
  
  truncate table BMS.[Address]
  
  delete from BMS.[User]
  DBCC CHECKIDENT ('BMS.[User]', RESEED, 0)


  declare 
    @UserName [nvarchar](250) = 'test',
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate();

  declare @count int = 0;
  
  WHILE @count < =1000
  BEGIN
  --Do not delete
  select @count = @count + 1

  insert into BMS.[User] ([UserName], [DOB], [DOJ], [Balance], [MobileNo],[CreatedBy],[Created])
  values(@UserName + cast(@count as varchar),
         dateadd(month,1, @DOB), 
		 dateadd(day, -1, @DOJ),
		 @Balance + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 )
  END

   select * from BMS.[User]
end








