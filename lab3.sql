-- queries written by Tushardeep Singh
-- DBS 311
-- SENECA COLLEGE
-- LAB 3

-- Question 1 : Write a SQL query to display the last name and hire date of all employees who were hired before the employee with ID 107 got hired 
--              but after March 2016. Sort the result by the hire date and then employee ID.

-- Solution 1 :
    SELECT last_name AS "last name", TO_CHAR(hire_date, 'fmdd-MON-yy') AS "hire date"
    FROM employees
    WHERE hire_date <
                        (SELECT TO_CHAR(hire_date, 'fmdd-MON-yy')
                        FROM employees
                        WHERE employee_id = 107)
    AND hire_date > TO_DATE('30-03-2016', 'dd-mm-yyyy')
    ORDER BY hire_date, employee_id;
    
-- Question 2 : Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort the result by customer ID.

-- Solution 2 :
    SELECT name AS "customer name", credit_limit AS "credit limit"
    FROM customers
    WHERE credit_limit = 
                            (SELECT MIN(credit_limit)
                            FROM customers)
    ORDER BY customer_id;
    
-- Question 3 : Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) in each category.  
--              Sort by category ID and the product ID. 

-- Solution 3 :
    SELECT product_id, product_name, (list_price), category_id
    FROM products
        WHERE category_id = ANY
                            (SELECT category_id
                            FROM products)
    AND list_price = ANY
                        (SELECT MAX(list_price)
                        FROM products
                        GROUP BY category_id)
    ORDER BY category_id, product_id;
    
    
-- Question 4 : Write a SQL query to display the category ID and the category name of the most expensive (highest list price) product(s).

-- Solution 4 : 
    SELECT pc.category_id, pc.category_name
    FROM product_categories pc
    LEFT JOIN products p
    ON pc.category_id = p.category_id
    WHERE list_price = 
                            (SELECT MAX(list_price)
                            FROM products);
                            
-- Question 5 : Write a SQL query to display product name and list price for products in category 1 which have the list price less than the 
--              lowest list price in ANY category.  Sort the output by top list prices first and then by the product ID.

-- Solution 5 :
    SELECT product_name, list_price
    FROM products
    WHERE category_id = 1
    AND list_price < ANY
                        (SELECT MIN(list_price)
                        FROM products
                        GROUP BY category_id)
    ORDER BY list_price DESC, product_id;
    
-- Question 6 : Display the maximum price (list price) of the category(s) that has the lowest price product.

-- Solution 6 :
    SELECT MAX(list_price)
    FROM products
    WHERE category_id = ANY
                            (SELECT category_id
                            FROM products);