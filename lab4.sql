-- queries written by Tushardeep Singh
-- LAB 4
-- SENECA COLLEGE
-- DBS 311

-- Question 1 : Display cities that no warehouse is located in them. (use set operators to answer this question)

-- Solution 1 :
    SELECT city
    FROM locations
    WHERE location_id IN
                        (SELECT location_id
                        FROM locations
                        MINUS
                        SELECT location_id
                        FROM warehouses)
    ORDER BY city;
    
-- Question 2 : Display the category ID, category name, and the number of products in category 1, 2, and 5.
--              In your result, display first the number of products in category 5, then category 1 and then 2.

-- Solution 2 :
    SELECT pc.category_id, pc.category_name, COUNT(p.category_id)
    FROM product_categories pc
    JOIN products p
    ON pc.category_id = p.category_id
    WHERE p.category_id IN(5)
    GROUP BY pc.category_id, pc.category_name
    UNION ALL
        SELECT pc.category_id, pc.category_name, COUNT(p.category_id)
    FROM product_categories pc
    JOIN products p
    ON pc.category_id = p.category_id
    WHERE p.category_id IN(1)
    GROUP BY pc.category_id, pc.category_name
    UNION ALL
        SELECT pc.category_id, pc.category_name, COUNT(p.category_id)
    FROM product_categories pc
    JOIN products p
    ON pc.category_id = p.category_id
    WHERE p.category_id IN(2)
    GROUP BY pc.category_id, pc.category_name;
    
-- Question 3 : Display product ID for products whose quantity in the inventory is less than to 5. (You are not allowed to use JOIN for this question.)

-- Solution 3 :    
    SELECT product_id
    FROM products
    INTERSECT
    SELECT product_id 
    FROM inventories
    WHERE quantity < 5;
    
-- Question 4 : We need a single report to display all warehouses and the state that they are located in and all states regardless of whether 
--              they have warehouses in them or not. (Use set operators in you answer.)
    
-- Solution 4 :  
    SELECT w.warehouse_name, l.state
    FROM warehouses w
    LEFT JOIN locations l
    ON w.location_id = l.location_id
    UNION
        SELECT w.warehouse_name, l.state
    FROM warehouses w
    RIGHT JOIN locations l
    ON w.location_id = l.location_id;
    
    
    
    