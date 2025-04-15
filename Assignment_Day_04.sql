 
 use AccountManagementSystem;
 /*Question */
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

--Answer



 CREATE TYPE AMS.Parse_Table AS TABLE 
(
	AcountID INT,
	AcountNo INT
);
GO
--drop proc TestMultiInput
go
create proc TestMultiInput
	@Input varchar(max)
	as
	begin
		DECLARE @Parse_Table as AMS.Parse_Table;

		insert into @Parse_Table
		select left(value,CHARINDEX(':',value)-1),RIGHT(value,len(value)-CHARINDEX(':',value)) 
		from string_split(@input,',')

		select * from @Parse_Table
	end



exec TestMultiInput '111:2222, 123:677, 890:900'

 drop procedure TestMultiInput;

