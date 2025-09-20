-- Schema:
-- CREATE TABLE "perfect-numbers" (
--   number INTEGER NOT NULL,
--   result TEXT,
--   error  TEXT
-- );
--
-- Task: update the perfect-numbers table and set the result or the error columns based on number.
UPDATE "perfect-numbers"
SET error = 'Classification is only possible for positive integers.'
WHERE number < 1;

UPDATE "perfect-numbers" SET result = (
  WITH RECURSIVE divisors(n) AS (
    SELECT 2
    UNION ALL
    SELECT n + 1 FROM divisors WHERE n + 1 < sqrt(number)
  )
  SELECT
    CASE
      WHEN number < 6 THEN 'deficient'
      WHEN number < SUM(IIF(number%n, 0, n + number/n)) + 1 THEN 'abundant'
      WHEN number = SUM(IIF(number%n, 0, n + number/n)) + 1 THEN 'perfect'
      ELSE 'deficient'
    END
  FROM divisors
)
WHERE error IS NULL;