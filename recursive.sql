CREATE VIEW const AS
    SELECT 5 AS cycle_limit;

WITH RECURSIVE series (n, grains) AS (
    SELECT 1, 1
    UNION ALL
    SELECT n + 1, grains * 2 FROM series, const WHERE n < cycle_limit
)
SELECT grains FROM series;

-- 1
-- 2
-- 4
-- 8
-- 16