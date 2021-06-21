col WORK_TASK_SUB for a20

set verify off timing off
select tm.WORK_TASK,tl.description,tm.WORK_TASK_DESC
 from task_list tl, task_main tm
where tl.taskid = tm.taskid and tm.work_task='&1';

select * from main where work_task='&1';
col work_Task heading SUB_TASK
select * from sub where work_task='&1';
col work_Task heading DAILY_TASK
select * from daily where work_task='&1';
set verify on timing on
