/*
 Created By : Suraj Kumar Sah
 Date : 16-04-2025
 Desc : Rank
*/

CREATE TABLE [Emp] (
    [EmpId] INT NOT NULL IDENTITY(1, 1),
    [Name] VARCHAR(255) NULL,
    [DeptId] INT NULL,
    [Salary] INT NULL,
    PRIMARY KEY ([EmpID])
);
GO
TRUNCATE TABLE [Emp]
INSERT INTO [Emp] ([Name], DeptId, Salary)
VALUES
  ('Britanni',3,1000),
  ('Julian',2,2000),
  ('Dolan',3,3000),
  ('Jonah',4,4000),
  ('Fulton',2,5000),
  ('Scarlett',4,1000),
  ('Bernard',2,2000),
  ('Chancellor',1,3000),
  ('Dalton',4,4500),
  ('Len',1,5000),
  ('Bree',4,1000),
  ('Cooper',1,2000),
  ('Nora',4,3000),
  ('Gareth',3,4000),
  ('Beau',2,5000); 

INSERT INTO [Emp] ([Name], DeptId, Salary)
VALUES ('Beau', 2, 4000);
GO

SELECT *, 
ROW_NUMBER() OVER(ORDER BY Salary) AS RowNumber, Salary,
RANK() OVER(ORDER BY Salary) AS [Rank], Salary,
DENSE_RANK() OVER(ORDER BY Salary) AS [DenseRank]
FROM Emp;

SELECT DEPTID, 
SUM(Salary) OVER(PARTITION BY DEPTID) AS [SUM],
MIN(Salary) OVER(PARTITION BY DEPTID) AS [MIN],
MAX(Salary) OVER(PARTITION BY DEPTID) AS [MAX]
FROM Emp GROUP BY DEPTID;
GO

------------------------------------------------------------------------