/*
Name : Suraj Kumar Sah
*/

/*
- Types are Objects

- Creating User Defined Types
*/
create type AMS.[Phone] from varchar(10);

create table ams.[staging_user]
(
userid int identity(1, 1) primary key,
username nvarchar(100),
phoneNo AMS.[phone]
);

insert into ams.[staging_user] (username, phoneNo) values ('suraj sah', 1234567890);

select * from ams.[staging_user];


/*
## TABLE Types
*/
create type ams.[BasicUser] as table
(
  userid int identity(1, 1) primary key,
  username nvarchar(100),
  phoneNo ams.[Phone]
);

-- drop type ams.[BasicUser]

create proc ams.[test_udt]
as
begin
  declare @buser as ams.[BasicUser];
  
  select * from @buser;

  insert into @buser values 
  ('test2', 9808908909),
  ('test2', 7283263289);

  select * from @buser;

end
exec ams.[test_udt];