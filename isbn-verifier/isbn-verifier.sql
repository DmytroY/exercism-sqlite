-- Schema: CREATE TABLE "isbn-verifier" (isbn TEXT NOT NULL, result BOOL);
-- Task: update the isbn-verifier table and set the result based on the isbn.

ALTER TABLE "isbn-verifier" ADD COLUMN "n-isbn" TEXT;
UPDATE "isbn-verifier" SET "n-isbn" = replace(isbn, '-', '');
UPDATE "isbn-verifier" SET result = 0 WHERE length("n-isbn") != 10;

UPDATE "isbn-verifier"
    SET "n-isbn" = replace("n-isbn", 'X', '10')
    WHERE substr("n-isbn", 10, 1) == 'X' AND result IS NOT '0';
UPDATE "isbn-verifier" SET result = 0 WHERE "n-isbn" GLOB '*[A-Z]*';
update "isbn-verifier" SET result = (
    (substr("n-isbn",1,1) * 10 +
        substr("n-isbn",2,1) * 9 +
        substr("n-isbn",3,1) * 8 +
        substr("n-isbn",4,1) * 7 +
        substr("n-isbn",5,1) * 6 +
        substr("n-isbn",6,1) * 5 +
        substr("n-isbn",7,1) * 4 +
        substr("n-isbn",8,1) * 3 +
        substr("n-isbn",9,1) * 2 +
        substr("n-isbn",10)) % 11 == 0)
    WHERE result IS NULL;

    SELECT * FROM "isbn-verifier";