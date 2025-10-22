-- Schema: CREATE TABLE "atbash-cipher" (
--           property TEXT NOT NULL,
--           phrase   TEXT NOT NULL,
--           result   TEXT
--         );
-- Task: update the atbash-cipher table and set the result based on
--       property and phrase

-- universal approach fits not only atbash but any substitution cipher
CREATE TEMP TABLE keys (inc TEXT, outc text);
INSERT INTO keys VALUES
    ('a', 'z'),
    ('b', 'y'),
    ('c', 'x'),
    ('d', 'w'),
    ('e', 'v'),
    ('f', 'u'),
    ('g', 't'),
    ('h', 's'),
    ('i', 'r'),
    ('j', 'q'),
    ('k', 'p'),
    ('l', 'o'),
    ('m', 'n'),
    ('n', 'm'),
    ('o', 'l'),
    ('p', 'k'),
    ('q', 'j'),
    ('r', 'i'),
    ('s', 'h'),
    ('t', 'g'),
    ('u', 'f'),
    ('v', 'e'),
    ('w', 'd'),
    ('x', 'c'),
    ('y', 'b'),
    ('z', 'a'),
    ('1', '1'),
    ('2', '2'),
    ('3', '3'),
    ('4', '4'),
    ('5', '5'),
    ('6', '6'),
    ('7', '7'),
    ('8', '8'),
    ('9', '9'),
    ('0', '0');

-- encode/decode
UPDATE "atbash-cipher" SET result = (
    WITH series(i, c) AS(
        SELECT 1, (SELECT outc FROM keys WHERE keys.inc = lower(substring(phrase, 1, 1)))
        UNION ALL
        SELECT i + 1,
                (SELECT outc FROM keys WHERE keys.inc = lower(substring(phrase, i + 1, 1)))
        FROM series WHERE i < length(phrase)
    ) SELECT group_concat(c, '') FROM series
);

-- past spaces into encoded phrase. As separate query - easy to disable in case it is not required
UPDATE "atbash-cipher" SET result = (
    WITH series(i, c) AS(
        SELECT 1 , substring(result, 1, 1)
        UNION ALL
        SELECT i + 1, substring(result, i + 1, 1) || IIF( (i+1) % 5 = 0, ' ', '') FROM series WHERE i < length(result)
    ) SELECT trim(group_concat(c, '')) FROM series
) WHERE property = 'encode';
