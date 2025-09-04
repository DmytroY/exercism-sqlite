-- Schema: CREATE TABLE "etl" ("input" TEXT, "result" TEXT);
-- Task: update the etl table and set the result based on the input field. The keys in the result object must be sorted alphabetically.

UPDATE etl SET result = (
    
    WITH j_t(k, v) AS (
        SELECT key, value
        FROM json_each(etl.input)
    )
    SELECT json_group_object(lower(value), CAST(k AS INTEGER))
    FROM(
        SELECT j_arr.value, j_t.k
        FROM j_t, json_each(j_t.v) as j_arr
        ORDER BY j_arr.value
    )
);
