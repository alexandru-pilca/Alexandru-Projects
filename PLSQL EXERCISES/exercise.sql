 --1. CREATE TABLES EMPLOEES AN DEPARTMENTS

CREATE TABLE EMPLOYEES (
    EMP_ID NUMBER PRIMARY KEY ,
    FIRST_NAME VARCHAR2(100),
    LAST_NAME VARCHAR2(100),
    HIRE_DATE DATE,
    SALARY NUMBER,
    JOB_TITLE VARCHAR2(100),
    DEP_ID NUMBER,
    FOREIGN KEY (DEP_ID) REFERENCES DEPARTMENTS(DEP_ID)
);

CREATE TABLE DEPARTMENTS (
    DEP_ID NUMBER PRIMARY KEY ,
    DEP_NAME VARCHAR2(100),
    LOCATION VARCHAR2(100)
);



--2. CREATE SEQUENCES

CREATE SEQUENCE EMP_SEQ
START WITH 1 
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE DEP_SEQ
START WITH 100
INCREMENT BY 1
NOCACHE
NOCYCLE;



--3. CREATE TRIGGER TO INS SEQUENCE VALUE IN PRIMARY KEYS

create or replace TRIGGER TRG_EMP
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
BEGIN
  IF :NEW.emp_id IS NULL THEN
    :NEW.emp_id := emp_seq.NEXTVAL;
  END IF;
END;

create or replace TRIGGER TRG_DEP
BEFORE INSERT ON DEPARTMENTS
FOR EACH ROW
BEGIN
  IF :NEW.dep_id IS NULL THEN
    :NEW.dep_id := dep_seq.NEXTVAL;
  END IF;
END;



--4. INSERT VALUES IN TABLES EMPLOYEES AND DEPARTMENTS

insert into emp ( first_name, last_name,HIRE_DATE, dep_id, job_title, salary)
values ( 'Alex', 'Pilca', TO_DATE('2022-06-15', 'YYYY-MM-DD'), 100, 'developer', 3300);

insert into emp ( first_name, last_name, HIRE_DATE, dep_id, job_title, salary)
values ( 'Satomi', 'Pilca', TO_DATE('2022-10-05', 'YYYY-MM-DD'), 102, 'dancer', 3550);

insert into emp ( first_name, last_name, HIRE_DATE, dep_id, job_title, salary)
values ( 'Ion', 'Balea', TO_DATE('2022-03-25', 'YYYY-MM-DD'), 103, 'IT', 3200);

insert into emp ( first_name, last_name, HIRE_DATE, dep_id, job_title, salary)
values ( 'Paul', 'Tudor', TO_DATE('2012-03-05', 'YYYY-MM-DD'), 103, 'IT', 4000);

insert into dep ( dep_name, location)
values ( 'CODE', 'Romania');

insert into dep ( dep_name ,location)
values ('DANCE', 'Slovenia');

insert into dep ( dep_name, location)
values ( 'DEV', 'Austria');

--5. CREATE PACKAGE TO INSERT, UPDATE AND DELETE EMPLOYEES

CREATE OR REPLACE PACKAGE SAVE_DEL_EMPLOYEES AS
PROCEDURE ins_emp (
    p_first_name in VARCHAR2,
    p_last_name in VARCHAR2,
    p_salary in number,
    p_job_title in  VARCHAR2,
    p_hire_date in  date
);
procedure upd_emp (p_emp_id in emp_id%type);
procedure del_emp (p_emp_id in emp_id%type);

END SAVE_DEL_EMPLOYEES;

create or replace package body SAVE_DEL_EMP as

PROCEDURE ins_emp (
    p_first_name in VARCHAR2,
    p_last_name in VARCHAR2,
    p_salary in number,
    p_job_title in  VARCHAR2,
    p_hire_date in  date
)
 IS

Begin
insert into employees (first_name, last_name, hire_date, job_title,salary)
values ( p_first_name, p_last_name, p_hire_date, p_job_name, p_salary);

declare
CURSOR emp_cur IS
SELECT emp_id, first_name ||''|| last_name as "Name", hire_date, salary, job_title, dep_name FROM employees;
v_emp_rec emp_cur%ROWTYPE;

BEGIN
    for i in emp_cur
    LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_id||' '||i."Name"||' '||i.hire_date
        ||' '||i.age||' '||i.job_title||' '||i.dep_name );
        end loop;
END ;   

