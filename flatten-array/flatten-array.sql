-- Schema:
-- CREATE TABLE "flatten-array" (
--   array  TEXT NOT NULL,    -- json array
--   result TEXT              -- json array
-- );

UPDATE "flatten-array"
SET result = (
  SELECT json_group_array(atom) FROM json_tree("flatten-array".array) WHERE atom IS NOT null
);