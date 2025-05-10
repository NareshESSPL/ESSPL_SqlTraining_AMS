IF OBJECT_ID('tempdb..#inputString') IS NOT NULL DROP TABLE #inputString;
IF OBJECT_ID('tempdb..#splitPairs') IS NOT NULL DROP TABLE #splitPairs;
IF OBJECT_ID('tempdb..#finalOutput') IS NOT NULL DROP TABLE #finalOutput;

CREATE TABLE #inputString (fullInput VARCHAR(MAX));
INSERT INTO #inputString VALUES ('111:2222,123:677,890:900');

CREATE TABLE #splitPairs (pair VARCHAR(100));

INSERT INTO #splitPairs (pair)
SELECT value
FROM STRING_SPLIT((SELECT fullInput FROM #inputString), ',');

CREATE TABLE #finalOutput (col1 VARCHAR(100), col2 VARCHAR(100));

INSERT INTO #finalOutput (col1, col2)
SELECT 
    LEFT(pair, CHARINDEX(':', pair) - 1),
    RIGHT(pair, LEN(pair) - CHARINDEX(':', pair))
FROM #splitPairs;

SELECT * FROM #finalOutput;