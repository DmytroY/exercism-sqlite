-- Schema:
-- CREATE TABLE triangle (
--     property TEXT    NOT NULL,
--     side_a   REAL    NOT NULL,
--     side_b   REAL    NOT NULL,
--     side_c   REAL    NOT NULL,
--     result   BOOLEAN
-- );
--
-- Task: update the triangle and set result based on the property, side_a, side_b and side_c columns.

UPDATE triangle SET result = (
    CASE 
        WHEN side_a = 0 OR side_b = 0 OR side_c = 0 THEN 0
        WHEN max(side_a,  side_b, side_c) > (side_a + side_b + side_c) / 2 THEN 0
        WHEN property = 'equilateral' AND side_a = side_b AND side_a = side_c AND side_b = side_c THEN 1
        WHEN property = 'isosceles' AND (side_a == side_b OR side_a == side_c OR side_b == side_c) THEN 1
        WHEN property = 'scalene' AND side_a != side_b AND side_a != side_c AND side_b != side_c THEN 1
        ELSE 0
    END
);
