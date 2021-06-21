set verify off timing off
define taskid=&1
define work_task=&2
define work_task_sub=&3
define description=&4
define comment=&5

insert into TASK_MAIN(TASKID,WORK_TASK,WORK_TASK_DESC,START_DATE,COMPLETE_DATE,TASK_CLOSE_DATE,STATUS,COMMENTS) 
 values (&taskid,'&&work_task','&&description',sysdate,NULL,NULL,'InProgress','&&comment');

select * from task_main where taskid=&&taskid and work_task='&&work_task';

prompt at TASK_SUBTASK
insert into TASK_SUBTASK(WORK_TASK,WORK_TASK_SUB,ASSIGNED,START_DATE,COMPLETE_DATE,TASK_CLOSE_DATE,STATUS,COMMENTS)
 values ('&&work_task','&&work_task_sub','Shivdeep',sysdate,null,null,'InProgress','&&comment');

select * from TASK_SUBTASK where work_task='&&work_task' and work_task_sub='&&work_task_sub' and assigned = 'Shivdeep';

prompt at TASK_SUBTASK_DAILY

insert into TASK_SUBTASK_DAILY (WORK_TASK,WORK_TASK_SUB,ASSIGNED,START_DATE,COMPLETE_DATE,TASK_CLOSE_DATE,STATUS,COMMENTS)
 values ('&&work_task','&&work_task_sub','Shivdeep',sysdate,null,null,'InProgress','&&comment');

select * from TASK_SUBTASK_DAILY where work_task='&&work_task' and work_task_sub='&&work_task_sub' and assigned = 'Shivdeep';



commit;
set verify on timing on
