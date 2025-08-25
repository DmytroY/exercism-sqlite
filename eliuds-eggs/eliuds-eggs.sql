-- Schema: CREATE TABLE "eliuds-eggs" ("number" INT, "result" INT);
-- Task: update the eliuds-eggs table and set the result based on the number field.

UPDATE "eliuds-eggs" SET result = (
    WITH RECURSIVE series (n, b) AS (
        SELECT "eliuds-eggs".number, "eliuds-eggs".number % 2
        UNION ALL
        SELECT n / 2,  (n / 2) % 2 FROM series WHERE n > 0
    ) SELECT SUM(b) FROM series
);