END ins_emp;




PROCEDURE upd_emp (
  p_emp_id in employees.emp_id%type,
  p_first_name IN employees.first_name%TYPE,
  p_last_name IN employees.last_name%TYPE,
  p_hire_date IN employees.hire_date%TYPE,
  p_salary IN employees.salary%TYPE,
  p_dep_name IN employees.dep_name%TYPE
 )

 is

Begin

update employees
SET
first_name = p_first_name,
last_name =p_last_name,
hire_date = p_hire_date,
salary = p_salary,
dep_name = p_dep_name
where emp_id = p_emp_id;

if sql%NOTFOUND THEN

DBMS_OUTPUT.PUT_LINE('No emp found for the given ID or no update was made.');

ELSE
        DBMS_OUTPUT.PUT_LINE('Employee updated successfully.');
and if;
end upd_emp;



PROCEDURE del_emp(p_emp_id in emp.emp_id%type)

IS

Begin
DELETE from employees
where emp_id = p_emp_id;

commit;
end del_emp;

END SAVE_DEL_EMPLOYEES ;



--6. CREATE VIEW

CREATE OR REPLACE FORCE EDITIONABLE VIEW EMP_DEP_VW ('EMP_ID', 'NAME' ,'SALARY', 'HIRE_DATE', 'JOB_TITLE', 'DEP_NAME', 'LOCATION') AS

 SELECT
 E.EMP_ID,
E.FIRST_NAME|| E.LAST_NAME AS NAME,
E.SALARY,
E.HIRE_DATE,
E.JOB_TITLE,
D.DEP_NAME,
D.LOCATION
FROM EMPLOYEES E
JOIN
DEPARTMENTS D
ON E.DEP_ID = D.DEP_ID;



--7. USE ASSOCIATIVE ARRAY TO PRINT VIEW DETAILS

Declare
TYPE t_emp_vw is table of varchar2(100) index by pls_integer;

v_t_emp_vw t_emp_vw;
i NUMBER := 0;

begin 

for rec in (SELECT * FROM EMP_DEP_VW) LOOP
v_t_emp_vw(i) := rec;
i:= i + 1;
end loop;


  FOR j IN 1 .. v_t_emp_vw.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(
      'EMP_ID: ' || v_t_emp_vw(j).EMP_ID ||
      ', NAME: ' || v_t_emp_vw(j).NAME ||
      ', SALARY: ' || v_t_emp_vw(j).SALARY ||
      ', HIRE_DATE: ' || TO_CHAR(v_t_emp_vw(j).HIRE_DATE, 'YYYY-MM-DD') ||
      ', JOB_TITLE: ' || v_t_emp_vw(j).JOB_TITLE ||
      ', DEP_NAME: ' || v_t_emp_vw(j).DEP_NAME ||
      ', LOCATION: ' || v_t_emp_vw(j).LOCATION
    );
    end loop;

END;



--8. CREATE PROCEDURE TO CALCULATE BONUS FOR EMPLOYEES

CREATE OR REPLACE PROCEDURE GET_SALARY_BONUS 

IS

cursor c_salary is select salary from EMP_DEP_VW where salary >= 2000;
 
 begin 
  for i in c_salary LOOP

  DECLARE
  v_new_salary NUMBER;

  BEGIN 
   
    v_new_salary := 
  
        CASE 
           WHEN i.salary >= 3000 then i.salary + 1000
           WHEN i.salary < 3000 then i.salary + 1500
        end;

DBMS_OUTPUT.PUT_LINE('Employee Name: '||i.name);
DBMS_OUTPUT.PUT_LINE('Employee new salary: '||v_new_salary);



 end;

 end loop;

end GET_SALARY_BONUS;


--9. CREATE A FUNCTION TO CHANGE THE DEPARTMENT FOR EACH EMPLOYEE IN THE VIEW

CREATE FUNCTION UPD_DEP_VW (p_emp_id EMP_DEP_VW.emp_id%type,
        p_dep_name EMP_DEP_VW.dep_name%type
)    
return varchar2;

is

