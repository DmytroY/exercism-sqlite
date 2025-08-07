DROP TABLE IF EXISTS "sales";
CREATE TABLE IF NOT EXISTS "sales" ("name" TEXT, "amt" INTEGER);
INSERT INTO "sales" ("name", "amt") VALUES ('Cat', 220);
INSERT INTO "sales" ("name", "amt") VALUES ('Cat', 220);
INSERT INTO "sales" ("name", "amt") VALUES ('Alex', 120);
INSERT INTO "sales" ("name", "amt") VALUES ('Alex', 140);
INSERT INTO "sales" ("name", "amt") VALUES ('Alex', 160);
INSERT INTO "sales" ("name", "amt") VALUES ('Bob', 190);
INSERT INTO "sales" ("name", "amt") VALUES ('Bob', 200);
INSERT INTO "sales" ("name", "amt") VALUES ('Bob', 210);
-- SELECT * FROM "sales";

-- salespeople whose sales are above that average
WITH cte_sales_summary AS
    (
    SELECT name, sum("amt") AS "result"
    FROM "sales"
    GROUP BY "name"
    ORDER BY "result" DESC
    )
SELECT name, result FROM  cte_sales_summary
WHERE result > (SELECT avg(result) FROM cte_sales_summary);