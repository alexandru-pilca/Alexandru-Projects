create table EMP(
    emp_id NUMBER primary key,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    email VARCHAR2(200),
    dep_id NUMBER,
    job_name VARCHAR2(100),
    age NUMBER
    CONSTRAINT FK_dep_id FOREIGN KEY (dep_id)
    REFERENCES dep (dep_id)
);

create table dep (
    dep_id number primary key,
    dep_name VARCHAR2 (100)
);

CREATE SEQUENCE emp_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE dep_seq
START WITH 100
INCREMENT BY 1
NOCACHE
NOCYCLE;


insert into emp (emp_id, first_name, last_name, email, dep_id, job_name, age)
values (emp_seq.nextval, 'Alex', 'Pilca', 'emp@gmail.com', 100, 'developer', 33);

insert into emp (emp_id, first_name, last_name, email, dep_id, job_name, age)
values (emp_seq.nextval, 'Satomi', 'Pilca', 'dance@gmail.com', 102, 'dancer', 35);

insert into emp (emp_id, first_name, last_name, email, dep_id, job_name, age)
values (emp_seq.nextval, 'Ion', 'Balea', 'balea@gmail.com', 103, 'IT', 33);

insert into dep (dep_id, dep_name)
values (dep_seq.nextval, 'CODE');

insert into dep (dep_id, dep_name)
values (dep_seq.nextval, 'DANCE');

insert into dep (dep_id, dep_name)
values (dep_seq.nextval, 'DEV');

CREATE OR REPLACE PACKAGE INS_UPD_DEL_EMP AS
PROCEDURE ins_emp (
    p_first_name in VARCHAR2,
    p_last_name in VARCHAR2,
    p_email in VARCHAR2,
    p_job_name in  VARCHAR2,
    p_age in  NUMBER
);
procedure upd_emp (p_emp_id in emp_id%type);
procedure del_emp (p_emp_id in emp_id%type);

create or replace package body INS_UPD_DEL_EMP as

procedure ins_emp (
    p_first_name in VARCHAR2,
    p_last_name in VARCHAR2,
    p_email in VARCHAR2,
    p_job_name in  VARCHAR2,
    p_age in  NUMBER
);
Begin
insert into emp (emp_id,first_name, last_name, email, job_name,age, dep_id)
values (emp_seq.nextval, p_first_name, p_last_name, p_email, p_job_name, p_age, dep_seq.nextval);

declare
CURSOR emp_cur IS
SELECT emp_id, first_name ||''|| last_name as "Name", email, age, job_name, dep_name FROM emp;
v_emp_rec emp_cur%ROWTYPE;

BEGIN
    for i in emp_cur
    LOOP
        DBMS_OUTPUT.PUT_LINE(i.emp_id||' '||i."Name"||' '||i.email
        ||' '||i.age||' '||i.job_name||' '||i.dep_name );
        end loop;
END ;   

END ins_emp;

procedure upd_emp (p_emp_id in emp.emp_id%type);
Begin
update emp
SET
first_name = p_first_name,
last_name =p_last_name,
email = p_email,
age = p_age,
dep_name = p_dep_name
where emp_id = p_emp_id;

if sql%rowcount = 0 THEN
RAISE_APPLICATION_ERROR(-20002, 'No emp found for the given ID or no update was made.');
and if;
end upd_emp;

 procedure del_emp(p_emp_id in emp.emp_id%type)
IS
Begin
DELETE from emp
where emp_id = p_emp_id;

commit;
end del_emp;

END INS_UPD_DEL_EMP ;