-- Queries written by Tushardeep Singh
-- Course name : DBS 311
-- LAB 1 
-- SENECA COLLEGE

-- Q1: Write a query to display the tomorrow’s date in the following format: January 10th of year 2019
-- the result will depend on the day when you RUN/EXECUTE this query.  Label the column “Tomorrow”.

-- Solution 1 :
    SELECT TO_CHAR(SYSDATE, 'Month') || TO_CHAR(SYSDATE + 1, 'DD') || 'th of year ' || TO_CHAR(SYSDATE, 'YYYY')
    FROM DUAL;

-- Q2: For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. 
-- Display a new list price as a whole number.

-- Solution 2 :
    SELECT category_id AS "product ID", product_name AS "product name", list_price AS "list price", list_price + ((list_price * 2) / 100) AS "new list price"
    FROM products;
    
-- Q3 : For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format:
-- SUMMER, PAYNE is Public Accountant.

-- Solution 3 :
    SELECT first_name || ', ' || last_name || ' is ' || job_title || '.' AS "Employee info." 
    FROM employees;
    
-- Q4 : For each employee hired before October 2016, display the employee’s last name, hire date and calculate the number of YEARS between TODAY and 
-- the date the employee was hired.
-- •	Label the column Years worked. 
-- •	Order your results by the number of years employed.  Round the number of years employed up to the closest whole number.

-- Solution 4 :
    SELECT last_name AS "last name", hire_date AS "hire date", EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) AS "Years worked"
    FROM employees
    WHERE hire_date < TO_DATE('1-10-2016', 'DD-MM-YYYY')
    ORDER BY "Years worked";

-- Q5 : Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired 
-- after 2016.  
-- •	Label the column REVIEW DAY. 
-- •	Format the dates to appear in the format like:
--    TUESDAY, August the Thirty-First of year 2016
-- •	Sort by review date

-- Solution 5 :
    SELECT last_name AS "last name", TO_CHAR(NEXT_DAY(hire_date+365, 'TUESDAY'), 'DAY ", " month " the" ddSp " of year " YYYY') AS "REVIEW DAY"
    FROM employees_a;
    
-- Q6: For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column, display “unknown”.

-- Solution 6 :
    SELECT w.warehouse_id AS "warehouse id", w.warehouse_name AS "warehouse name", l.city,  NVL(l.state,'unknown') AS "state"
    FROM warehouses w
    INNER JOIN locations l
    ON w.location_id = l.location_id;