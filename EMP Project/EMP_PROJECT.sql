CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID   NUMBER PRIMARY KEY,
    FIRST_NAME    VARCHAR2(50),
    LAST_NAME     VARCHAR2(50),
    SALARY        NUMBER(10,2),
    DEPARTMENT_ID NUMBER,
    HIRE_DATE     DATE DEFAULT SYSDATE,
    JOB_TITLE     VARCHAR2(50)
);
    
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (101, 'John', 'Doe', 4000, 10, TO_DATE('2022-06-15', 'YYYY-MM-DD'), 'Software Engineer');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (102, 'Jane', 'Smith', 5500, 20, TO_DATE('2021-04-20', 'YYYY-MM-DD'), 'Senior Developer');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (103, 'Robert', 'Brown', 3200, 30, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'HR Specialist');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (104, 'Emily', 'Davis', 6000, 10, TO_DATE('2020-09-05', 'YYYY-MM-DD'), 'Project Manager');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (105, 'Michael', 'Wilson', 2700, 40, TO_DATE('2023-05-30', 'YYYY-MM-DD'), 'Marketing Specialist');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (106, 'Sarah', 'Miller', 5200, 20, TO_DATE('2022-11-12', 'YYYY-MM-DD'), 'Database Administrator');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (107, 'David', 'Martinez', 4800, 30, TO_DATE('2021-07-19', 'YYYY-MM-DD'), 'Business Analyst');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (108, 'Laura', 'Anderson', 3500, 40, TO_DATE('2020-12-22', 'YYYY-MM-DD'), 'Sales Executive');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (109, 'James', 'Taylor', 7000, 10, TO_DATE('2019-08-03', 'YYYY-MM-DD'), 'Engineering Manager');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, HIRE_DATE, JOB_TITLE) 
VALUES (110, 'Olivia', 'Thomas', 4200, 20, TO_DATE('2021-10-28', 'YYYY-MM-DD'), 'Network Engineer');

COMMIT;     


--1. Using Records and Procedures to Retrieve Employee Details

CREATE OR REPLACE PROCEDURE GET_EMPLOYEE_DETAILS(p_employee_id in employees.employee_id%type)
 IS
 v_emp_records employees%rowtype;
 
 BEGIN
 SELECT * INTO v_emp_records
 FROM employees
 WHERE employee_id = p_employee_id;
 
 DBMS_OUTPUT.PUT_LINE('FIRST NAME: '|| v_emp_records.first_name);
 DBMS_OUTPUT.PUT_LINE('LAST NAME: '|| v_emp_records.last_name);
 DBMS_OUTPUT.PUT_LINE('SALARY: '|| v_emp_records.salary);

END GET_EMPLOYEE_DETAILS;   



--2. Using Loops and Dynamic Data Processing

CREATE OR REPLACE PROCEDURE GET_CALCULATE_BONUS
IS

CURSOR emp_cursor IS 
        SELECT employee_id, first_name, last_name, salary 
        FROM employees 
        WHERE salary > 3000;
        
BEGIN 
FOR i IN emp_cursor LOOP

 DECLARE
            v_new_salary NUMBER;
        BEGIN
            v_new_salary := i.salary + 
                CASE 
                    WHEN i.salary BETWEEN 3000 AND 5000 THEN i.salary * 0.05
                    WHEN i.salary > 5000 THEN i.salary * 0.03
                END;
                
            DBMS_OUTPUT.PUT_LINE('Employee Name: ' || i.first_name || ' ' || i.last_name);
            DBMS_OUTPUT.PUT_LINE('Old Salary: ' || i.salary);
            DBMS_OUTPUT.PUT_LINE('New Salary: ' || v_new_salary);   
        END;    
     END LOOP;
  END GET_CALCULATE_BONUS;  


  
--3. Using Collections to Store and Process Employee Names

CREATE OR REPLACE PROCEDURE GET_EMP_NAME
IS
TYPE EMP_NAMES_TABLE IS TABLE OF varchar2 (50);

v_emp_names emp_names_table;

BEGIN

SELECT FIRST_NAME || LAST_NAME
INTO v_emp_names
FROM EMPLOYEES
WHERE SALARY > 4000;

FOR i IN 1..v_emp_names.COUNT LOOP
 DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_names(i));
END LOOP;

END GET_EMP_NAME;


--4. Conditional Logic and Exception Handling in PL/SQL

CREATE OR REPLACE PROCEDURE GET_EMP_RECORD(p_employee_id IN employees.employee_id%TYPE)
IS
v_emp_rec employees%ROWTYPE;


BEGIN

    SELECT * INTO v_emp_rec
    FROM EMPLOYEES
    WHERE employee_id = p_employee_id;

DBMS_OUTPUT.PUT_LINE('Employee Found: ' || v_emp_rec.first_name || ' ' || v_emp_rec.last_name || ' ' 
|| 'Dep: '||v_emp_rec.department_id);


EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Employee cannot be retreived');

END GET_EMP_RECORD;



--5. Using PL/SQL Tables for Department-wise Salary Analysis

DECLARE 

    TYPE dep_salary_table IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_dep_salary dep_salary_table;

    v_department_id employees.department_id%TYPE;
    v_salary employees.salary%TYPE;

    CURSOR emp_cursor IS 
        SELECT department_id, salary FROM employees WHERE department_id IS NOT NULL;

BEGIN

    FOR emp_rec IN emp_cursor LOOP
        v_department_id := emp_rec.department_id;
        v_salary := emp_rec.salary;

        IF v_dep_salary.EXISTS(v_department_id) THEN
            v_dep_salary(v_department_id) := v_dep_salary(v_department_id) + v_salary;
        ELSE
            v_dep_salary(v_department_id) := v_salary;
        END IF;
    END LOOP;
   
    FOR i IN v_dep_salary.FIRST .. v_dep_salary.LAST LOOP
        IF v_dep_salary.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE('Department ' || i || ': ' || v_dep_salary(i));
        END IF;
    END LOOP;

END;
/




 