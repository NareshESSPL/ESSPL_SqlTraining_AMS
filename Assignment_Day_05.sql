/**
 Use master database for results
 **/
create proc GradeSalaryDetails
@EmployeeID bigint,
@Grade char(1),
@Salary decimal(10,6),
@Name varchar(250),
@DOJ datetime 
as
begin

declare @count int,@Grade_New char(1) 

set @count=1

while @count <= 12 
begin

set @Grade_New = char(ascii('A') + @count%3)

----filling employee table------
insert into [dbo].[Employee]([EmployeeID],[Grade],[Salary],[Name],[DOJ])
values(
       @EmployeeID+@count,
	   @Grade_New,
	   @Salary+@count%4,
	   @Name,
	   DATEADD(month,@count,@DOJ)
	   );

set @count=@count+1

end

SELECT E.*, AVG(E.Salary) OVER (PARTITION BY E.Grade) AS AvgSalaryPerGrade
FROM [dbo].[Employee] E;

end

EXEC GradeSalaryDetails 
    @EmployeeID = 1000,
    @Grade = 'A',
    @Salary = 4000,
    @Name = 'Anubhab',
    @DOJ = '2025-04-14';


