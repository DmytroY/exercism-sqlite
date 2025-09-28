-- Schema:
-- CREATE TABLE "sum-of-multiples" (
--     factors TEXT    NOT NULL,     -- json array of integers
--     "limit" INTEGER NOT NULL,
--     result  INTEGER
-- );
--
-- Task: update the "sum-of-multiples" table and set the result based on the phrase.

UPDATE "sum-of-multiples"
SET result = (WITH series(n, m) AS (
    SELECT value, value FROM json_each(factors) WHERE value < "limit"
    UNION ALL
    SELECT n, m + n from series WHERE m + n < "limit" AND n > 0
) SELECT COALESCE(sum(DISTINCT m), 0) FROM series
);