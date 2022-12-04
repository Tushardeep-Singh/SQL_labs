-- queries written by Tushardeep Singh
-- DBS 311
-- SENECA COLLEGE
-- LAB 5

-- Question 1 : Write a store procedure that get an integer number and prints
--              The number is even.
--              If a number is divisible by 2.
--              Otherwise, it prints 
--              The number is odd.

-- Solution 1 : 
    CREATE OR REPLACE PROCEDURE even_odd(number1 IN NUMBER) AS 
    BEGIN 
        IF(MOD(number1, 2) = 0)
        THEN 
            DBMS_OUTPUT.PUT_LINE('The number provided is even.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('The number provided is odd.');
    END IF;
    EXCEPTION
    WHEN OTHERS
    THEN 
        DBMS_OUTPUT.PUT_LINE('An error occured!');
    END;
        
-- Question 2 : Create a stored procedure named find_employee. This procedure gets an employee number 
--              and prints the following employee information:
--              First name 
--              Last name 
--              Email
--              Phone 
--              Hire date 
--              Job title
--              The procedure gets a value as the employee ID of type NUMBER.

--              See the following example for employee ID 107: 
--              First name: Summer
--              Last name: Payn
--              Email: summer.payne@example.com
--              Phone: 515.123.8181
--              Hire date: 07-JUN-16
--              Job title: Public Accountant
--              The procedure display a proper error message if any error accours.


    CREATE OR REPLACE PROCEDURE find_employee(employee_num IN NUMBER) AS 
    firstName VARCHAR2(255 BYTE);
    lastName VARCHAR2(255 BYTE);
    e_mail VARCHAR2(255 BYTE);
    phoneNo NUMBER;
    hireDate VARCHAR2(255 BYTE);
    jobTitle VARCHAR2(255 BYTE);
    BEGIN
        SELECT first_name, last_name, email, phone, hire_date, job_title INTO firstName, lastName, e_mail, phoneNo, hireDate, jobTitle
        FROM employees
        WHERE employee_id = employee_num;
        DBMS_OUTPUT.PUT_LINE('First name: ' || firstName);
        DBMS_OUTPUT.PUT_LINE('Last name: ' || lastName);
        DBMS_OUTPUT.PUT_LINE('Email: ' || e_mail);
        DBMS_OUTPUT.PUT_LINE('Phone: ' || phoneNo);
        DBMS_OUTPUT.PUT_LINE('Hire date: ' || hireDate);
        DBMS_OUTPUT.PUT_LINE('Job title: ' || jobTitle);
    EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
        DBMS_OUTPUT.PUT_LINE('The employee with id ' || employee_num || 'doesn''t exist');
    WHEN OTHERS 
    THEN
        DBMS_OUTPUT.PUT_LINE('An error has occured!!');
    END;
    
-- Question 3 : Every year, the company increases the price of all products in one category. For example, the 
--              company wants to increase the price (list_price) of products in category 1 by $5. Write a 
--              procedure named update_price_by_cat to update the price of all products in a given category 
--              and the given amount to be added to the current price if the price is greater than 0. The 
--              procedure shows the number of updated rows if the update is successful.
--              The procedure gets two parameters:
--              •	category_id IN NUMBER
--              •	amount NUMBER(9,2)
--              To define the type of variables that store values of a table’ column, you can also write:
--              vriable_name table_name.column_name%type;
--              The above statement defines a variable of the same type as the type of the table’ column.
--              category_id products.category_id%type;
--              Or you need to see the table definition to find the type of the category_id column. 
--              Make sure the type of your variable is compatible with the value that is stored in your variable.
--              To show the number of affected rows the update query, declare a variable named rows_updated of type NUMBER 
--              and use the SQL variable sql%rowcount to set your variable. Then, print its value in your stored procedure.
--              Rows_updated := sql%rowcount;
--              SQL%ROWCOUNT stores the number of rows affected by an INSERT, UPDATE, or DELETE.

-- Solution 3 :
    CREATE OR REPLACE PROCEDURE update_price_by_cat(categoryId products.category_id%type, increment products.list_price%type) AS
    rows_updated NUMBER;
    BEGIN
        UPDATE products
        SET list_price = list_price + increment
        WHERE category_id = categoryId
        AND list_price > 0;
        
        rows_updated := SQL%ROWCOUNT;
        
        IF(rows_updated = 0)
        THEN
            DBMS_OUTPUT.PUT_LINE('No row updated!');
        ELSIF(rows_updated = 1)
        THEN
            DBMS_OUTPUT.PUT_LINE('One row updated');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Number of rows updated : ' || rows_updated);
        END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        DBMS_OUTPUT.PUT_LINE('incorrect category id!');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('An error occured!!');
    END;
    

-- Question 4 : Every year, the company increase the price of products whose price is less than the average
-- price of all products by 1%. (list_price * 1.01). Write a stored procedure named 
-- update_price_under_avg. This procedure do not have any parameters. You need to find the 
-- average price of all products and store it into a variable of the same type. If the average price 
-- is less than or equal to $1000, update products’ price by 2% if the price of the product is less 
-- than the calculated average. If the average price is greater than $1000, update products’ price 
-- by 1% if the price of the product is less than the calculated average. The query displays an 
-- error message if any error occurs. Otherwise, it displays the number of updated rows.

-- Solution 4 :
    CREATE OR REPLACE PROCEDURE update_price_under_avg AS
    avg_price products.list_price%type;
    rows_updated NUMBER;
    BEGIN
        SELECT AVG(list_price) INTO avg_price
        FROM products;
        
        UPDATE products
        SET list_price = ( (list_price * 2/100) + list_price )
        WHERE avg_price <= 1000
        AND list_price < avg_price;
        
        rows_updated := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Number of products list price increased by 2% :- ' || rows_updated);
        rows_updated := 0;
        
        UPDATE products
        SET list_price = ( (list_price * 1/100) + list_price )
        WHERE avg_price >= 1000
        AND list_price < avg_price;
        
        rows_updated := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Number of products list price increased by 1% ' || rows_updated);
    EXCEPTION
    WHEN OTHERS
    THEN 
        DBMS_OUTPUT.PUT_LINE('An error occured!');
    END;
    
    
-- Question 5 : The company needs a report that shows three category of products based their prices. The 
--              company needs to know if the product price is cheap, fair, or expensive. Let’s assume that
--              If the list price is less than 
--                  (avg_price - min_price) / 2
--              The product’s price is cheap.

--              If the list price is greater than 
--                  (max_price - avg_price) / 2
--              The product’ price is expensive.

--              If the list price is between 
--                  (avg_price - min_price) / 2
--                  and
--                  (max_price - avg_price) / 2
--                  the end values included
--              The product’s price is fair.
--              Write a procedure named product_price_report to show the number of products in each price category:

--              The following is a sample output of the procedure if no error occurs:
--              Cheap: 10
--              Fair: 50
--              Expensive: 18  
--              The values in the above examples are just random values and may not match the real numbers in your result.
--              The procedure has no parameter. First, you need to find the average, minimum, and 
--              maximum prices (list_price) in your database and store them into varibles avg_price, 
--              min_price, and max_price.
--              You need more three varaibles to store the number of products in each price category:
--              cheap_count
--              fair_count
--              exp_count
--              Make sure you choose a proper type for each variable. You may need to define more variables based on your solution.

-- Solution 5 :
    CREATE OR REPLACE PROCEDURE product_price_report AS
    avg_price products.list_price%type;
    min_price products.list_price%type;
    max_price products.list_price%type;
    cheap_count NUMBER;
    fair_count NUMBER;
    exp_count NUMBER;
    BEGIN
    SELECT AVG(list_price), MIN(list_price), MAX(list_price) INTO avg_price, min_price, max_price
    FROM products;
    
    SELECT COUNT(*) INTO cheap_count
    FROM products
    WHERE list_price < (avg_price - min_price) / 2;
    
    SELECT COUNT(*) INTO fair_count
    FROM products
    WHERE list_price BETWEEN  ((avg_price - min_price) / 2) AND ((max_price - avg_price) / 2);
    
    SELECT COUNT(*) INTO exp_count
    FROM products
    WHERE list_price > (max_price - avg_price) / 2;
    
    DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);
    
    EXCEPTION
    WHEN OTHERS
    THEN 
        DBMS_OUTPUT.PUT_LINE('An error occuured!!');
    END;
    