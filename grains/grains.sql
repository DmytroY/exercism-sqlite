-- Schema: CREATE TABLE "grains" ("task" TEXT, "square" INT, "result" INT);
-- Task: update the grains table and set the result based on the task (and square fields).

-- UPDATE grains SET result = IIF(task == 'single-square', pow(2, square-1),
--         WITH RECURSIVE series(n) AS(
--             SELECT 1
--             UNION ALL
--             SELECT n * 2 WHERE n < 64
--         ) SELECT sum(n) FROM series
--     );

UPDATE grains SET result = pow(2, square-1) WHERE task == 'single-square';
UPDATE grains SET result =(
        WITH RECURSIVE series(n, grains) AS (
            SELECT 1, 1
            UNION ALL
            SELECT n +1, grains * 2 FROM series WHERE n < 64
        ) SELECT sum(grains) FROM series
    ) WHERE task == 'total';
           