BEGIN
  UPDATE EMP_DEP_VW
  set 
  dep_name = p_dep_name
  where emp_id = p_emp_id;

  IF SQL%ROWCOUNT = 0 THEN
        RETURN 'No record updated';
    ELSE
   return p_dep_name;
  
  end UPD_DEP_VW;


  declare

  v_new_depName varchar2(100);
  p_emp_id EMP_DEP_VW.emp_id%type;
  p_dep_name EMP_DEP_VW.dep_name%type;

  begin
  
  v_new_depName := UPD_DEP_VW(p_emp_id);

  DBMS_OUTPUT.PUT_LINE('The Employee: '||p_emp_id||' '||'new department name is: '|| v_new_depName);

  end;



  --10. Write a PL/SQL procedure to accepts a BOOLEAN parameter and uses a CASE statement 


  CREATE OR REPLACE PROCEDURE CHECK_SALARY(p_check BOOLEAN)
     IS

     BEGIN
      if p_check then

      FOR i IN (SELECT SALARY FROM EMP_DEP_VW )LOOP
      DBMS_OUTPUT.PUT_LINE(
        CASE
          WHEN i.salary < 3000 then 'Salary is low'
          when i.salary >3000 then 'Salary is high'
          end    
      );
end loop;
  else 
  DBMS_OUTPUT.PUT_LINE('Salary is normal');
end if;

end CHECK_SALARY;


 --11. CREATE A TABLE EMP AND A NESTED TABLE TASKS. ADD MULTIPLE TASKS TO EACH EMPLOYEE FROM THE TABLE EMP and POPULATED AND EXECUTE THE PROCEDURE

 CREATE TABLE EMP(
  ID NUMBER PRIMARY KEY,
  EMP_NAME VARCHAR2(100),
  DEPARTMENT VARCHAR2(100)
 );

 create SEQUENCE emp_seq
 start with 100
 INCREMENT 1;


  create TYPE t_tasks IS TABLE OF VARCHAR2(100);


 ALTER TABLE EMP
 ADD TASKS t_tasks NESTED TABLE TASKS STORE AS TASKS_TABLE;

 create procedure ins_tasks(
  p_name in varchar2,
  department in varchar2,
  p_task_1 varchar2,
 p_task_2 varchar2,
 p_task_3 varchar2
)

is

BEGIN

insert into emp (id, EMP_NAME, department, TASKS)
values (emp_seq.NEXTVAL, p_name, p_department, t_tasks( p_task_1, p_task_2, p_task_3));

COMMIT;

end ins_tasks;


BEGIN
  ins_tasks('Alexandru', 'Development', 'Write pl/sql code', 'Populate with data', 'Execute procedure');
END;



--12. INSERT PROCEDURE USING BULK COLLECT and GET THE COUNT OF EMP NAME

CREATE TABLE EMPNAME AS 
SELECT EMP_ID, FIRST_NAME ||' '|| LAST_NAME NAME
FROM EMPLOYEES;


DECLARE
TYPE t_ename is table of varchar2(100) index by pls_integer;
 v_ename t_ename;


 procedure get_empName_count(p_emp_count OUT number)
 
  is

 begin

 select count(*) into p_emp_count
 from EMPNAME
 where emp_id is not null;

 end get_empName_count;

 
 emp_count number; --variable to store count from the procedure

 begin

 get_empName_count(emp_count);
    DBMS_OUTPUT.PUT_LINE('Total Employee Names: ' || emp_count);


 select  name  bulk collect into v_ename
 from EMPNAME;

 for i in v_ename.first..v_ename.last
 loop
 DBMS_OUTPUT.PUT_LINE(v_ename(i));
 end loop;

 end;


--13. CREATE TRIGGER TO INS, UPD OR DEL DATA FROM JURNAL TABLE EMP

CREATE TABLE EMPLOYEES_JN (
  EMP_ID NUMBER PRIMARY KEY ,
    FIRST_NAME VARCHAR2(100) NOT NULL,
    LAST_NAME VARCHAR2(100)  NOT NULL,
    HIRE_DATE DATE  NOT NULL,
    SALARY NUMBER  NOT NULL,
    JOB_TITLE VARCHAR2(100)  NOT NULL,
    DEP_ID NUMBER  NOT NULL,
    JN_DATETIME DATE,
  JN_SESSION VARCHAR2(100),
  JN_OPERATION VARCHAR2(10)

);

CREATE OR REPLACE TRIGGER EMP_JNTRG 
AFTER
INSERT OR
UPDATE OR
DELETE ON EMPLOYEES
FOR EACH ROW

DECLARE
v_rec employees_jr%ROWTYPE;
v_blank employees_jr%ROWTYPE;

begin
v_rec := v_blank;

