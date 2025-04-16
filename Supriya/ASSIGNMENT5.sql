
--merge the table joining cte with the AccountAnalysis table
;with cte_AcountAnalysis as(
     select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,ac.Balance,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
)

MERGE AMS.AccountAnalysis t
 USING cte_AcountAnalysis s ON s.UserId = t.UserId

WHEN MATCHED
    THEN UPDATE SET 
        t.UserName = s.UserName,
		t.DOB = s.DOB,  
		t.DOJ = s.DOJ,
		t.AccountNo = s.AccountNO,
		t.MobileNO = s.MobileNO

WHEN NOT MATCHED BY TARGET
    THEN INSERT (UserName,DOB,DOJ,AccountNo,MobileNO) values (s.UserName,s.DOB,s.DOJ,s.AccountNo,s.MobileNO)

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;


select * from AMS.AccountAnalysis





--performing the set operations in user table and Account analysis table
select UserName,DOB,DOJ,AccountNo,MobileNo,CreatedBy,Created from AMS.[User]
except
select UserName,DOB,DOJ,AccountNo,MobileNo,CreatedBy,Created from AMS.AccountAnalysis
order by UserName




--perform CUD perations in a single trigger
alter trigger AMS.trg_CRUD_OnAppUser
on AMS.AppUser
after insert,delete,update 
as begin
   --insert
   if exists (select * from inserted) and not exists (select * from deleted) 
   begin 
     insert into AMS.AppUser_Hstory(UserId,UserName,OldUserName,ModifiedDate,Operation)
     select i.UserId,i.UserName,null,getDate(),'INS' from inserted i
   end

   --delete
   if exists (select * from deleted) and not exists (select * from inserted) 
   begin
      insert into AMS.AppUser_Hstory(UserId,UserName,OldUserName,ModifiedDate,Operation)
      select d.UserId,d.UserName,null,getdate(),'DEL' from deleted d
   end

   --update
   if exists (select * from inserted) and exists (select * from deleted) 
   begin
      insert into AMS.AppUser_Hstory(UserId,UserName,OldUserName,ModifiedDate,Operation)
      select i.UserId,i.UserName,d.UserName, GETDATE(),'UPD' from(
        deleted d join inserted i on i.UserId = d.UserId
      )
   end
end

insert into AMS.AppUser values ('utam')

delete from AMS.AppUser where userId = 7

update AMS.AppUser set UserName = 'subha' where UserId = 7

select * from AMS.AppUser
select * from AMS.AppUser_Hstory