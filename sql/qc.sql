set verify off timing off
define work_task=&1

update TASK_SUBTASK_DAILY
   set COMPLETE_DATE=sysdate,TASK_CLOSE_DATE=sysdate,status='Completed'
 where work_task='&&work_task' and assigned = 'Shivdeep' and status = 'InProgress';

select * from TASK_SUBTASK_DAILY where work_task='&&work_task'  and assigned = 'Shivdeep' order by COMPLETE_DATE;


update TASK_SUBTASK
   set COMPLETE_DATE=sysdate,TASK_CLOSE_DATE=sysdate,status='Completed'
 where work_task='&&work_task' and assigned = 'Shivdeep' and status = 'InProgress';

select * from TASK_SUBTASK where work_task='&work_task'  and assigned = 'Shivdeep';

update TASK_MAIN
   set COMPLETE_DATE=sysdate,TASK_CLOSE_DATE=sysdate ,status='Completed'
 where work_task='&&work_task' and status = 'InProgress';
select * from task_main where work_task='&work_task'  ;


commit;
set verify on timing on
