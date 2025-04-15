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


/*
   row_num assign unique mumber based on group and order by
   [Rank] assign rank based on group and order by, but same group item has same rank e..g 
     dept sal   rank dense_rank
	 1    1000   1     1
	 1    1000   1     1
	 1    1000   1     1
	 1    2000   4     2
*/
SELECT *,
ROW_NUMBER() OVER(PARTITION BY DeptId ORDER BY Salary) AS RowNumber,
      RANK() OVER(PARTITION BY DeptId ORDER BY Salary) AS [Rank],
DENSE_RANK() OVER(PARTITION BY DeptId ORDER BY Salary) AS [DenseRank]
FROM [dbo].[Emp]


SELECT *,
ROW_NUMBER() OVER(ORDER BY Salary) AS RowNumber,
      RANK() OVER(ORDER BY Salary) AS [Rank],
DENSE_RANK() OVER(ORDER BY Salary) AS [DenseRank]
FROM [dbo].[Emp]