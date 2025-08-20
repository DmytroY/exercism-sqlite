-- Schema: CREATE TABLE "space-age" (
--             planet  TEXT    NOT NULL,
--             seconds INTEGER NOT NULL,
--             result  REAL
--         );
-- Task: update the space-age table and set the result based on planet
--       and seconds.

CREATE TEMP TABLE "planets" ("planet" TEXT, "period" REAL);
INSERT INTO "planets"("planet", "period") VALUES
('Mercury',	0.2408467),
('Venus',	0.61519726),
('Earth',	1.0),
('Mars',	1.8808158),
('Jupiter',	11.862615),
('Saturn',	29.447498),
('Uranus',	84.016846),
('Neptune',	164.79132);

UPDATE "space-age" SET result = (
    SELECT round(1.0 * "space-age"."seconds" / 31557600 /"planets"."period" , 2)
    FROM planets
    WHERE "space-age".planet = "planets".planet
);