if inserting or UPDATING then
v_rec.emp_id := :NEW.emp_id;
v_rec.first_name := :NEW.first_name:
v_rec.last_name := :new.last_name;
v_rec.hire_date := :new.hire_date;
v_rec.salary :=  :new.salary;
v_rec.job_title := :new.job_title;
v_rec.dep_id := :new.dep_id;
v_rec.JN_DATETIME := SYSDATE;
v_rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 

if inserting then 
v_rec.JN_OPERATION := 'INS';
ELSIF UPDATING THEN
v_rec.JN_OPERATION := 'UPD';
end if;

elsif deleting then
v_rec.emp_id := :old.emp_id;
v_rec.first_name := :old.first_name:
v_rec.last_name := :old.last_name;
v_rec.hire_date := :old.hire_date;
v_rec.salary :=  :old.salary;
v_rec.job_title := :old.job_title;
v_rec.dep_id := :old.dep_id;
v_rec.JN_DATETIME := SYSDATE;
v_rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
v_rec.JN_OPERATION := 'DEL'

end if;

insert into EMPLOYEES_JN values v_rec;

end;

--14. WRITE BASIC LOOP TO OUTPUT EMPLOYEE FIRST_NAME || LAST_NAME


declare 
type t_name is table of varchar2(100);
v_counter number := 0;
v_t_name t_name;

begin
select first_name || ' '|| last_name 
bulk collect
into v_t_name
from EMPLOYEES;

loop
v_counter := v_counter + 1;
DBMS_OUTPUT.PUT_LINE(v_t_name (v_counter));

exit when v_counter > 3;
end loop;

end;



--15. USE WHILE LOOP TO UPDATE THE SALARY AND OUTPUT IT


DECLARE 
v_emp_id number := 1;
v_ename employees.first_name%type;
V_salary number;

begin

while v_emp_id <= 5
loop

update employees
set salary = salary + 100
where emp_id = v_emp_id;

insert into v_salary
values (salary)
from employees
where emp_id = v_emp_id;

DBMS_OUTPUT.PUT_LINE(v_ename||': '||v_salary);

v_emp_id:= v_emp_id + 1;

end loop;

end;



--16. USE FOR LOOP TO OUTPUT DEP WITH EMPLOYEE NAME and use associative array to store the dep_id


DECLARE 
type t_dep is table of departments.dep_id%type index by pls_integer ;
v_ename employees.first_name%type;
v_dep_id t_dep;

begin
 

select dep_id
bulk collect into v_dep_id
from departments;

for i in v_dep_id.first .. v_dep_id.last 
Loop

select first_name||' '||last_name
into v_ename
from employees
where dep_id =v_dep_id(i);

DBMS_OUTPUT.PUT_LINE('Dep '||v_dep_id(i)||' contains employee: '||v_ename);

end loop;
end;




--17. FETCH THE EMPLOYEE NAME , SALARY AND JOB NAME FROM EMPLOYEES TABLE WHERE DEP_ID COMES FROM A FUNCTION USING CURSOR WITH PARAMETER

CREATE OR REPLACE FUNCTION GET_DEP_ID( p_emp_id NUMBER)
RETURN NUMBER
is
V_DEP NUMBER;

BEGIN
  SELECT DEP_ID INTO V_DEP
  FROM EMPLOYEES
  WHERE EMP_ID = p_emp_id;

RETURN V_DEP;

  END;

DECLARE
p_emp_id EMPLOYEES.EMP_ID%TYPE := 0;

BEGIN

for i in (select first_name || ' '||last_name as name, salary, job_name
from employees
where DEP_ID = GET_DEP_ID(p_emp_id)
) loop

DBMS_OUTPUT.PUT_LINE(i.name||' '||i.salary||' '||i.job);

end loop;

end;


--18. Create a Procedure to Get Employee Names: Write a procedure that retrieves and prints the names of all employees from the EMPLOYEES table.

 create or replace procedure get_all_emp_name IS
 cursor c_emp is select first_name||' '||last_name as full_name from employees;

 v_ename employees.first_name%type;

 begin

dbms_output.put_line('List of Employees: ');

for i in c_emp LOOP
dbms_output.put_line(i.full_name);
end loop;

end get_all_emp_name;





--19. Create a Function to Calculate Employee Age: Write a function that takes an employee's ID as input and returns the employee's age based on their date of birth.

create or replace function get_emp_ages(p_emp_id employees.employee_id%type) return number
is
v_age number;
v_name employees.first_name%type;

