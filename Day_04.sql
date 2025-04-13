use DB1;
create proc AM.TestMultiInput
@Input varchar(100)
as begin
  create table #TempTable (
    AccountId varchar(100), 
	AccountNo varchar(100)
  )

  declare @pair varchar(100)
  declare @fpos int
  declare @lpos int

  set @fpos = 1
  set @lpos = CHARINDEX(',',@Input)

  while @lpos >= 0
  begin
	declare @first varchar(100)
	declare @last varchar(100)

    set @pair = SUBSTRING(@Input,@fpos,@lpos - @fpos)

	set @first = LEFT(@pair,CHARINDEX(':',@pair)-1)
	set @last = right(@pair,len(@pair) - CHARINDEX(':',@pair))

    insert into #TempTable values (@first,@last)

	print ' before first pos: ' + convert(varchar, @fpos) + 'last pos :' + convert(varchar, @lpos)

    set @fpos = @lpos + 1
	set @lpos = CHARINDEX(',',@Input,@fpos) 

	print ' after first pos: ' + convert(varchar, @fpos) + 'last pos :' + convert(varchar, @lpos)

	if @lpos = 0 
	break;

  end

  set @pair = SUBSTRING(@Input,@fpos,len(@Input) - @fpos + 1)
  insert into #TempTable values (
     LEFT(@pair,CHARINDEX(':',@pair)-1),
	 right(@pair,len(@pair) - CHARINDEX(':',@pair))
  )

  select * from #TempTable
end


exec AM.TestMultiInput '111:222,123:677,890:900'
