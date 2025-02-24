--PL/SQL similar functionality as the Javascript

create table tasks (
   task_id     number primary key,
   task        varchar2(100),
   task_status char(1) check ( task_status in ( 'T',
                                                'F' ) ) default 'F'
);




create sequence task_seq start with 1 increment by 1;




create or replace package ins_del_tasks as
   procedure ins_task (
      p_task_name tasks.task%type
   );

   procedure del_task (
      p_task_id number
   );

end ins_del_tasks;




create or replace package body ins_del_tasks as

   procedure ins_task (
      p_task_name tasks.task%type
   ) is
   begin
      insert into tasks (
         task_id,
         task
      ) values ( task_seq.nextval,
                 p_task_name );

      commit;
      dbms_output.put_line('Task: '
                           || p_task_name
                           || ' was successfully added!');
   exception
      when others then
         dbms_output.put_line('Error: ' || sqlerrm);
   end ins_task;




   procedure del_task (
      p_task_id number
   ) is
      v_task_status char(1);
   begin
      select task_status
        into v_task_status
        from tasks
       where task_id = p_task_id;

      if v_task_id = 'F' then
         dbms_output.put_line('You can only delete completed tasks.');
      else
         delete from tasks
          where task_id = p_task_id;

         commit;
         dbms_output.put_line('Task successfully deleted!');
      end if;

   end del_task;

end ins_del_tasks;





create or replace function get_task_count return number is
   v_task_count number;
begin
   select count(*)
     into v_task_count
     from tasks;

   dbms_output.put_line(v_task_count || ' items total');
   return v_task_count;
end get_task_count;


create or replace procedure upd_task_status (
   p_task_id number
) is
begin
   update tasks
      set
      task_status = 'T'
    where task_id = p_task_id;

end upd_task_status;






create or replace procedure display_tasks is
begin
   for i in (
      select task_id,
             task,
             case
                when task_status = 'F' then
                   'Not completed'
                when task_status = 'T' then
                   'Completed'
             end
        from tasks
       order by task_id
   ) loop
      dbms_output.put_line('['
                           || i.task_id
                           || '] '
                           || i.task
                           || ' is '
                           || i.task_status);
   end loop;
end display_tasks;






 --Insert, delete, display, get procedure and function calls

begin
   ins_del_tasks.ins_task('Buy groceries');
   ins_del_tasks.ins_task('Complete project');
   ins_del_tasks.ins_task('Call mom');
end;


begin
   display_tasks;
end;


select get_task_count
  from dual;


begin
   ins_del_tasks.del_task(1);
end;

begin
   upd_task_status(1);
end;