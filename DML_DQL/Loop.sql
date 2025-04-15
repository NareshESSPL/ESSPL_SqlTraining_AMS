create proc TestMultiInput
@Input varchar(max)
as
begin
end

exec TestMultiInput '111:2222, 123:677, 890:900'

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

insert into #tempInput values('111:222,123:677,2828282, kkkk')

declare @temp varchar(100)
set @temp = (select top 1 input from #tempInput)
while @temp is not null
begin
     
	--to break the loop
	if(@temp like 'kkkk')
	  break

	--the loop will  not excute the statement after the continue 
	--and will move to next item in the loop
	if(@temp like '2828282')
	  continue

    print @temp 
	delete from #tempInput where input = @temp
    set @temp = (select top 1 input from #tempInput)
end

DROP TABLE #tempInput;



  