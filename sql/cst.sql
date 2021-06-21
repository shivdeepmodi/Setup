undefine task_name
undefine assigned
undefine STARTED
 
prompt Subtask Status...
prompt
@/home/oracle/shivdeep/sql/repsub_open.sql


set serverout on verify off
prompt
prompt
Accept task_name char prompt 'Give SUB Task to be closed:'
prompt
prompt Sub task Status
select * from task_subtask where work_task='&&task_name';

prompt Daily Task Status for Task &&task_name
prompt
select * from task_subtask_daily where work_task='&&task_name';
prompt
declare
ct number;
begin

--Find if any daily task is open
--
select count(*) into ct
  from task_subtask_daily daily, task_subtask sub
 where sub.WORK_TASK = daily.work_task
   and sub.WORK_TASK = '&&task_name'
   and sub.assigned = daily.assigned
   and sub.assigned = '&&assigned'
   and daily.status ='InProgress';

if (ct > 0) then
 dbms_output.put_line('Daily Task : '||'&&task_name'||' is still InProgress');
else

 update task_subtask
   set complete_date = to_date('&COMPLETED'),status='Completed',TASK_CLOSE_DATE=sysdate
 where WORK_TASK='&&task_name'
   and WORK_TASK_SUB ='&&WORK_TASK_SUB'
   and start_date = to_date('&&start_date')
   and ASSIGNED = '&&assigned' and status='InProgress';


commit;

end if;


end;
/

 select * from task_subtask
 where WORK_TASK='&&task_name'
   and WORK_TASK_SUB ='&&WORK_TASK_SUB'
   and start_date = to_date('&&start_date')
   and ASSIGNED = '&&assigned' ;
set verify on
