-- Schema:
-- CREATE TABLE "sum-of-multiples" (
--     factors TEXT    NOT NULL,     -- json array of integers
--     "limit" INTEGER NOT NULL,
--     result  INTEGER
-- );
--
-- Task: update the "sum-of-multiples" table and set the result based on the phrase.

UPDATE "sum-of-multiples"
SET result = (
    SELECT SUM(d_mltpls)
    FROM(
        SELECT DISTINCT y_je2.value AS d_mltpls
        FROM(
            SELECT json_group_array(vals) AS nested_array
            FROM (
                SELECT (
                    WITH RECURSIVE series(v) AS (
                        SELECT t.value WHERE t.value < "sum-of-multiples"."limit" AND t.value > 0
                        UNION ALL
                        SELECT v + t.value FROM series WHERE v + t.value < "sum-of-multiples"."limit"
                    )
                    SELECT json_group_array(v) FROM series
                    ) AS vals
                FROM json_each("sum-of-multiples".factors) AS t
            )  
        ) AS t_grupped_array,
            json_each(t_grupped_array.nested_array) AS t_je,
            json_each(t_je.value) AS y_je2
        ORDER BY y_je2.value
    )
);

UPDATE "sum-of-multiples"
SET result = 0
WHERE result IS NULL;