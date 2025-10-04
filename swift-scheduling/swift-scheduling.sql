-- Schema:
-- CREATE TABLE "swift-scheduling" (
--     meeting_start    TEXT NOT NULL, -- datetime YYYY-MM-DDTHH:mm:ss
--     date_description TEXT NOT NULL,
--     result           TEXT           -- datetime YYYY-MM-DDTHH:mm:ss
-- );
--
-- Task: update swift-scheduling table and set the result based on the meeting_start and description.

UPDATE "swift-scheduling" SET result = (
  CASE
    WHEN "date_description" = 'NOW' THEN strftime('%Y-%m-%dT%H:%M:%S', meeting_start, '+2 hours')
    WHEN "date_description" = 'ASAP' AND CAST(strftime('%H',  "meeting_start") AS INTEGER) < 13 THEN date(meeting_start) || 'T17:00:00'
    WHEN "date_description" = 'ASAP' AND CAST(strftime('%H',  "meeting_start") AS INTEGER) >= 13 THEN date(meeting_start, '+1 days') || 'T13:00:00'
    WHEN "date_description" = 'EOW' AND CAST(strftime('%w', "meeting_start") AS INTEGER) < 4 THEN date(meeting_start, 'weekday 5') || 'T17:00:00'
    WHEN "date_description" = 'EOW' AND CAST(strftime('%w', "meeting_start") AS INTEGER) >= 4 THEN date(meeting_start, 'weekday 0') || 'T20:00:00'

    WHEN substr("date_description", -1, 1) = 'M' AND CAST(strftime('%m',  "meeting_start") AS INTEGER) < CAST(replace("date_description",'M', '') AS INTEGER)
      THEN
        -- '8:00 on the first day of N-th month' 
        date(meeting_start, 'start of year', 
            replace("date_description",'M', '') || ' months', '-1 months'
            ) || 'T08:00:00'

    WHEN substr("date_description", -1, 1) = 'M' AND CAST(strftime('%m',  "meeting_start") AS INTEGER) >= CAST(replace("date_description",'M', '') AS INTEGER)
      THEN 
      -- '8:00 on the first day of next year''s N-th month' 
        date(meeting_start, 'start of year', '+1 years',
            replace("date_description",'M', '') || ' months', '-1 months'
            ) || 'T08:00:00'

    WHEN substr("date_description", 1, 1) = 'Q' 
          AND
        ((CAST(strftime('%m',  "meeting_start") AS INTEGER) - 1) / 3 + 1) <= CAST(replace("date_description",'Q', '') AS INTEGER)
      THEN 
      -- '8:00 last day this years N-th quarter'
        date(meeting_start, 'start of year', (CAST(replace("date_description",'Q', '') AS INTEGER) * 3) || ' months', '-1 days'
            ) || 'T08:00:00'

    WHEN substr("date_description", 1, 1) = 'Q' 
          AND
        ((CAST(strftime('%m',  "meeting_start") AS INTEGER) - 1) / 3 + 1) > CAST(replace("date_description",'Q', '') AS INTEGER)
      THEN 
      -- '8:00 last day next years N-th quarter'
        date(meeting_start, 'start of year', '+1 years', (CAST(replace("date_description",'Q', '') AS INTEGER) * 3) || ' months', '-1 days'
            ) || 'T08:00:00'
    END
);

  -- it is not final result. Should be checke for workday for 'M' and 'Q' cases
  
UPDATE "swift-scheduling" SET result = (
    CASE strftime('%w', result)
      WHEN '0' -- Sunday
        THEN date(result, '+1 days') || 'T08:00:00'
      WHEN '6' -- Saturday
        THEN date(result, '+2 days') || 'T08:00:00'
      ELSE result
    END
  ) WHERE substr("date_description", -1, 1) = 'M';

UPDATE "swift-scheduling" SET result = (
    CASE strftime('%w', result)
      WHEN '0' -- Sunday
        THEN date(result, '-2 days') || 'T08:00:00'
      WHEN '6' -- Saturday
        THEN date(result, '-1 days') || 'T08:00:00'
      ELSE result
    END
  ) WHERE substr("date_description", 1, 1) = 'Q';