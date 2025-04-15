create nonclustered index IX_AccountAnalysis_Username_DOB
ON AMS.AccountAnalysis (UserName, DOB)

select * from AMS.AccountAnalysis where DOB > getdate()