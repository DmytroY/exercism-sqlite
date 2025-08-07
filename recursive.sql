CREATE VIEW const AS
    SELECT 5 AS cycle_limit;

WITH RECURSIVE series (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM series, const WHERE n < cycle_limit
)
SELECT n FROM series;

-- 1
-- 2
-- 3
-- 4
-- 5