begin

select first_name||' '||last_name as full_name into v_name 
from employees
where employee_id = p_emp_id;

select extract(year from sysdate) -extract(year from date_of_birth) into v_age
from employees
where employee_id = p_emp_id;

dbms_output.put_line ('Employee '||v_name|| 'is '||v_age||' years old');

return v_age;

end get_emp_ages;



DECLARE
  v_age NUMBER;
BEGIN
  v_age := get_emp_ages(101); 

END;
/


--20. Create a Procedure to Update Employee Salary: Write a procedure that updates the salary of an employee based on their ID and a new salary value provided as input.

create or replace procedure upd_emp_sal(p_emp_id employees.employee_id%type , p_sal employees.salary%type)
IS
BEGIN
  update employees 
  set salary = p_sal
  where employee_id = p_emp_id;

  dbms_output.put_line('Employee '|| p_emp_id || ' salary has been updated to ' ||v_sal);

  end upd_emp_sal;




--21. Create a Trigger to Log Updates: Write a trigger that logs any updates made to the EMPLOYEES table into a EMPLOYEE_LOG table.

create or replace trigger emp_log 
AFTER
insert OR
update OR
delete on 
Employees
for each ROW

declare
v_rec employees%ROWTYPE;
v_blank employees%rowtype;

begin
v_rec := v_blank;

if inserting or updating then
v_rec.employee_id := :new.employee_id;
v_rec.first_name := :new.first_name;
v_rec.last_name := :new.last_name;
v_rec.salary := :new.salary;
v_rec.hire_date := :new.hire_date;
v_rec.department_id := :new.department_id;
v_rec.job_name := :new.job_name;
v_rec.date_of_birth := :new.date_of_birth;

if inserting then v_rec.JN_OPERATION := 'INS';
ELSIF 
UPDATING THEN v_rec.JN_OPERATION := 'UPD';
END IF;

ELSIF DELETING THEN
v_rec.employee_id := :OLD.employee_id;
v_rec.first_name := :old.first_name;
v_rec.last_name := :old.last_name;
v_rec.salary := :old.salary;
v_rec.hire_date := :old.hire_date;
v_rec.department_id := :old.department_id;
v_rec.job_name := :old.job_name;
v_rec.date_of_birth := :old.date_of_birth;
v_rec.JN_OPERATION := 'DEL';
end if;

insert into EMPLOYEE_LOG values v_rec;

end;





--22. Create a Procedure to Delete Old Records: Write a procedure that deletes records from the EMPLOYEES table that are older than a specified number of years.


create or replace procedure del_oldEmployees (
  p_years in number
)
IS
v_cuttof_date date;

begin

v_cuttof_date := add_months(sysdate, -12 * p_years);

delete from employees
where hire_date < v_cuttof_date;

DBMS_OUTPUT.PUT_LINE('Records older than ' || p_years || ' years have been deleted.');

EXCEPTION
when OTHERS THEN
ROLLBACK;

end del_oldEmployees;




--23. Create a Function to Get Department Name: Write a function that takes a department ID as input and returns the name of the department.


create or replace function get_dep_name(p_dep_id departments.dep_id%type) return varchar2
is

v_dep_name departments.dep_name%type;

begin

select dep_name into v_dep_name
from departments
where dep_id = p_dep_id;

dbms_output.put_line(' Department with the id: '||p_dep_id||' is called '||v_dep_name);
 return v_dep_name;

 EXCEPTION
 when no_data_found then
 return 'Department not found!!!!';

end get_dep_name;





--24. Create a Procedure to Transfer Employees: Write a procedure that transfers an employee from one department to another based on employee ID and new department ID.




create or replace procedure transfer_emp (p_emp_id in number, p_new_dep_id in number)
is

v_emp_exists number;
v_dep_exists number;
v_old_dep_id number;

begin

select count(*) 
into v_emp_exists
from employees
where employee_id = p_emp_id;

if v_emp_exists = 0
then 
dbms_output.put_line('Employee not found');

select count(*) into v_dep_exists
from departments
where dep_id = p_new_dep_id;

if v_new_dep_id = 0
then
dbms_output.put_line('Department not found');

select dep_id into v_old_dep_id
from employees 
where employee_id = p_emp_id;

update employees
set dep_id = p_new_dep_id
where employee_id = p_emp_id;


