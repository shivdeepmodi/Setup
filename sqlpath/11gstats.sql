/*
If for some reason automatic optimizer statistics collection is disabled, then you can enable it using the ENABLE procedure in the DBMS_AUTO_TASK_ADMIN package.


exec  dbms_auto_task_admin.enable(
    client_name => 'auto optimizer stats collection', 
    operation => null, 
    window_name => null); 

When you want to disable automatic optimizer statistics collection, you can disable it using the DISABLE procedure in the DBMS_AUTO_TASK_ADMIN package. exec dbms_auto_task_admin.disable(
    client_name => 'auto optimizer stats collection', 
    operation => null, 
    window_name => null);
*/
col program_action for a41
col program_name for a30
col schedule_name for a30
col repeat_interval for a55
col duration for a13
col window_name for a16
col last_start_date for a42

@date

select task_name, status, cast(last_good_date as date) last_good_date, last_good_duration
from dba_autotask_task;
--where client_name = 'auto optimizer stats collection';

REM Next you can see how many members has the window group used by the automatic maintenace task.

select w.window_name, c.autotask_status, c.optimizer_stats, w.repeat_interval,  w.duration, w.last_start_date--, w.enabled , , w.next_start_date
from dba_autotask_window_clients c , dba_scheduler_windows w
where c.window_name = w.window_name
order by last_start_date desc;

select program_name,program_action, number_of_arguments, enabled
 from dba_scheduler_programs
where owner = 'SYS' 
  and program_action = 'dbms_stats.gather_database_stats_job_proc';

select job_name,program_name,schedule_name,enabled from dba_scheduler_jobs where program_name = 'GATHER_STATS_PROG';
  
