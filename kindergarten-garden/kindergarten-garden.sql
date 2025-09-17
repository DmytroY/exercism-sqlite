-- Schema: CREATE TABLE "kindergarten-garden" ("diagram" TEXT, "student" TEXT, "result" TEXT);
-- Task: update the kindergarten-garden table and set the result based on the diagram and student fields.

CREATE TEMP TABLE plants (code TEXT, p_name TEXT);
INSERT INTO plants VALUES
  ('G', 'grass'),
  ('C', 'clover'),
  ('R', 'radishes'),
  ('V', 'violets');

CREATE TEMP TABLE kids (name TEXT, position INTEGER);
INSERT INTO kids VALUES
  ('Alice', 1),
  ('Bob', 3),
  ('Charlie', 5),
  ('David', 7),
  ('Eve', 9),
  ('Fred', 11),
  ('Ginny', 13),
  ('Harriet', 15),
  ('Ileana', 17),
  ('Joseph', 19),
  ('Kincaid', 21),
  ('Larry', 23);

  ALTER TABLE "kindergarten-garden" ADD COLUMN code TEXT;

  UPDATE "kindergarten-garden" SET code =(
    (SELECT substr(diagram, (SELECT position FROM kids WHERE kids.name = "kindergarten-garden".student), 2))
    ||
    (SELECT substr(diagram, (SELECT position FROM kids WHERE kids.name = "kindergarten-garden".student) + (length("kindergarten-garden".diagram)+1)/2, 2))
  );

  UPDATE "kindergarten-garden" SET result =(
    WITH RECURSIVE series(n, plant) AS(

      SELECT 1, (SELECT p_name FROM plants WHERE plants.code = substr("kindergarten-garden".code, 1, 1))
      UNION ALL
      SELECT n + 1, (SELECT p_name FROM plants WHERE plants.code = substr("kindergarten-garden".code, n + 1, 1)) FROM series WHERE n < 4
    )
    SELECT GROUP_CONCAT(plant) FROM series
  );