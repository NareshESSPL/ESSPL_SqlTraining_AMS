CREATE TABLE AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

select * from AccountTransaction 