commit;

 DBMS_OUTPUT.PUT_LINE('Employee ' || p_emp_id || ' transferred from department ' || v_old_dept_id || ' to department ' || p_new_dept_id);

 EXCEPTION
 when others THEN

rollback;

end transfer_emp;




--25. Create a Function to Calculate Total Salary: Write a function that calculates and returns the total salary of all employees in a specific department.



create or replace function get_total_sal(p_dep_id number) return number
IS
v_total_sal number;

begin

select nvl(sum(salary), 0) into v_total_sal
from employees
where dep_id = p_dep_id;

dbms_output.put_line('Total salary for department '||p_dep_id ||' is ' ||v_total_sal);

return v_total_sal;


end get_total_sal;



--26. Create a Procedure to Insert New Employee: Write a procedure that inserts a new employee record into the EMPLOYEES table.

create or replace procedure ins_new_emp (
  p_first_name employees.first_name%type,
  p_last_name employees.last_name%type,
  p_salary employees.salary%type,
  p_hire_date employees.hire_date%type,
  p_date_of_birth employees.date_of_birth%type,
  p_job_title employees.job_title%type
)
IS

begin 

insert into employees (employee_id, first_name, last_name, salary, hire_date, department_id, date_of_birth, job_title)
values (emp_seq.NEXTVAL, p_first_name, p_last_name, p_salary, p_hire_date, dep_seq.NEXTVAL, p_date_of_birth, p_job_title );

DBMS_OUTPUT.PUT_LINE('Employee ' || p_first_name || ' ' || p_last_name || ' inserted successfully.');

EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inserting employee: ' || SQLERRM);

end ins_new_emp;



--27. Create a Procedure to Generate Employee Report: Write a procedure that generates a report of all employees, including their ID, name, department, and salary, and stores it in a temporary table.

create gčobač temporary table employee_repot(
  emp_id number,
  emp_name varchar2(100),
  dep_name varchar2(50),
  salary number
) ON COMMIT PRESERVE ROWS;

create or replace procedure generate_emp_report
IS

begin 

INSERT INTO EMPLOYEE_REPORT (emp_id, emp_name, dep_name, salary)
    SELECT 
        e.employee_id, 
        e.first_name || ' ' || e.last_name AS emp_name,
        d.department_name,
        e.salary
    FROM EMPLOYEES e
    JOIN DEPARTMENTS d ON e.department_id = d.department_id;

    commit;

    DBMS_OUTPUT.PUT_LINE('Employee report generated successfully.');

    end  generate_emp_report;




    --28. Hello World: Create a PL/SQL block that outputs "Hello World!".
declare
v_hello := 'Hello World!';
begin

for i in 1..5 loop
dbms_output.put_line(v_hello);
end loop;

end;




  --29. Simple Calculator: Write a PL/SQL procedure that performs basic arithmetic operations like addition, subtraction, multiplication, and division.

  create or replace procedure arit_calc(p_emp_id employees.employee_id%type) IS

  v_new_sal number;

begin

select CASE
when salary > 1000 then salary * 10
when salary = 3000 then salary / 0.5
when salary < 5000 then salary + 1000
elsa salary 
end
into v_new_sal
from employees
where employee_id = p_emp_id;

DBMS_OUTPUT.PUT_LINE('New Salary: ' || v_new_sal);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || p_emp_id);


end arit_calc;



/*30. Employee Database:

Create a table to store employee information (name, age, department, salary).

Write a PL/SQL function to calculate the average salary of employees.

Develop a PL/SQL procedure to give a salary raise to all employees in a specific department.*/

create or replace package emp_sal_pck as
function avg_sal return number;
procedure sal_raise(p_dep_id number);
end emp_sal_pck;

create or replace package body emp_sal_pck as

 function avg_sal return number is

v_avg_sal number;

begin

select avg(salary) into v_avg_sal from employees;

return v_avg_sal;

end avg_sal;

 procedure sal_raise(p_dep_id number)IS
v_new_sal number;

begin

update employees 
set salary = salary + (salary * 0.5)
where dep_id = p_dep_id;

end sal_raise;

end emp_sal_pck;




/*31. Student Grades:

Create a table for storing student grades.

Write a PL/SQL function to calculate the GPA of a student.

Develop a PL/SQL procedure to update grades for a specific student.*/

CREATE TABLE student_grades (
  student_id NUMBER PRIMARY KEY,
  student_name VARCHAR2(100),
  subject VARCHAR2(50),
  grade CHAR(2),  
  credit_hours NUMBER
);

