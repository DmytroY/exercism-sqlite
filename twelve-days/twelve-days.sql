-- Schema:
-- CREATE TABLE "twelve-days" (
--     start_verse INTEGER NOT NULL,
--     end_verse   INTEGER NOT NULL,
--     result      TEXT
-- );
--
-- Task: update the twelve-days table and set result bases on the start_verse and end_verse.

CREATE TEMP TABLE chunks (id INTEGER, numeral TEXT, chunk TEXT);
INSERT INTO chunks(id, numeral, chunk) VALUES
  (12, 'twelfth', ' twelve Drummers Drumming,'),
  (11, 'eleventh', ' eleven Pipers Piping,'),
  (10, 'tenth', ' ten Lords-a-Leaping,'),
  (9, 'ninth', ' nine Ladies Dancing,'),
  (8, 'eighth', ' eight Maids-a-Milking,'),
  (7, 'seventh', ' seven Swans-a-Swimming,'),
  (6, 'sixth', ' six Geese-a-Laying,'),
  (5, 'fifth', ' five Gold Rings,'),
  (4, 'fourth', ' four Calling Birds,'),
  (3, 'third', ' three French Hens,'),
  (2, 'second', ' two Turtle Doves,'),
  (1, 'first', ' a Partridge in a Pear Tree.');

CREATE TEMP TABLE verses (id INTEGER, verse TEXT);
-- fill verses with ID from 1 to 12
INSERT INTO verses(id)
  WITH series(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM series WHERE n + 1 <= 12
  ) SELECT n FROM series;

-- create respective verse in temp table  
UPDATE verses SET verse = (
  CASE verses.id
    WHEN 1 THEN 'On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree.'
    ELSE(
      WITH series(n, chnk) AS (
          SELECT id, (SELECT chunk FROM chunks WHERE chunks.id = verses.id)
          UNION ALL
          SELECT n - 1, (SELECT chunk FROM chunks WHERE chunks.id = n - 1) FROM series WHERE n - 1 > 1 
        ) SELECT 'On the ' || (SELECT numeral FROM chunks WHERE chunks.id = verses.id) || ' day of Christmas my true love gave to me:' ||GROUP_CONCAT(chnk, '') || ' and a Partridge in a Pear Tree.'
            FROM series
    )
  END
);

UPDATE "twelve-days" SET result =(
  WITH series (n, t) AS (
    SELECT start_verse, (SELECT verse FROM verses WHERE verses.id = start_verse)
    UNION ALL
    SELECT n + 1, (SELECT verse FROM verses WHERE verses.id = n + 1) FROM series WHERE n + 1 <= end_verse
  ) SELECT GROUP_CONCAT(t, char(10)) FROM series
);