-- Schema: CREATE TABLE acronym ( phrase TEXT PRIMARY KEY, result TEXT );
-- Task: update the acronym table and set the result based on the phrase.
-----------------------------------------
-- change '-' to ' ' and convert everything to uppercase
UPDATE acronym SET result = upper(replace(phrase, '-', ' '));

-- erase everything that is not letter or space
UPDATE acronym SET result =(
    WITH RECURSIVE series(n, c) AS (
        SELECT 1, IIF(SUBSTR(result, 1, 1) GLOB '[A-Z]' OR SUBSTR(result, 1, 1) = ' ', SUBSTR(result, 1, 1), '')
        UNION ALL
        SELECT n + 1, IIF(SUBSTR(result, n+1, 1) GLOB '[A-Z]' OR SUBSTR(result, n+1, 1) = ' ', SUBSTR(result, n+1, 1), '')
        FROM series
        WHERE n < length(result)
    ) SELECT GROUP_CONCAT(c, '') FROM series
);
-- take only letters that follow a space
UPDATE acronym SET result = (
    WITH RECURSIVE series (n, c) AS(
        SELECT 1, IIF(SUBSTR(result, 1, 1) GLOB '[A-Z]', SUBSTR(result, 1, 1), '')
        UNION ALL
        SELECT n+1, IIF(SUBSTR(result, n+1, 1) GLOB '[A-Z]' AND SUBSTR(result, n, 1) = ' ', SUBSTR(result, n+1, 1), '')
        FROM series
        WHERE n < length(result)
    ) SELECT GROUP_CONCAT(c, '') FROM series
);