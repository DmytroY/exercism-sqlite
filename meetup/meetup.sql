-- Schema: CREATE TABLE "meetup" ( "year" INTEGER, "month" INTEGER, "week" TEXT, "dayofweek" TEXT, "result" TEXT);
-- Task: update the meetup table and set the result based on the other fields.
ALTER TABLE meetup ADD COLUMN first_day;
ALTER TABLE meetup ADD COLUMN modificator;

UPDATE meetup SET first_day =(
  CASE week
    WHEN 'first' THEN DATE(meetup."year" || '-' || format('%02d',meetup."month") || '-01')
    WHEN 'second' THEN DATE(meetup."year" || '-' || format('%02d',meetup."month") || '-01', '+7 days')
    WHEN 'third' THEN DATE(meetup."year" || '-' || format('%02d',meetup."month") || '-01', '+14 days')
    WHEN 'fourth' THEN DATE(meetup."year" || '-' || format('%02d',meetup."month") || '-01', '+21 days')
    WHEN 'last' THEN DATE(meetup."year" || '-' || format('%02d',meetup."month") || '-01','+1 months', '-7 days')
    ELSE DATE(meetup."year" || '-' || format('%02d',meetup."month") || '-13')
  END
);

UPDATE meetup SET modificator =(
  CASE dayofweek
    WHEN 'Monday' THEN 'weekday 1'
    WHEN 'Tuesday' THEN 'weekday 2'
    WHEN 'Wednesday' THEN 'weekday 3'
    WHEN 'Thursday' THEN 'weekday 4'
    WHEN 'Friday' THEN 'weekday 5'
    WHEN 'Saturday' THEN 'weekday 6'
    WHEN 'Sunday' THEN 'weekday 0'
    ELSE '---------'
  END
);

UPDATE meetup SET result = (
  DATE(first_day, modificator)
);