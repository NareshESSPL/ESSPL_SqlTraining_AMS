/*
Index
*/

-- Creating Non-Clustered Index on AccountAnalytics Table

select * from AMS.[AccountAnalytics];

create nonclustered index IX_AccountAnalytics_Username_DOB
ON AMS.[AccountAnalytics] (UserName, DOB);

select * from AMS.[AccountAnalytics] where username like '%60%' and dob > '2000-01-01';