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
    WHEN "date_description" = 'NOW' THEN strftime('%Y-%m-%dT%H:%M:%S',meeting_start, '+2 hours')
  END
);