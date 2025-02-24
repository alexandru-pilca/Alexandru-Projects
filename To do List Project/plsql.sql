--PL/SQL similar functionality as the Javascript

create table Tasks(
    task_id number primary key,
    task VARCHAR2(100),
    task_status char(1) CHECK (task_status in ('T','F')) default 'F'
);




create SEQUENCE task_seq
start with 1
increment by 1;




create or replace package ins_del_tasks AS

procedure ins_task(p_task_name tasks.task%type);

procedure del_task(p_task_id number);

end ins_del_tasks;




create or replace PACKAGE body ins_del_tasks AS

procedure ins_task(
    p_task_name tasks.task%type
)
IS

BEGIN

    insert into tasks (task_id, task)
    values (task_seq.NEXTVAL, p_task_name);

    commit;

    DBMS_OUTPUT.put_line('Task: '||p_task_name||' was successfully added!');

 EXCEPTION

 WHEN OTHERS THEN
 DBMS_OUTPUT.put_line('Error: '||SQLERRM);

 end ins_task;




 procedure del_task(p_task_id number) 
 IS

 begin

 DELETE from tasks
 where task_id = p_task_id;

 commit;

 dbms_output.put_line('Task successfully deleted!');

 end del_task;

 end ins_del_tasks; 





 create or replace function get_task_count return NUMBER
 IS

 v_task_count number;

 begin

 select count(*) into v_task_count
 from tasks;

 dbms_output.put_line(v_task_count||' items total');

 return v_task_count;

 end get_task_count;


 create or replace procedure upd_task_status(
    p_task_id number 
  )
    is

    BEGIN
        UPDATE tasks
        set task_status = 'T'
        where task_id = p_task_id;

     end upd_task_status;   






 create or replace procedure display_tasks
 is

 begin
 for i in (select task_id, task, 
 CASE
   when task_status = 'F' then 'Not completed'
   when task_status = 'T' then 'Completed'
   end
   FROM tasks order by task_id) loop
 dbms_output.put_line('['||i.task_id||'] '||i.task||' is '||i.task_status);
 end loop;

 end display_tasks;






 --Insert, delete, display, get procedure and function calls

 BEGIN
    ins_del_tasks.ins_task('Buy groceries');
    ins_del_tasks.ins_task('Complete project');
    ins_del_tasks.ins_task('Call mom');
END;


BEGIN
    display_tasks;
END;


SELECT get_task_count FROM dual;


BEGIN
    ins_del_tasks.del_task(1);
END;

begin 
 upd_task_status(1);
end;
