USE BankingManagementSystem;


INSERT INTO BMS.[User] (Username, DOB, DOJ, Balance, MobileNo, CreatedBy, Created)
VALUES 
('John Doe', '1985-01-15', '2020-06-01', 1000.50, 12345678, 'Admin', GETDATE()),
('Jane Smith', '1990-02-20', '2021-07-15', 2500.75, 23456789, 'Admin', GETDATE()),
('Alice Johnson', '1988-03-25', '2019-08-10', 1500.00, 34567890, 'Admin', GETDATE(),
('Dummyname','1956-08-17','2010-07-08',));




SELECT * FROM BMS.[USER];GO

INSERT INTO BMS.[Address] (Username,UserID, Address, CreatedBy,CreatedDate)
VALUES 
('John Doe',1,'123 Main St, Springfield', 'Admin',GETDATE()),
('Jane Smith',2,'456 Elm St, Metropolis', 'Admin',2025-04-08),
('Alice Johnson',3,'789 Oak St, Gotham', 'Admin',2025-04-07);

SELECT * FROM BMS.[Address];
GO

/*
ALTER TABLE BMS.[Address]
ADD CreatedDate DateTime Not Null Default GETDATE(); 
*/


INSERT INTO BMS.[Account] (Username,AccountNo, IsSaving, CreatedBy,Created)
VALUES 
('John Doe',123456, 1, 'Admin',GETDATE()),
('Jane Smith',678910,0, 'Admin',2025-04-08),
('Alice Johnson',345678, 1, 'Admin',2025-04-07);


SELECT * FROM BMS.[ACCOUNT];

--Delete from BMS.[Account] where AccountID in (4,5,6);


INSERT INTO BMS.[UserAccountMapping] (Username, UserID,AccountID,CreatedBy,CreatedDate)
VALUES 
('John Doe', 1,1, 'Admin',GETDATE()),
('Jane Smith', 2,2, 'Admin',GETDATE()),
('Alice Johnson', 3,3, 'Admin',GETDATE());

--DELETE FROM BMS.[USERACCOUNTMAPPING] WHERE USERACCOUNTMAPPINGID = 3;

SELECT * FROM BMS.[UserAccountMapping];

INSERT INTO BMS.[AccountTransaction] (Username, Amount, IsDebit, CreatedBy,CreatedDate)
VALUES 
('John Doe',1000.00, 1, 'Admin',GETDATE()),  -- Debit transaction
('John Doe',500.00, 0, 'Admin',GETDATE()),   -- Credit transaction
('John Doe',750.00, 1, 'Admin',GETDATE());   -- Debit transaction
GO

--UPDATE BMS.[AccountTransaction]
--SET CreatedDate = '2025-04-09 11:00:57' WHERE AccountTransaction = 3;


SELECT * FROM BMS.[AccountTransaction];