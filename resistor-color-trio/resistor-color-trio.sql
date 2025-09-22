-- Schema: CREATE TABLE IF NOT EXISTS color_code ( color1 TEXT, color2 TEXT, color3 TEXT, result TEXT );
-- Task: update the color_code table and set the result based on the colors.
CREATE TEMP TABLE "colors" ("color" TEXT, "digit" INT, "sufix");
INSERT INTO "colors"(color, digit, sufix) VALUES
    ('black', 0, ' ohms'),
    ('brown', 1, '0 ohms'),
    ('red', 2, '00 ohms'),
    ('orange', 3, ' kiloohms'),
    ('yellow', 4, '0 kiloohms'),
    ('green', 5, '00 kiloohms'),
    ('blue', 6, ' megaohms'),
    ('violet', 7, '0 megaohms'),
    ('grey', 8, '00 megaohms'),
    ('white', 9, ' gigaohms');

UPDATE "color_code"
SET result = (
  CAST(((SELECT digit FROM colors WHERE "color_code".color1 = colors.color)*10 +
        (SELECT digit FROM colors WHERE "color_code".color2 = colors.color)
        ) * pow(10, (SELECT digit FROM colors WHERE "color_code".color3 = colors.color)) AS INTEGER) ||
  ' ohms'  
);

UPDATE "color_code"
SET result =(
  replace(replace(replace(result, '000000000 ohms', ' gigaohms'), '000000 ohms', ' megaohms'), '000 ohms', ' kiloohms')
);