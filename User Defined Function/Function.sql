USE AccountManagementSystem
GO

create function AMS.GetFinalBill 
(
  @Invoice float
)
returns float
as
begin

  return @Invoice * 0.18 + @Invoice * 0.02

end
--------------------------------------------
alter function AMS.GetFinalBill 
(
  @Invoice float
)
returns float
as
begin

  return @Invoice * 0.18 + @Invoice * 0.02 + 10

end

print AMS.GetFinalBill(100)


create type udt_testing as table
(
 id int
)

create function func_testing 
(
 @id int
)
returns @temp table
(
 id int
)
as
begin
 insert into @temp values (1)
 
 insert into @temp values (1)
 return
end


select * from dbo.func_testing (1)

