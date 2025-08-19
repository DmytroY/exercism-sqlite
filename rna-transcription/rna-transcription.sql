-- Schema: CREATE TABLE "rna-transcription" ("dna" TEXT, "result" TEXT);
-- Task: update the rna-transcription table and set the result based on the dna field.

UPDATE "rna-transcription" SET result = (
    WITH RECURSIVE series(n, compl) AS(
        SELECT 1, 
            CASE substr("dna", 1, 1)
                WHEN 'G' THEN 'C'
                WHEN 'C' THEN 'G'
                WHEN 'T' THEN 'A'
                WHEN 'A' THEN 'U'
                ELSE ''
            END

        UNION ALL
        SELECT n + 1,
            CASE substr("dna",n + 1, 1)
                WHEN 'G' THEN 'C'
                WHEN 'C' THEN 'G'
                WHEN 'T' THEN 'A'
                WHEN 'A' THEN 'U'
                ELSE ''
            END
            FROM series WHERE n < length("dna")
    ) SELECT group_concat(compl, '') FROM series
);