-- Schema:
-- CREATE TABLE house (
--     start_verse INTEGER NOT NULL,
--     end_verse   INTEGER NOT NULL,
--     result      TEXT
-- );
--
-- Task: update house table and set the result based on the start_verse and end_verse.

CREATE TEMP TABLE parts(id INTEGER, prefix TEXT, sentence TEXT);
INSERT INTO parts VALUES
(12, '', 'the horse and the hound and the horn'),
(11, 'that belonged to ', 'the farmer sowing his corn'),
(10, 'that kept ', 'the rooster that crowed in the morn'),
(9, 'that woke ', 'the priest all shaven and shorn'),
(8, 'that married ', 'the man all tattered and torn'),
(7, 'that kissed ', 'the maiden all forlorn'),
(6, 'that milked ', 'the cow with the crumpled horn'),
(5, 'that tossed ', 'the dog'),
(4, 'that worried ', 'the cat'),
(3, 'that killed ', 'the rat'),
(2, 'that ate ', 'the malt'),
(1, 'that lay in ', 'the house that Jack built.');

CREATE TEMP TABLE verses(id INTEGER, verse TEXT);
INSERT INTO verses(id) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);
UPDATE verses SET verse = (
  WITH RECURSIVE series(n, sub_verse) AS (
    SELECT verses.id, 'This is ' || (SELECT sentence FROM parts WHERE parts.id = verses.id)
    UNION ALL
    SELECT n - 1, (SELECT prefix FROM parts WHERE parts.id = n - 1) ||(SELECT sentence FROM parts WHERE parts.id = n - 1) from series WHERE n > 1
  )
  SELECT GROUP_CONCAT(sub_verse, ' ') FROM series
);

UPDATE house SET result = (
  WITH RECURSIVE series (n, ver) AS (
    SELECT house.start_verse, (SELECT verse FROM verses WHERE id = house.start_verse)
    UNION ALL
    SELECT n + 1, (SELECT verse FROM verses WHERE id = n + 1) FROM series WHERE n < house.end_verse
  )
  SELECT GROUP_CONCAT(ver, char(10)) FROM series
);