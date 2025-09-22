-- Schema:
-- CREATE TABLE "square-root" (
--     radicand INTEGER NOT NULL,
--     result   INTEGER
-- );
--
-- Task: update the square-root table and set the result based on the radicand.
UPDATE "square-root" SET result = (
  WITH RECURSIVE series(n, candidat) AS(
    SELECT 1, pow(length(CAST(radicand AS TEXT)), 3)
    UNION ALL
    SELECT n+1, (candidat+radicand/candidat)/2 FROM series WHERE  ABS(candidat*candidat - radicand) > 0.1
  )
  SELECT CAST(candidat AS INTEGER) FROM series ORDER BY n DESC LIMIT 1
);