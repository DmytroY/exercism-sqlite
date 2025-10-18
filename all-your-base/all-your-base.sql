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

UPDATE "all-your-base" SET result = (
    CASE
        WHEN input_base < 2 THEN json('{"error":"input base must be >= 2"}')
        WHEN output_base < 2 THEN json('{"error":"output base must be >= 2"}')
        WHEN (SELECT MIN(value) FROM json_each(digits)) < 0
            OR
            (SELECT MAX(value) FROM json_each(digits)) >= input_base
            THEN json('{"error":"all digits must satisfy 0 <= d < input base"}')
        WHEN digits = '[]' THEN '{"digits":[0]}'
        ELSE (
            WITH inbase(i, s) AS (
                    SELECT 0, (digits ->> 0) * pow(input_base, json_array_length(digits) - 1 - 0)
                    UNION ALL
                    SELECT i + 1, s + (digits ->> (i + 1)) * pow(input_base, json_array_length(digits) - 1 -(i + 1))
                    FROM inbase WHERE i < json_array_length(digits) - 1
                ),
                outbase(j, d, b) AS(
                    SELECT 0,
                        CAST((SELECT s FROM inbase WHERE i = json_array_length(digits) - 1) /output_base AS INTEGER),
                        CAST((SELECT s FROM inbase WHERE i = json_array_length(digits) - 1) % output_base AS INTEGER)
                    UNION ALL
                    SELECT j + 1,
                        CAST(d / output_base AS INTEGER),
                        CAST(d % output_base AS INTEGER)
                    FROM outbase WHERE d > 0
                )
            SELECT json_object('digits', json_group_array(b)) FROM (SELECT b FROM outbase ORDER BY j DESC)
        )
    END
);
