/*
 SET Operations (Union, union all, Intersect, except)
*/
USE Testing;

Create table Customer
(
  CustomerID BIGINT IDENTITY(1,1) NOT NULL Primary key,
  CustomerName VARCHAR(100) NOT NULL,
  PINCODE INT,
  City VARCHAR(200) NULL
)
GO

Create table Supplier
(
  SupplierID BIGINT IDENTITY(1,1) NOT NULL Primary key,
  SupplierName VARCHAR(100) NOT NULL,
  PINCODE INT,
  City VARCHAR(200) NULL
)
go

insert into Customer values('Naresh', 111, 'BBSR')
insert into Customer values('Suresh', 111, 'BBSR')
insert into Customer values('Paresh', 222, 'CTC')
insert into Customer values('Mahesh', 111, 'JPR')
insert into Customer values('Mahesh', 000, NULL)

insert into Supplier values('Panda and Co', 111, 'BBSR')
insert into Supplier values('Das and Co', 123, 'BBSR')
insert into Supplier values('Nayak and Co', 777, 'CTC')
insert into Supplier values('Aditya Groups', 111,'KJR')

--get list of city we have both customer and suppier
SELECT PINCODE, City FROM Customer
UNION
SELECT PINCODE, City FROM Supplier
ORDER BY City;

SELECT PINCODE, City FROM Customer
UNION ALL
SELECT PINCODE, City FROM Supplier
ORDER BY City;

--Only present in fist table
SELECT PINCODE, City FROM Customer
EXCEPT
SELECT PINCODE, City FROM Supplier
ORDER BY City;


--Must present in both table
SELECT PINCODE, City  FROM Customer
INTERSECT
SELECT PINCODE, City FROM Supplier
ORDER BY City;

/*
AccountTransaction
User for username

SET Operations

*/

select * from AMS.[User];
select * from AMS.[AccountAnalytics]

update AMS.[User] set UserName = 'suraj' where UserID = 44;
update AMS.[User] set UserName = 'kappa' where UserID = 46;
--UNION operator
select UserName from ams.[User]
UNION
select UserName from ams.[AccountAnalytics]
order by UserName;

--INTERSECT operator
select UserName from ams.[User]
INTERSECT
select UserName from ams.[AccountAnalytics]
order by UserName;

--EXCEPT operator
select UserName from ams.[User]
EXCEPT
select UserName from ams.[AccountAnalytics]
order by UserName;

select UserName from ams.[AccountAnalytics]
EXCEPT
select UserName from ams.[User]
order by UserName;

--UNION ALL operator
select UserName from ams.[User]
UNION ALL
select UserName from ams.[AccountAnalytics]
order by UserName;
