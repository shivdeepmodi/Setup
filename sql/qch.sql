undefine hours
set verify off timing off
--define taskid=
define work_task=&1
--define work_task_sub=
--define description=
--define comment=
Accept hours char prompt 'Give Efforts in hours:'

update TASK_SUBTASK_DAILY
   set COMPLETE_DATE=start_date+to_number(&&hours)/24,TASK_CLOSE_DATE=sysdate,status='Completed'
 where work_task='&&work_task' and assigned = 'Shivdeep' and status = 'InProgress'; 
--where work_task='&&work_task' and work_task_sub='&&work_task_sub'  and assigned = 'Shivdeep' and status = 'InProgress';


select * from TASK_SUBTASK_DAILY where work_task='&&work_task' and assigned = 'Shivdeep';

update TASK_SUBTASK
   set COMPLETE_DATE=start_date+to_number(&&hours)/24,TASK_CLOSE_DATE=sysdate,status='Completed'
 where work_task='&&work_task' and assigned = 'Shivdeep' and status = 'InProgress';
 --where work_task='&&work_task' and work_task_sub='&&work_task_sub'  and assigned = 'Shivdeep' and status = 'InProgress';

select * from TASK_SUBTASK where work_task='&&work_task' and assigned = 'Shivdeep';

update TASK_MAIN
   set COMPLETE_DATE=start_date+to_number(&&hours)/24,TASK_CLOSE_DATE=sysdate ,status='Completed'
 where work_task='&&work_task' and status = 'InProgress';
 --where taskid=&&taskid and work_task='&&work_task' and status = 'InProgress';

select * from task_main where work_task='&&work_task';




commit;
set verify on timing on
