-- Schema: CREATE TABLE pangram (sentence TEXT NOT NULL, result BOOLEAN);
-- Task: update pangram table and set result based on sentence.

UPDATE pangram SET result = (
    WITH RECURSIVE series(n, s) AS(
        SELECT 97,
            CASE
                WHEN sentence LIKE '%' || char(97) || '%' THEN 1
                ELSE 0
            END
        UNION ALL
        SELECT n+1,
            CASE
                WHEN sentence LIKE '%' || char(n)|| '%' THEN 1
                ELSE 0
            END
            FROM series WHERE n < 122
    ) SELECT min(s) FROM series
);
