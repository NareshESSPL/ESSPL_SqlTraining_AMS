 --Assignment 

CREATE TYPE Ams.Account_info AS TABLE 
(
	AcountID INT,
	AcountNo INT
);
GO

 alter proc TestMultiInput
	@Input varchar(max)
	as
	begin
		DECLARE @AccountInfo as Ams.Account_info;

		insert into @AccountInfo
		select left(value,CHARINDEX(':',value)-1),RIGHT(value,len(value)-CHARINDEX(':',value)) 
		from string_split(@input,',')

		select * from @AccountInfo
	end



exec TestMultiInput '111:2222, 123:677, 890:900'
