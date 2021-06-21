-- TASK_MAIN
-- task_subtask
-- task_subtask_daily
undefine task_name
undefine completed_date
@/home/oracle/shivdeep/sql/repmain_open.sql

set serverout on verify off
prompt
prompt
Accept task_name char prompt 'Give Task to be closed:'
prompt
col work_task heading SUB_TASK
select * from task_subtask where work_task='&&task_name';

prompt
declare
ct number;
subtask_exists   exception;
dailytask_exists exception;
begin

--Find if any daily task is open
--
select count(*) into ct
  from task_subtask_daily daily, TASK_MAIN main
 where main.WORK_TASK = daily.work_task
   and main.WORK_TASK = '&task_name'
   and daily.status ='InProgress';

if (ct > 0) then
 raise dailytask_exists;
else
 dbms_output.put_line('NO Daily Task Open for '||'&&task_name');
end if;

--Find if any subtask is open
--
select count(*) into ct
  from task_subtask sub, TASK_MAIN main
 where main.WORK_TASK = sub.work_task
   and main.WORK_TASK = '&task_name'
   and sub.status ='InProgress';

if (ct > 0) then
 raise subtask_exists;
else
 dbms_output.put_line('NO SUB Task Open for  : '||'&&task_name'|| ' can be closed');
end if;

update TASK_MAIN set status = 'Completed', complete_date=to_date('&&completed_date'),TASK_CLOSE_DATE=sysdate where WORK_TASK = '&&task_name' and status='InProgress';
commit;

exception
when subtask_exists then
 dbms_output.put_line('SUB Task   : '||'&&task_name'||' is still InProgress');
when dailytask_exists then
 dbms_output.put_line('Daily Task : '||'&&task_name'||' is still InProgress');

end;
/

set verify on
