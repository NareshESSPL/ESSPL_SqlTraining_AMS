/*
Created By : SUraj Kumar Sah
Date : 14-04-2025
Desc : Functions
*/
GO
USE AccountManagementSystem;
GO

CREATE function AMS.[GetFinalBill]
(
 @Invoice float
)
 returns float
 AS
 BEGIN
  return @Invoice * 0.18 + @Invoice * 0.02
 END

 PRINT AMS.[GetFinalBill] (100)

 --------------------------------
 -- Altering the Function
 ALTER function AMS.[GetFinalBill]
(
 @Invoice float
)
 returns float
 AS
 BEGIN
  return @Invoice * 0.18 + @Invoice * 0.02 + 10

 END

 PRINT AMS.[GetFInalBill](200)
 ----------------------------------------

 /*
 Class Exercise
 */
-- Funtion
create function func_testing (@id INT)
returns @temp table (id int)
as
begin
 insert into @temp values (1);
 insert into @temp values (2);
 
 return
end


select * from dbo.func_testing(1);
-----------------

