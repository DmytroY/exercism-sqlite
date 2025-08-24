-- Schema: CREATE TABLE "bob" ("input" TEXT, "reply" TEXT);
-- Task: update the bob table and set the reply based on the input.

UPDATE bob SET reply =(
    CASE
        WHEN substr(trim(input), -1, 1) != '?' AND UPPER(input) = input AND LOWER(input) != input THEN 'Whoa, chill out!' 
        WHEN substr(trim(input), -1, 1) = '?' AND UPPER(input) = input AND LOWER(input) != input THEN 'Calm down, I know what I''m doing!'
        WHEN substr(trim(input), -1, 1) = '?' THEN 'Sure.'
        WHEN length(trim(input, ' ' || CHAR(9) || CHAR(10) || CHAR(13))) = 0 THEN 'Fine. Be that way!'
        ELSE 'Whatever.'
    END
);