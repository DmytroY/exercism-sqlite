-- Schema:
-- CREATE TABLE "bottle-song" (
--         start_bottles INTEGER NOT NULL,
--         take_down     INTEGER NOT NULL,
--         result        TEXT
-- );
-- Task: update bottle-song table and set the result based on the
-- start_bottles and take_down.

CREATE TABLE digits ( id INTEGER, "name" TEXT);
INSERT INTO digits (id, "name") VALUES
    (0, 'Zero'),
    (1, 'One'),
    (2, 'Two'),
    (3, 'Three'),
    (4, 'Four'),
    (5, 'Five'),
    (6, 'Six'),
    (7, 'Seven'),
    (8, 'Eight'),
    (9, 'Nine'),
    (10, 'Ten');

UPDATE "bottle-song"
SET result = (
    WITH RECURSIVE song(n) AS (
        SELECT start_bottles
        UNION ALL
        SELECT n - 1 FROM song WHERE n > (start_bottles - take_down + 1)
    )
SELECT group_concat( 
CASE 
WHEN n > 2 THEN            
(SELECT "name" FROM digits WHERE id == n) || ' green bottles hanging on the wall,' || char(10) ||
(SELECT "name" FROM digits WHERE id == n) || ' green bottles hanging on the wall,' || char(10) ||
'And if one green bottle should accidentally fall,' || char(10) ||
'There''ll be ' || LOWER((SELECT "name" FROM digits WHERE id == (n - 1))) ||' green bottles hanging on the wall.'

WHEN n = 2 THEN
'Two green bottles hanging on the wall,
Two green bottles hanging on the wall,
And if one green bottle should accidentally fall,
There''ll be one green bottle hanging on the wall.'

WHEN n = 1 THEN
'One green bottle hanging on the wall,
One green bottle hanging on the wall,
And if one green bottle should accidentally fall,
There''ll be no green bottles hanging on the wall.'
END   
, char(10) || char(10))
             
FROM song
);
