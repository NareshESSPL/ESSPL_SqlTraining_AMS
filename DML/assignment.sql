create proc TestMultiInput
@Input varchar(max)
as
begin
end

exec TestMultiInput '111:2222', '123:677', '890:900'

-----sample output
--AcountID AcountNo
--111      2222
--123      677
--890      900

IF OBJECT_ID('tempdb..#tempInput') IS NOT NULL
DROP TABLE #tempInput;

create table #tempInput 
(
  input varchar(200)
)

insert into #tempInput values('111:2222'), ('123:677')

declare @temp varchar(100)
set @temp = (select top 1 input from #tempInput)
while @temp is not null
begin
    print @temp 
	delete from #tempInput where input = @temp
    set @temp = (select top 1 input from #tempInput)
end

DROP TABLE #tempInput;



  