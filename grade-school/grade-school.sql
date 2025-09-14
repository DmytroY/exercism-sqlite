-- Schema:
-- CREATE TABLE "grade-school" (
--   property TEXT NOT NULL,
--   input    TEXT NOT NULL,    -- json object
--   result   TEXT              -- json array
-- );
--
-- Task: update the grade-school and update the result column based on the property and the input.

UPDATE "grade-school"
SET result =(
    SELECT json_group_array(name)
    FROM (
        SELECT DISTINCT
            value ->>'$[0]' AS name
        FROM json_each("grade-school".input ->> '$.students')
        ORDER BY value ->>'$[1]', value ->>'$[0]'
    )
)
WHERE property = 'roster';

UPDATE "grade-school"
SET result = (
    SELECT json_group_array(IIF(first_occur, json('true'), json('false'))) FROM(
        SELECT
            1 = ROW_NUMBER() OVER(PARTITION BY value ->> '$[0]') AS first_occur
        FROM
            json_each("grade-school".input ->> '$.students')
    )
)
WHERE property = 'add';

UPDATE "grade-school"
SET result = (
    SELECT json_group_array(name)
    FROM(
        SELECT
            value ->> '$[0]' AS name,
            CAST(value ->> '$[1]' AS INTEGER) AS grade,
            ROW_NUMBER() OVER(PARTITION BY value -> '$[0]') AS occurence
        FROM json_each("grade-school".input ->> '$.students')
    )
    WHERE occurence = 1 AND grade = (
        SELECT value AS desired_grade
        FROM json_each("grade-school".input ->> '$.desiredGrade')
    )
)
WHERE property = 'grade';