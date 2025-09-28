-- Schema:
-- CREATE TABLE "queen-attack" (
--   white_row INTEGER NOT NULL,
--   white_col INTEGER NOT NULL,
--   black_row INTEGER NOT NULL,
--   black_col INTEGER NOT NULL,
--   result    BOOLEAN         ,
--   error     TEXT
-- );
--
-- Task: update the "queen-attack" table and set the result or the error columns based on the white and black queens positions.

UPDATE "queen-attack" SET error = (
    CASE
        WHEN white_row < 0 OR black_row < 0 THEN 'row not positive'
        WHEN white_row > 7 OR black_row > 7 THEN 'row not on board'
        WHEN white_col < 0 OR black_col < 0 THEN 'column not positive'
        WHEN white_col > 7 OR black_col > 7 THEN 'column not on board'
        ELSE NULL
    END
);

UPDATE "queen-attack" SET result = (
    CASE
        WHEN error IS NOT NULL
            THEN NULL
        WHEN white_row = black_row OR
            white_col = black_col OR
            ABS(white_row - black_row) = ABS(white_col - black_col)
            THEN 1
        ELSE 0
    END
);


