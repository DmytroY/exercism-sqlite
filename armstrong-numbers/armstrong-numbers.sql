-- Schema: CREATE TABLE "armstrong-numbers" ("number" INT, "result" BOOLEAN);
-- Task: update the armstrong-numbers table and set the result based on the number field.

UPDATE "armstrong-numbers" SET result = (
    CASE
        WHEN number = (
                WITH series(n, m) AS(
                    SELECT number, pow(number % 10, length(number))
                    UNION ALL
                    SELECT CAST(n / 10 AS INTEGER), pow(CAST(n / 10 AS INTEGER) % 10, length(number)) FROM series WHERE CAST(n / 10 AS INTEGER) > 0
                )SELECT sum(m) FROM series
            )
            THEN true
        ELSE false
        END
);