INSERT INTO student_grades VALUES (101, 'John Doe', 'Math', 'A', 3);
INSERT INTO student_grades VALUES (101, 'John Doe', 'Science', 'B', 4);
INSERT INTO student_grades VALUES (101, 'John Doe', 'History', 'C', 2);
INSERT INTO student_grades VALUES (102, 'Alice Smith', 'Math', 'B', 3);
INSERT INTO student_grades VALUES (102, 'Alice Smith', 'Science', 'A', 4);


create or replace function calc_gpa(p_student_id number)return NUMBER
is
v_gpa number := 0;
v_total_points number := 0;
v_total_credit number := 0;
v_grade_points number;

function grade_to_points(p_grade char) return number IS

begin 

CASE
  when 'A' then return 4.0;
  when 'B' then return 3.0;
  when 'c' then return 2.0;
  when 'D' then return 1.0;
  when 'F' then return 0.0;
  else return null;
  end case;

  end grade_to_points;

  begin

  for i in (select grade, credit_hours from student_grades where student_id = p_student_id) loop
  v_grade_points := grade_to_points(i.grade);

  IF v_grade_points IS NOT NULL THEN
      v_total_points := v_total_points + (v_grade_points * i.credit_hours);
      v_total_credits := v_total_credits + i.credit_hours;
    END IF;
  END LOOP;

  IF v_total_credits > 0 THEN
    v_gpa := v_total_points / v_total_credits;
  END IF;

  RETURN v_gpa;

  END calc_gpa;



  CREATE OR REPLACE PROCEDURE upd_student_grade(
  p_student_id NUMBER,
  p_subject VARCHAR2,
  p_new_grade CHAR
) IS

BEGIN
 
  UPDATE student_grades
  SET grade = p_new_grade
  WHERE student_id = p_student_id AND subject = p_subject;

  DBMS_OUTPUT.PUT_LINE('Grade updated successfully for Student ID: ' || p_student_id);

  end upd_student_grade;







/*32. Inventory Management:

Create tables for products and inventory.

Write a PL/SQL procedure to update the inventory levels when a product is sold.

Develop a PL/SQL function to calculate the total value of the inventory.*/


CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    price NUMBER
);


CREATE TABLE inventory (
    product_id NUMBER PRIMARY KEY,
    quantity NUMBER,  
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


create or replace procedure upd_inventory(p_product_id number, p_qty_sold number)
IS
v_stock number;

begin
 
 select quantity into v_stock from inventory where product_id = p_product_id; 

 if v_stock >= p_qty_sold then
 update inventory
 set quantity = quantity - p_qty_sold
 where product_id = p_product_id;

 DBMS_OUTPUT.PUT_LINE('Inventory updated successfully.');

 ELSE
    DBMS_OUTPUT.PUT_LINE('Not enough stock available.');
  END IF;

  END upd_inventory;

  create or replace function total_inventory_value return number IS
  v_total_value number;

  begin
select sum(p.price + i.quantity)
into v_total_value
from products p
join inventory i
on p.product_id = i.product_id;

return v_total_value;

end total_inventory_value;





/*33. Banking Application:

Create tables for customer accounts and transactions.

Write a PL/SQL procedure to transfer money between accounts.

Develop a PL/SQL function to calculate the total balance for a customer.*/

CREATE TABLE customer_accounts (
    account_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    balance NUMBER
);


CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    from_account_id NUMBER,
    to_account_id NUMBER,
    amount NUMBER,
    transaction_date DATE,
    FOREIGN KEY (from_account_id) REFERENCES customer_accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES customer_accounts(account_id)
);

create sequence transactions_seq
start with 1
INCREMENT by 1;


create or replace procedure transfer_money(
p_from_account_id number,
p_to_account_id number,
p_amount number
)
IS
 v_from_balance number;

begin

select balance into v_from_balance
from customer_accounts
where account_id = p_from_account_id;

update customer_accounts
set balance = balance + p_amount
where account_id = p_from_account_id;

update customer_accounts
set balance = balance + p_amount
where account_id = p_to_account_id;

