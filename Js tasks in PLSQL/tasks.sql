--Task 1
create table books(
    title VARCHAR2(300),
    author VARCHAR2(300),
    is_read VARCHAR2(1) DEFAULT 'N'
);

CREATE OR REPLACE PROCEDURE LIST_BOOKS 
IS
CURSOR BOOKS_CURSOR IS
SELECT TITLE FROM BOOKS;
books_rec books_cursor%ROWTYPE;

BEGIN
    OPEN books_cursor;
    LOOP
        FETCH books_cursor INTO books_rec;
        EXIT WHEN books_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(books_rec.title);
        END LOOP;
        CLOSE books_cursor;
END LIST_BOOKS;         




--Task 2
CREATE TABLE PROFILES(
    name VARCHAR2 (100),
    AGE NUMBER,
    COUNTRY VARCHAR2 (100)
);

CREATE OR REPLACE PROCEDURE UPD_PROFILE(
    p_name IN varchar2,
    p_age IN number,
    p_country IN varchar2
)
AS
BEGIN
    INSERT INTO
    (name, age, country)
    VALUES (p_name, p_age, p_country);

    commit;
END UPD_PROFILE;

-- Task 3
CREATE table tasks(
    id number primary key,
    task varchar2(300)
);

create or replace package upd_del_tasks AS
PROCEDURE add_task(task_name in varchar2),
procedure del_task(task_id in number);

CREATE OR REPLACE PACKAGE BODY upd_del_tasks AS
create or replace procedure add_task(task_name in varchar2)
IS
Begin
insert into tasks (task) 
values (task_name);


commit;
end add_task;

create or replace procedure del_task(task_id in number)
IS
Begin
DELETE from tasks 
where id = task_id;

commit;
end del_task;

END upd_del_tasks;

--Task 4, 5

CREATE TABLE ITEMS(
    item_id number,
    item_name varchar2(100)
);

CREATE TABLE TIMER(
    timer_id number,
    start_time number
);

create or replace package items_timer AS
procedure ins_item(item_name in p_item_name),
procedure ins_timer(timer_id in p_timer_id);

create or replace package body items_timer AS

create or replace procedure ins_item(item_name in p_item_name)
is
Begin
insert into items (item_name)
value (p_item_name);

commit;
end ins_item;

create or replace procedure ins_timer(timer_id in p_timer_id)
is
Begin
insert into timer(timer_id, start_timer)
values (p_timer_id, p_start_timer);

commit;
end ins_timer

end items_timer;
