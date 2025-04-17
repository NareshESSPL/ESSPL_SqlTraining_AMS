use [AccountManagementSystem]
go

declare @TestxmlType xml
set @TestXmlType = 
'<xml>
	<User>
	   <FName></FName>
	   <LName></LName>
	</User>
</xml>'

select @TestxmlType

--display the lastname from an XML as output
alter PROC proc_TestOutputParam
(
 @Input XML,
 @Output VARCHAR(100) OUTPUT
)
AS
BEGIN
  SET @Output = @Input.value('(xml/User/LName)[1]','varchar(100)')
END
go

DECLARE @InputParam XML, @OutputParam VARCHAR(100)
SET @InputParam = '<xml>
	<User>
	   <FName>Naresh</FName>
	   <LName>Pradhan</LName>
	</User>
</xml>'

EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT
PRINT @OutputParam


--row_num, rank, dense rank applied on AccountAnalysis table
select ROW_NUMBER() over(partition by YEAR(DOB) order by Balance) as row_num , 
       RANK() over(partition by YEAR(DOB) order by Balance) as rnk, 
	   DENSE_RANK() over(partition by YEAR(DOB) order by Balance) as dense_rnk, Balance, YEAR(DOB) as YOB , UserName from AMS.[AccountAnalysis]



--find out the user who have the min balance among the users having more than 3 accounts 
select year(DOB), count(UserId) as u, count(AccountId) a from AMS.[AccountAnalysis] group by year(DOB)