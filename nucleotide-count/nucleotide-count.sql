-- Task:  - Update the "nucleotide-count" table and set the result based on the input field.
--        - Update table creation with constraints.
DROP TABLE IF EXISTS "nucleotide-count";

CREATE TABLE "nucleotide-count" ("strand" TEXT, "result" TEXT);

-- Please don't change the following two import lines. Feel free to edit the previous lines, though.
.mode csv
.import ./data.csv "nucleotide-count"
-- Write your code below. Feel free to edit the CREATE TABLE above, too!

WITH RECURSIVE chars AS (
  SELECT 1 AS pos, SUBSTR(strand, 1, 1) AS nuc
  UNION ALL
  SELECT pos + 1, SUBSTR(strand, pos + 1, 1)
  FROM chars
  WHERE pos < LENGTH(strand)
)
UPDATE "nucleotide-count"
SET result = (
    SELECT json_patch(
        '{"A": 0, "C": 0, "G": 0, "T": 0}',
        json_group_object(nuc, c)
    )
    FROM (SELECT nuc, COUNT(*) as c FROM chars GROUP BY nuc ORDER BY nuc asc)
);
-- edge case
UPDATE "nucleotide-count" SET result = json('{"A": 0, "C": 0, "G": 0, "T": 0}') WHERE strand == '';