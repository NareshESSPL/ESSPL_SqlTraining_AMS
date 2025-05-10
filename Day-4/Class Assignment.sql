/*
# Create SP for each query.
# Create a type of table with following columns:
 - accountId
 - accountNo
ListOfAccount

*/

create type ams.[udt_Account] as table
(
  accId bigint,
  accNo bigint
);

-- drop type ams.[BasicUser]
go

create proc ams.[Account_udt]
@accountList ams.[udt_Account] readonly
as
begin
  select * from @accountList;
end
--exec ams.[Account_udt];

declare @InputAccount ams.[udt_Account];
insert into @InputAccount values(1, 1000), (2, 1001), (3, 1003);
exec ams.[Account_udt] @accountList = @InputAccount;

