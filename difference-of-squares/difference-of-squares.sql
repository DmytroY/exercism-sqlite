-- Schema: CREATE TABLE "difference-of-squares" ("number" INT, "property" TEXT, "result" INT);
-- Task: update the difference-of-squares table and set the result based on the number and property fields.

UPDATE "difference-of-squares"
    SET result = (
        WITH RECURSIVE series(n) AS (
            SELECT 1
            UNION ALL
            SELECT n + 1 FROM series WHERE n < "difference-of-squares".number
        ) SELECT pow(sum(n), 2) FROM series
    )
    WHERE "property" == 'squareOfSum';

UPDATE "difference-of-squares"
    SET result =(
        WITH RECURSIVE series(n) AS (
            SELECT 1
            UNION ALL
            SELECT n+1 FROM series WHERE n < "difference-of-squares".number
        ) SELECT sum(pow(n, 2)) FROM series
    )
    WHERE "property" == 'sumOfSquares';

UPDATE "difference-of-squares"
    SET result = (
        WITH RECURSIVE series(n) AS (
            SELECT 1
            UNION ALL
            SELECT n+1 FROM series WHERE n < "difference-of-squares".number
        ) SELECT pow(sum(n), 2) - sum(pow(n, 2)) FROM series
    )
    WHERE "property" == 'differenceOfSquares';

