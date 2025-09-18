-- Schema:
-- CREATE TABLE matrix (
--     string   TEXT    NOT NULL,  -- the matrix as a plain string
--     property TEXT    NOT NULL,  -- either "row" or "column" which we want to extract
--     "index"  INTEGER NOT NULL,  -- the row or column index to extract
--     result   TEXT               -- json array of integers containing the row or column at the specified index
-- );
--
-- Task: update the matrix table and set the result based on the property, string and index.
ALTER TABLE matrix ADD COLUMN jsoned;

UPDATE matrix set jsoned = (
  SELECT json_group_array(value)
  FROM json_each(replace(('[[' || replace(string, char(10), '],[') || ']]'), ' ', ','))
);

UPDATE matrix set result =(
  SELECT json_extract(jsoned, '$[' || ("index" - 1) || ']')
)
WHERE property = 'row';

UPDATE matrix set result =(
  WITH RECURSIVE series(r, v) AS (
    SELECT 1 , (SELECT json_extract(jsoned, '$[0][' || ("index" - 1) || ']'))
    UNION ALL
    SELECT r + 1, (SELECT json_extract(jsoned, '$[' || r || '][' || ("index" - 1) || ']')) FROM series WHERE r < (json_array_length(jsoned))
  )
  SELECT json_group_array(v) FROM series
)
WHERE property = 'column';