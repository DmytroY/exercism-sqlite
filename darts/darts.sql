-- Schema: CREATE TABLE "darts" ("x" REAL, "y" REAL, score INTEGER);
-- Task: update the darts table and set the score based on the x and y values.
UPDATE darts SET score = IIF(x*x + y*y <= 1, 10, 
                                IIF(x*x + y*y <= 25, 5, 
                                    IIF(x*x + y*y <= 100, 1, 0)))