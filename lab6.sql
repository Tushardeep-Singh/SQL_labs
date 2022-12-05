-- Queries written by Tushardeep Singh
-- SENECA COLLEGE
-- DBS 311
-- LAB 6

-- Question 1 : Write a store procedure that gets an integer number n and calculates and displays its factorial.
--              Example:
--              0! = 1
--              2! = fact(2) = 2 * 1 = 1
--              3! = fact(3) = 3 * 2 * 1 = 6
--              . . .
--              n! = fact(n) = n * (n-1) * (n-2) * . . . * 1

-- Solution 1 :
    -- Finding factoral using LOOP statement :-
    SET SERVEROUTPUT ON;
    CREATE OR REPLACE PROCEDURE factoral(n IN NUMBER) AS
    result NUMBER := 1;
    i NUMBER := 0;
    BEGIN
        LOOP
            result := (result * (n - i));
            i := (i + 1);
            EXIT WHEN (i = n);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Factoral of ' || n || ' is : ' || result);
    EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('An error occured!');
    END;
    
    /* Test :- 
    BEGIN
        factoral(3);
    END;
    */
    
    /* FInding factoral using FOR LOOP :-
    
    SET SERVEROUTPUT ON;
    CREATE OR REPLACE PROCEDURE factoral(n IN NUMBER) AS
    result NUMBER := 1;
    BEGIN
        FOR i IN 0..(n-1) LOOP
        result := (result * (n - i));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(result);
    END;
    */
    
-- Question 2 : The company wants to calculate the employees’ annual salary:
--              The first year of employment, the amount of salary is the base salary which is $10,000.
--              Every year after that, the salary increases by 5%.
--              Write a stored procedure named calculate_salary which gets an employee ID and for that 
--              employee calculates the salary based on the number of years the employee has been working 
--              in the company.  (Use a loop construct to calculate the salary).
--              The procedure calculates and prints the salary.
--              Sample output:
--              First Name: first_name 
--              Last Name: last_name
--              Salary: $9999,99
--              If the employee does not exists, the procedure displays a proper message.

-- Solution 2 :
    SET SERVEROUTPUT ON;
    CREATE OR REPLACE PROCEDURE calculate_salary(employeeId IN employees_a.employee_id%type) AS
    firstName employees_a.first_name%type;
    lastName employees_a.last_name%type;
    years_employed NUMBER;  
    annual_salary NUMBER;
    BEGIN
        SELECT first_name, last_name, (EXTRACT(year FROM SYSDATE) - EXTRACT(year FROM hire_date)) INTO firstName, lastName, years_employed
        FROM employees_a
        WHERE employee_id = employeeId;
        
        FOR i IN 1..years_employed LOOP
            annual_salary := (10000 + (500 * i));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('First Name: ' || firstName);
        DBMS_OUTPUT.PUT_LINE('Last Name: ' || lastName);
        DBMS_OUTPUT.PUT_LINE('Salary: ' || annual_salary);
    EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        DBMS_OUTPUT.PUT_LINE('employee with id ' || employeeId || ' does not exist.');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('An error has occured!!');
    END;
    
    /* Test :
    BEGIN
        calculate_salary(101);
    END;
    */
    
-- Question 3 : Write a stored procedure named warehouses_report to print the warehouse ID, warehouse 
--              name, and the city where the warehouse is located in the following format for all warehouses:
--              Warehouse ID:
--              Warehouse name:
--              City:
--              State:

--          If the value of state does not exist (null), display “no state”.
--          The value of warehouse ID ranges from 1 to 9.
--          You can use a loop to find and display the information of each warehouse inside the loop.
--          (Use a loop construct to answer this question. Do not use cursors.) 

-- Solution 3 : 
    SET SERVEROUTPUT ON;
    CREATE OR REPLACE PROCEDURE warehouses_report AS
    w_Id NUMBER;
    w_Name warehouses.warehouse_name%type;
    w_city locations.city%type;
    w_state locations.state%type;
    BEGIN
        FOR i IN 1..9 LOOP
            SELECT w.warehouse_id, w.warehouse_name,NVL(l.city, 'no state'), l.state INTO w_Id, w_Name, w_city, w_state
            FROM warehouses w
            INNER JOIN locations l
            ON w.location_id = l.location_id
            AND warehouse_id = i;
            
            DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || w_Id);
            DBMS_OUTPUT.PUT_LINE('Warehouse name: ' || w_Name);
            DBMS_OUTPUT.PUT_LINE('City: ' || w_city);
            DBMS_OUTPUT.PUT_LINE('State: ' || w_state);
            DBMS_OUTPUT.PUT_LINE(' ');
            END LOOP;
        EXCEPTION
        WHEN OTHERS
            THEN DBMS_OUTPUT.PUT_LINE('An error occured');
    END;

/* Test :
    BEGIN
        warehouses_report();
    END;
*/