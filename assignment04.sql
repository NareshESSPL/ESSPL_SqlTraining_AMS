
--.................task at hand -)assignment--------------- 
if OBJECT_ID(#tempInput) is not null


create table #tempInput 
(
  input varchar(200)
)

insert into #tempInput values('111:2222'), ('123:677')

declare @temp varchar(100)
set @temp = (select top 1 input from #tempInput)
while @temp is not null
begin
    declare @temp2 varchar(20)
	set @temp2 = substring(@temp,1,CHARINDEX(':',@temp)-1) + ' ' +substring(@temp,charindex(':',@temp)+1,len(@temp))
	print @temp2
	delete from #tempInput where input = @temp
    set @temp = (select top 1 input from #tempInput)
end

DROP TABLE #tempInput;
