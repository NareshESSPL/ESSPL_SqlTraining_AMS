/*

# Conditional Statements
-if else
 if multiple statements are there, you have to write BEGIN and END after the IF statement

 # LOOPS
  - WHILE 
*/
declare @input varchar(10);
set @input = 'Suraj';

if @input like '%U%'
BEGIN
  print 'your name contains u'
  print 'Good to go'
END
else
  print 'HelloWorld'


if exists(select top 1 UserName from ams.[User] where UserName like 'A%')
  print 'Found'

else
  print 'Not Found'