INSERT INTO transactions (transaction_id, from_account_id, to_account_id, amount, transaction_date)
    VALUES (transactions_seq.NEXTVAL, p_from_account_id, p_to_account_id, p_amount, SYSDATE);

    END transfer_money;


    create or replace function get_total_balance (p_customer_name varchar2) return number
    IS
    v_total_balance number;

    begin

    select sum(balance) into v_total_balance
    from customer_accounts
    where customer_name = p_customer_name;

    return v_total_balance;

    end get_total_balance;



    --34. Write a PL/SQL block that demonstrates how to handle exceptions, such as division by zero or null value errors.


    declare 
    v_number1 := 5;
    v_number2 := 0:
    v_result number;
    v_val number := null;

    begin 

    v_result := v_number1 / v_number2;

    EXCEPTION
    when zero_divide THEN
    DBMS_OUTPUT.PUT_LINE( 'Division by zero occurred.');

    end;

    begin

     if v_val is null THEN
     raise value_error;

     end if;

     EXCEPTION
     when value_error THEN
      DBMS_OUTPUT.PUT_LINE('Error: Null value encountered.');
      end;

      end;


      --35.Create a pl/sql block to calculates the total sales for each product by joining the products and sales tables.

      declare

      cursor c_sale select p.product_name, sum(s.sale_amount) as total_amount
      from products p
      join sales s
      on p.product_id = s.product_id
      group by p.product_name;
    
    v_product_name varchar2(100);
    v_total_sale number;

      begin

      for rec in c_sale loop
      v_product_name := rec.product_name;
      v_total_sale := rec.total_amount;

      dbms_output.put_line ('Product: '|| v_product_name||' , Total Sales: '||v_total_sale);

      end loop;

      end;

      --36. Create a pl/sql block that retrieves the names of products that have total sales greater than the average sales across all products.

      declare 

      cursor c_products is
      select product_name 
      from products
      where product_id in (
        select s.product_id
        from sales s
        group by s.product_id
        having sum(s.sale_amount) > (
          select avg(total_sale)
          from (select sum(sale_amount) as total_amount
          from Sales
          group by product_id)
        )
      );

      v_product_name varchar2(100);

      begin

      for i in c_products
      loop
      v_product_name := i.product_name;

      DBMS_OUTPUT.PUT_LINE('Product with sales greater than the average: ' || v_product_name);

      end loop;

      end;



--37. Hierarchical Query using CONNECT BY and START WITH

CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    dep_type VARCHAR(50),
    parent_id INT NULL, 
);

-- Top-Level Departments (No Parent)
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (1, 'Head Office', 'Corporate', NULL);
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (2,  'Engineering', 'IT', NULL);
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (3, 'Manufacturing', 'Operations', NULL);

-- Sub-Departments under Head Office
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (4, 'HR', 'Support', 1);
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (5, 'Finance', 'Support', 1);
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (6, 'IT', 'Support', 1);

-- Sub-Departments under Engineering
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (7, 'Mechanical Engineering', 'Technical', 2);
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (8, 'Electrical Engineering', 'Technical', 2);

-- Sub-Departments under Manufacturing
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (9, 'Assembly', 'Production', 3);
INSERT INTO departments (id, name, dep_type, parent_id) VALUES (10, 'Quality Control', 'Production', 3);



SELECT 
    LEVEL AS hierarchy_level,
    LPAD(' ', LEVEL * 3) || name AS department_name, 
    dep_type, 
    parent_id
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR id = parent_id
ORDER SIBLINGS BY name;





SELECT 
    LEVEL AS hierarchy_level,  
    aosp.opp_id,
    aosp.main_opp_id,
    aosp.opp_type,
    LPAD(' ', LEVEL * 3) || aosp.opp_name AS indented_opp_name, 
    wsh.sales_price_reporting AS reporting_currency_amount,
    wsh.reporting_cur_code AS reporting_currency,
    WEBCRM_UTILS.get_exchangerate (
        p_opp_id           => aosp.opp_id,
        p_cur_code         => wsh.cur_code,
        p_is_reporting_cur => 'Y',
        p_allow_insert     => 'N'
    ) AS exchange_rate,
    wsh.sales_price AS quotation_currency_amount,
    wsh.cur_code AS quotation_currency
FROM apx_opps_single_project aosp
JOIN worksheets wsh ON wsh.opp_id = aosp.opp_id AND wsh.active = 'Y'
START WITH aosp.main_opp_id = :P3100_OPP_ID  
CONNECT BY PRIOR aosp.opp_id = aosp.main_opp_id  
ORDER BY LEVEL, aosp.opp_id;



      