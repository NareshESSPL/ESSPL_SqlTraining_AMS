declare @Input varchar(100)
set @Input = 'SAD'

IF @Input like '%ad%'
 print 'hello'

ELSE
 print 'No hello'

IF @Input Not like '%ax%'
begin
 print 'hello'
 print 'let go'
end

ELSE
begin
 print 'No hello'
 print 'No go'
end

declare @UName varchar(100)
set @UName = (select top 1 UserName from AMS.[User] where UserName like 'naresh')
if @UName is not null
 print 'hello'

if exists(select top 1 * from AMS.[User] where UserName like 'naresh')
 print 'hello'

if not exists(select top 1 * from AMS.[User] where UserName like 'ssdad')
 print 'hello'

