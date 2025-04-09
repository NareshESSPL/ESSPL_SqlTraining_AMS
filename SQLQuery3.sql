CREATE TABLE UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Userr(UserID),
);

select * from UserAccountMapping