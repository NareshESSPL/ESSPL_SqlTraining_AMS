Select * From AMS.[User]
--Rank
Declare @DOB [DateTime];
set @DOB = DateAdd(Month,1,Cast('1970-01-01' As Date))
Print @DOB

Declare @Date Datetime
--Set Date = '1971-01-08'

Print DateDiff(Year,@Date,GetDate());

/*--*/

Select * From AMS.[User]


Select 
UserId,
Username,
DOB,
DateDiff(Year,DOB,GetDate())
Case
When Month(DOB) > Month(GetDate())
OR (Month(DOB) = Month(GetDate()) And Day(DOB) > Day(GetDate()))
Then 1
Else 0
End AS Age
From AMS.[User];

Case
When DateDiff(Year,DOB,GetDate()) > 10 And DateDiff(Year,DOB,GetDate()) < 20 Then
When DateDiff(Year,DOB,GetDate()) > 20 And DateDiff(Year,DOB,GetDate()) < 30 Then
When DateDiff(Year,DOB,GetDate()) > 30 And DateDiff(Year,DOB,GetDate()) < 45 Then
When DateDiff(Year,DOB,GetDate()) > 45 Then 'D'
Else 'Invalid Age'
End As AgeGroup
mlmlmpooojo76r6a2ar	2Q09=


