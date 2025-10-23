-- Schema:
-- CREATE TABLE "line-up" (
--   name   TEXT    NOT NULL,
--   number INTEGER NOT NULL,
--   result TEXT
-- );
--
-- Task: Update the line-up table and set the result column based on the name and the number.

CREATE TEMP TABLE "endings" (n INTEGER, ending TEXT);
INSERT INTO endings VALUES
    (0, 'th'),
    (1, 'st'),
    (2, 'nd'),
    (3, 'rd'),
    (4, 'th'),
    (5, 'th'),
    (6, 'th'),
    (7, 'th'),
    (8, 'th'),
    (9, 'th');

UPDATE "line-up" SET result =(
    IIF(number % 100 >= 11 AND number % 100 <=13,
        name || ', you are the ' || number || 'th customer we serve today. Thank you!',
        name || ', you are the ' || number || (SELECT ending FROM endings WHERE number % 10 = endings.n) ||' customer we serve today. Thank you!')
);