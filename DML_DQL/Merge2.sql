create table testMergeSource
(
  id int identity(1,1) primary key,
  name varchar(200)
)


create table testMergeTarget
(
  id int primary key,
  name varchar(200),
  CreatedDate DateTime,
)

insert into testMergeSource values ('naresh')

insert into testMergeSource values ('suresh')

insert into testMergeSource values ('mahesh')
--update testMergeSource set name = 'testupdateS12' where id = 3

set identity_insert testMergeTarget on
insert into  testMergeTarget(id, name) values(9, 'testInsertT')
set identity_insert testMergeTarget off

MERGE testMergeTarget t
 USING testMergeSource s ON s.id= t.id

WHEN MATCHED
    THEN UPDATE SET 
        t.name = s.name

WHEN NOT MATCHED BY TARGET
    THEN INSERT (name) values (s.name)

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

	select * from testMergeTarget





