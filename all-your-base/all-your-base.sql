-- Schema: CREATE TABLE IF NOT EXISTS "all-your-base" (
--           input_base  INTEGER NOT NULL,
--           digits      TEXT    NOT NULL,  -- json array
--           output_base INTEGER NOT NULL,
--           result      TEXT               -- json object
--         );
-- Task: update the all-your-base table and set the result based on converting
--       digits from input_base to output_base.
--       * the digits column contains a JSON-encoded list of integers.
--       * the result column should contain JSON-encoded data: an
--         object with the digits as integers or a descripition of any errors.

-- process error and edge cases, convert to decimal
UPDATE "all-your-base" SET result = (
    CASE
        WHEN input_base < 2 THEN json('{"error":"input base must be >= 2"}')
        WHEN output_base < 2 THEN json('{"error":"output base must be >= 2"}')
        WHEN (SELECT MIN(value) FROM json_each(digits)) < 0
            OR
            (SELECT MAX(value) FROM json_each(digits)) >= input_base
            THEN json('{"error":"all digits must satisfy 0 <= d < input base"}')
        WHEN digits = '[]' THEN 0
        ELSE (
            WITH RECURSIVE series(n, v) AS  (
                SELECT 0, (digits ->> (json_array_length(digits) - 1)) * pow(input_base, 0)
                UNION ALL
                SELECT n+1, (digits ->> (json_array_length(digits) - 2 - n)) * pow(input_base, n+1) FROM series WHERE (n+1) < json_array_length(digits)
            ) SELECT CAST(SUM(v) AS INTEGER) FROM series
        )
    END
);

-- converd decimal to result
UPDATE "all-your-base" SET result =(
    SELECT json_insert('{}', '$.digits', json_group_array(v))
    FROM(
        WITH RECURSIVE series (n, q, v) AS(
            SELECT 0, CAST(result / output_base AS INTEGER) , CAST(result % output_base AS INTEGER)
            UNION ALL
            SELECT n + 1, CAST(q / output_base AS INTEGER), cast(q % output_base AS INTEGER) FROM series WHERE q >= 1
        ) SELECT v FROM series ORDER BY n DESC
    ) 
)WHERE result GLOB('[0-9.]*');
