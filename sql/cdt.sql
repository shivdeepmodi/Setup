undefine complete_date
undefine WORK_TASK
col work_Task_sub for a30
undefine assigned
undefine started_at

prompt
select daily.* from task_subtask_daily daily where daily.status = 'InProgress';

accept complete_date char prompt 'Enter complete_date(Press enter for sysdate): ' 
accept assigned char prompt 'Enter Assiged to : '

set verify off


set termout off
col complete_date new_value complete_date
col assigned new_value assigned
select decode('&&assigned',null,'Shivdeep','&&assigned') assigned from dual;
set termout on

update task_subtask_daily
   set complete_date = decode('&&complete_date',null,sysdate,to_date('&&complete_date')),
       STATUS='Completed',
       task_close_date=sysdate
 where WORK_TASK='&&WORK_TASK'
   and WORK_TASK_SUB='&&WORK_TASK_SUB'
   and ASSIGNED = decode('&&assigned',null,'Shivdeep','&&assigned')
   and start_Date=to_date('&&start_date')
   and status = 'InProgress'
/
prompt Post Update
select * from task_subtask_daily where WORK_TASK='&&WORK_TASK' and ASSIGNED = decode('&&assigned',null,'Shivdeep','&&assigned');

accept getit prompt 'Commit[Y|N] default N: '
col selected new_value selected
set termout off
select decode('&&getit',null,'N','n','N','y','Y','Y','Y','&&getit') selected from dual;
set termout on
declare
ct number;
begin
if ('&&selected' = 'Y') then
dbms_output.put_line('Commit');
commit;
else
rollback;
dbms_output.put_line('Skip Commit;');
end if;
end;
/
set verify on

