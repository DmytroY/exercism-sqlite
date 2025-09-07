-- Schema:
-- CREATE TABLE clock (
--   property TEXT NOT NULL,
--   input    TEXT NOT NULL,   -- json object
--   result   TEXT
-- );
--
-- Task: update the clock table and set the result column based on the input.

UPDATE clock
SET result = (
    SELECT strftime('%H:%M', '00:00',
        format('%d hours', input ->> '$.hour'),
        format('%d minutes', input ->> '$.minute' + COALESCE(input ->> '$.value', 0) * IIF(property = 'subtract', -1, 1))
    )
)
WHERE property != 'equal';

UPDATE clock
SET result = (
    IIF(
        ((input ->> '$.clock1.hour' - input ->> '$.clock2.hour') * 60 + (input ->> '$.clock1.minute' - input ->> '$.clock2.minute')) % 1440,
        0,
        1
    )
)
WHERE property = 'equal';