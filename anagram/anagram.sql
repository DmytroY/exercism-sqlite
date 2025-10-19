-- Schema: CREATE TABLE anagram (
--           subject    TEXT NOT NULL,
--           candidates TEXT NOT NULL,     -- json array of strings
--           result     TEXT               -- json array of strings
--         );
-- Task: update the anagram table and set the result based on valid
--       candidates for the subject field
--       * the candidates column contains a JSON-encoded list of strings.
--       * the result column should contain JSON-encoded list of
--         strings as well.

ALTER TABLE anagram ADD COLUMN subj_hash;
UPDATE anagram SET subj_hash =(
    WITH series (i, m) AS(
        SELECT 1, pow(unicode(lower(substring(subject,1,1))), 2)
        UNION ALL
        SELECT i+1, pow(unicode(lower(substring(subject,i+1,1))), 2) FROM series WHERE i < length(subject)
    ) SELECT sum(m) FROM series
);

UPDATE anagram SET result = (
    WITH words AS (
    SELECT
        value,
        (
            WITH series (i, m) AS(
                SELECT 1, pow(unicode(lower(substring(value,1,1))), 2)
                UNION ALL
                SELECT i+1, pow(unicode(lower(substring(value,i+1,1))), 2) FROM series WHERE i < length(value)
            ) SELECT sum(m) FROM series
        ) AS hash
    FROM json_each(candidates))
SELECT json_group_array(value) FROM words WHERE hash = subj_hash AND lower(value) != lower(subject)
);