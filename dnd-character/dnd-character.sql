-- Schema:
-- CREATE TABLE "dnd-character" (
--   property     TEXT    NOT NULL,
--   input        TEXT    NOT NULL,
--   strength     INTEGER         ,
--   dexterity    INTEGER         ,
--   constitution INTEGER         ,
--   intelligence INTEGER         ,
--   wisdom       INTEGER         ,
--   charisma     INTEGER         ,
--   modifier     INTEGER         ,
--   hitpoints    INTEGER
-- );
--
-- Task: update the dnd-character table and set the appropriate columns based on the property and the input.

UPDATE "dnd-character" SET   
  strength = abs(random() % 15) +3,
  dexterity = abs(random() % 15) +3,
  constitution = abs(random() % 15) +3,
  intelligence = abs(random() % 15) +3,
  wisdom = abs(random() % 15) +3,
  charisma = abs(random() % 15) +3
 WHERE property != 'modifier' AND input = 'random';

UPDATE "dnd-character"
SET 
  strength = subq.strength,
  dexterity = subq.dexterity,
  constitution = subq.constitution,
  intelligence = subq.intelligence,
  wisdom = subq.wisdom,
  charisma = subq.charisma
FROM (
  SELECT strength, dexterity, constitution, intelligence, wisdom, charisma
  FROM "dnd-character"
  WHERE property = 'character' AND input = 'random'
) AS subq
WHERE property = 'character' AND input != 'random';

UPDATE "dnd-character" SET modifier = FLOOR((constitution - 10.0) / 2.0);

UPDATE "dnd-character" SET hitpoints = modifier + 10;