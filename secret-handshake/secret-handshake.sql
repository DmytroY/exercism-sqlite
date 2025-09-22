-- Schema:
-- CREATE TABLE "secret-handshake" (
--     number INTEGER NOT NULL,
--     result TEXT
-- );
--
-- Task: update secret-handshake table and set result column based on the number.
UPDATE "secret-handshake" SET result = rtrim(
  IIF(number & 16, 
    -- REVERSE'
    (
      IIF(number & 8, 'jump, ', '') ||
      IIF(number & 4, 'close your eyes, ', '') ||
      IIF(number & 2, 'double blink, ', '') ||
      IIF(number & 1, 'wink', '')
      -- jump, close your eyes, double blink, wink
    ), 
    -- DIRECT
    (
      IIF(number & 1, 'wink, ', '') ||
      IIF(number & 2, 'double blink, ', '') ||
      IIF(number & 4, 'close your eyes, ', '') ||
      IIF(number & 8, 'jump', '')
    )
  ),
  ', '
);