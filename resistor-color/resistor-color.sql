-- CREATE TABLE "color_code" ("color" TEXT, "result" INT);
-- Task: update the color_code table and set the result based on the color.

CREATE TEMP TABLE "colors" ("color" TEXT, "digit" INT);
INSERT INTO "colors"(color, digit) VALUES
    ('black', 0),
    ('brown', 1),
    ('red', 2),
    ('orange', 3),
    ('yellow', 4),
    ('green', 5),
    ('blue', 6),
    ('violet', 7),
    ('grey', 8),
    ('white', 9);

UPDATE "color_code" SET result = (
    SELECT digit FROM colors WHERE "color_code".color = colors.color
);