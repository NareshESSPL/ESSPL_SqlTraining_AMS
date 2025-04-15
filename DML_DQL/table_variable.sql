declare @tbl_account as table
(
  UserID BIGINT primary key, -- Defining constraint is optional
  UserName Varchar(250),
  Balance decimal(10,6),
  AccountID int
)

insert into @tbl_account

select U.UserID,U.UserName,U.Balance,A.AccountID from
	 
AMS.[User] U left Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

left join AMS.[Account] A on M.AccountId = A.AccountID

where U.UserID > 70

select * from @tbl_account