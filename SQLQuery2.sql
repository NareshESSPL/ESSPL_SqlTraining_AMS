CREATE TABLE Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

select * from Account