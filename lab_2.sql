-- Queries written by Tushardeep Singh
-- DBS311
-- SENECA COLLEGE
-- LAB 2

--Q1 : For each job title, display the number of employees. Sort the result according to the number of employees.
--Solution 1 :
    SELECT job_title, COUNT(employee_id)
    FROM employees
    GROUP BY job_title
    ORDER BY COUNT(employee_id);
    
--Q2 : Display the highest, lowest, and average customer credit limits. Name these results high, low, and average. 
--     Add a column that shows the difference between the highest and the lowest credit limits named “High and Low 
--     Difference”. Round the average to 2 decimal places.

--Solution 2 :
    SELECT MAX(credit_limit) AS "high", MIN(credit_limit) AS "low", ROUND(AVG(credit_limit),2) AS "average", MAX(credit_limit) - MIN(credit_limit)AS "High and Low Difference"
    FROM customers;

--Q3 : Display the order id, the total number of products, and the total order amount for orders with the total amount over $1,000,000. 
--Sort the result based on total amount from the high to low values.

--Solution 3 :
    
    -- below, both solutions will output the desired result 
    select order_id, sum(quantity), sum(quantity * unit_price)
    from order_items
    group by order_id
    HAVING sum(quantity * unit_price) > 1000000
    ORDER BY sum(quantity * unit_price) DESC;
    
    SELECT o.order_id, SUM(i.quantity) TOTAL_ITEMS, (SUM(i.quantity * i.unit_price)) TOTAL_AMOUNT
    FROM order_items i
    LEFT JOIN orders o
    ON i.order_id = o.order_id
    GROUP BY o.order_id
    HAVING (SUM(i.quantity * i.unit_price)) > 1000000
    ORDER BY (SUM(i.quantity * i.unit_price)) DESC;
    
--Q4 : Display the warehouse id, warehouse name, and the total number of products for each warehouse. Sort the result according to the warehouse ID.

--Solution 4 :
    SELECT w.warehouse_id, w.warehouse_name, SUM(i.quantity) AS TOTAL_PRODUCTS
    FROM warehouses w
    JOIN inventories i
    ON w.warehouse_id = i.warehouse_id
    GROUP BY w.warehouse_id, w.warehouse_name
    ORDER BY w.warehouse_id;
    
--Q5 : For each customer, display customer number, customer full name, and the total number of orders issued by the customer. 
--     If the customer does not have any orders, the result shows 0.
--     Display only customers whose customer name starts with ‘O’ and contains ‘e’.
--     Include also customers whose customer name ends with‘t’.
--     Show the customers with highest number of orders first.

--Solution 5 :
    SELECT c.customer_id AS "customer_number", c.name AS "fullname", COUNT(o.order_id)
    FROM customers c
    LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    WHERE c.name LIKE 'O%e%'
    OR c.name LIKE '%t'
    GROUP BY c.customer_id,c.name
    ORDER BY COUNT(o.order_id) DESC;
    
--Q6 : Write a SQL query to show the total and the average sale amount for each category. Round the average to 2 decimal places.
    
--Solution 6 : 
    
    SELECT p.category_id, SUM(oi.quantity * oi.unit_price) AS "TOTAL_AMOUNT", ROUND(AVG(oi.quantity * oi.unit_price),2) AS "AVERAGE_AMOUNT"
    FROM products p
    JOIN order_items oi
    ON p.product_id = oi.product_id
    GROUP BY p.category_id;