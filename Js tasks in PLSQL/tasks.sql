--Task 1
create table books(
    title VARCHAR2(300),
    author VARCHAR2(300),
    is_read VARCHAR2(1) DEFAULT 'N'
);

CREATE OR REPLACE PROCEDURE LIST_BOOKS 
IS
CURSOR BOOKS_CURSOR IS
SELECT TITLE, Author,is_read FROM BOOKS;
books_rec books_cursor%ROWTYPE;

BEGIN
    OPEN books_cursor;
    LOOP
        FETCH books_cursor INTO books_rec;
        EXIT WHEN books_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(books_rec.title || ' - ' || books_rec.author || ' - ' || books_rec.is_read);
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
    INSERT INTO PROFILES
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
PROCEDURE add_task(task_name in varchar2);
procedure del_task(task_id in number);
END upd_del_tasks;

CREATE OR REPLACE PACKAGE BODY upd_del_tasks AS

 procedure add_task(task_name in varchar2)
IS
Begin
insert into tasks (task) 
values (task_name);


commit;
end add_task;

 procedure del_task(task_id in number)
IS
Begin
DELETE from tasks 
where id = task_id;

commit;
end del_task;

END upd_del_tasks;

--Task 4, 5

CREATE TABLE ITEMS(
    item_id number primary key,
    item_name varchar2(100)
);

CREATE TABLE TIMER(
    timer_id number primary key,
    start_time number
);

create or replace package items_timer AS
procedure ins_item(p_item_name in items.item_name%type);
procedure ins_timer(p_timer_id in timer.timer_id%type, p_start_time IN NUMBER);
END items_timer;

create or replace package body items_timer AS

 procedure ins_item(p_item_name in items.item_name%type)
is
Begin
insert into items (item_name)
value (p_item_name);

commit;
end ins_item;

 procedure ins_timer(p_timer_id in  timer.timer_id%type, p_start_time IN NUMBER)
is
Begin
insert into timer(timer_id, start_timer)
values (p_timer_id, p_start_timer);

commit;
end ins_timer

end items_timer;
