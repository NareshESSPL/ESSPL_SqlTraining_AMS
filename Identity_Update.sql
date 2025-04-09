create table IdentTets
(
 id int identity(1,1) not null primary key,
 name varchar(250)
)

insert  into IdentTets values ('test1'), ('test2')

select * from IdentTets

delete from IdentTets where id = 2

insert  into IdentTets values ('test2')

sp_help IdentTets

alter table IdentTets drop constraint PK__IdentTet__3213E83FB59D7ED6

alter table IdentTets drop column id

alter table IdentTets add id int identity(1,1) not null primary key

----------------------
DBCC checkident('IdentTets', reseed, 8)







