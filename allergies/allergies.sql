-- Schema: CREATE TABLE "allergies" ("task" TEXT, "item" TEXT, "score" INT NOT NULL, "result" TEXT);
-- Task: update the bob allergies and set the result based on the task.
--       - The `allergicTo` task expects `true` or `false` based on the `score` and the `item` fields.
--       - For the `list` task you have to write corresponding items to the result field

CREATE TEMP TABLE allergens ("name" TEXT, id INTEGER);
INSERT INTO allergens VALUES 
    ('eggs', 1),    -- b 0000 0001
    ('peanuts', 2), -- b 0000 0010
    ('shellfish', 4),   -- b 0000 0100
    ('strawberries', 8), -- b 0000 1000
    ('tomatoes', 16),   --b 0001 0000
    ('chocolate', 32),  --b 0010 0000
    ('pollen', 64), --b 0100 0000
    ('cats', 128);  --b 1000 0000

UPDATE allergies SET result = (
     CASE task
        WHEN 'allergicTo' THEN
            IIF((SELECT id FROM allergens WHERE allergens.name = allergies.item) & allergies.score, 'true', 'false')
        WHEN 'list' THEN
           (SELECT COALESCE(GROUP_CONCAT("name", ', '), '') FROM allergens WHERE allergies.score & allergens.id)
    END
);
   