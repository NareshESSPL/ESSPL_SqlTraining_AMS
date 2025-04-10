CREATE TABLE AMS.CreditCard
(
  CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
  UserID BIGINT,
  MobileNo VARCHAR(10),
  CardNo VARCHAR(16)
)

insert into AMS.CreditCard values(71, 1111111, 111);
insert into AMS.CreditCard values(1111, 1111111, null);
insert into AMS.CreditCard values(null, 8888, null);

select * from AMS.[User]
select * from AMS.[CreditCard]

select u.UserID U_uid, c.CreditCard, c.UserID c_uid, c.MobileNo
from AMS.[User] as u left join AMS.CreditCard c on
u.UserID = c.UserID


select u.UserID U_uid, c.CreditCard, c.UserID c_uid, c.MobileNo
from AMS.[User] as u left join AMS.CreditCard c on
u.UserID = c.UserID



Create table CreditCardOffer
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
)

insert into CreditCardOffer values (1, 'Offer1')
insert into CreditCardOffer values (2, 'Offer2')
insert into CreditCardOffer values (Null, 'Offer2')


Create table Employee
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  ManagerID BIGINT,
  Name VARCHAR(250)
)

insert into Employee values (1, Null, 'Ankita')
insert into Employee values (2, 1, 'Rakesh')
insert into Employee values (3, 2,'Naresh')
insert into Employee values (4, 2,'Suresh')

select * from Employee

select emp.EmployeeID, emp.ManagerID, emp.Name EmpName, man.Name Manager
from Employee emp left join Employee man 
on emp.ManagerID = man.EmployeeID

select distinct man.Name Manager
from Employee emp left join Employee man 
on emp.ManagerID = man.EmployeeID


