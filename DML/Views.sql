Create View AMS.vw_account as
select U.UserID,U.UserName,U.Balance,A.AccountID from
	 
AMS.[User] U left Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

left join AMS.[Account] A on M.AccountId = A.AccountID

where U.UserID > 70

select * from AMS.vw_account va join AMS.address a on a.UserID = va.UserID