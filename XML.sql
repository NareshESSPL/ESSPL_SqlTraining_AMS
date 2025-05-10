declare @TestXmlType xml
set @TestXmlType = '<xml>'
'<xml>
   <User>
       <Fname></Fname>
       <Lname></Lname>
   </User>
</xml>'

select @TestXmlType
---------------PRINT LAST NAME---------------
create proc proc_TestOutputParam
(
 @Input xml,
 @Output varchar(100) output
)
as
begin
  set @Output = 'Testing'
end


declare @InputParam xml
set @InputParam = '<xml>
 <User>
       <Fname> Khushboo</Fname>
       <Lname> Kumari</Lname>
   </User>
</xml>'

--print substring(@InputParam,charindex ('<LName>',@InputParam)+ len('<LName>'),---(WAY TO PRINT LAST NAME AND LENGTH)
--charindex ('</LName>',@InputParam)-charindex ('<LName>',@InputParam)+ len('<LName>'))

--select @InputParam.value('(xml/User/Lname)[1]','nvarchar(100)') as LastName;-----(ANOTHER WAY TO PRINTLAST NAME)
 


exec proc_TestOutputParam @Input = @InputParam ,@Output = @OutputParam output
print @OutputParam