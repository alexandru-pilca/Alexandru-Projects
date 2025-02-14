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
v_rec.emp_id := NEW.emp_id;
v_rec.first_name := NEW.first_name:
v_rec.last_name := new.last_name;
v_rec.hire_date := new.hire_date;
v_rec.salary :=  new.salary;
v_rec.job_title := new.job_title;
v_rec.dep_id := new.dep_id;
v_rec.JN_DATETIME := SYSDATE;
v_rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 

if inserting then 
v_rec.JN_OPERATION := 'INS';
ELSIF UPDATING THEN
v_rec.JN_OPERATION := 'UPD';
end if;

elsif deleting then
v_rec.emp_id := old.emp_id;
v_rec.first_name := old.first_name:
v_rec.last_name := old.last_name;
v_rec.hire_date := old.hire_date;
v_rec.salary :=  old.salary;
v_rec.job_title := old.job_title;
v_rec.dep_id := old.dep_id;
v_rec.JN_DATETIME := SYSDATE;
v_rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
v_rec.JN_OPERATION := 'DEL'

end if;

insert into EMPLOYEES_JN value v_rec;

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



--16. USE FOR LOOP TO OUTPUT DEP WITH EMPLOYEE NAME and use nested table to store the dep_id

DECLARE 
type t_dep is table of departments.dep_id%type  ;
v_ename employees.first_name%type;
v_dep_id t_dep;

begin
 
 v_de_id := t_dep();
 
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




