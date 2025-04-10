USE AccountManagementSystem;

exec sp_help 'AMS.[User]';
exec sp_help 'AMS.Account';
exec sp_help 'AMS.USerAccountMapping';

/*Joining 3 tables (User,Account,UserAccountMapping)*/

select U.UserID,U.UserName,U.Balance from 
(
	(AMS.Account A inner join AMS.UserAccountMapping M 
	on A.AccountID = M.AccountID )inner join AMS.[User] U
	on M.UserID = U.UserID
);

/* find the account for each user having more than avg balance */

select U.UserID,U.UserName,U.Balance,A.AccountID
	from 
	AMS.[User] U Join AMS.[UserAccountMapping] M 
	on U.UserID=M.UserID join 
	AMS.[Account] A on M.AccountId = A.AccountID
	join 
	(Select AVG(u.Balance) as AVG_BAL  from AMS.[User] U)
	as X on U.Balance>X.AVG_BAL;

/* user having multiple account */

select U.UserID,U.UserName,count (M.AccountID) as ACC_NO
from AMS.[User] U JOIN AMS.UserAccountMapping M on U.UserID = M.UserID
group by 
    U.UserID, U.UserName
having 
    count(M.AccountID) > 1;

/* user having no address*/

select 
    u.UserID,
    u.UserName,
    u.MobileNo,
    u.Balance
from 
    AMS.[User] u
	left join 
    AMS.[Address] A ON U.UserID = A.UserID
	and 
    A.AddressID is null

