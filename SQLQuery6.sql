/**   
Assignent for day 7 (8)


**/

--1.select Account data on the basis of yob with following column min balance.

 select U.UserID, A.AccountID,A.AccountNo, min(A.Balance) over (partition by year(U.DOB)) as MinBal   from [AMS].[User] U join [AMS].[Account] A on U.AccountNo = A.AccountNo;
 
 ---2.find the min(balance) having more than 3 accounts.
 select  min(A.Balance) as MinBal from [AMS].[User] U join [AMS].[Account] A on U.AccountNo=A.AccountNo 
   group by U.UserID having count(U.AccountNo) > 3;

   select * from [AMS].[Account]