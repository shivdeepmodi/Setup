/*

SR Number 6459604.992

Create this view to find all the jobs submitted via dbms_jobs/dbms_scheduler

create view jobs ( JOB_ID,
OWNER,
JOB_NAME,
JOB_SUBNAME,
SESSION_ID,
SLAVE_PROCESS_ID,
SLAVE_OS_PROCESS_ID,
RUNNING_INSTANCE,
RESOURCE_CONSUMER_GROUP,
ELAPSED_TIME,
CPU_USED
) as (
SELECT j.obj#, ju.name, jo.name, jo.subname, rj.session_id, vp.pid,
rj.os_process_id, rj.inst_id, vse.resource_consumer_group,
CAST (systimestamp-j.last_start_date AS INTERVAL DAY(3) TO SECOND(2)) ,
rj.session_stat_cpu
FROM
sys.scheduler$_job j JOIN sys.obj$ jo ON (j.obj# = jo.obj#)
JOIN sys.user$ ju ON (jo.owner# = ju.user#)
LEFT OUTER JOIN gv$scheduler_running_jobs rj ON (rj.job_id = j.obj#)
LEFT OUTER JOIN gv$session vse ON
(rj.session_id = vse.sid AND rj.session_serial_num = vse.serial#)
LEFT OUTER JOIN gv$process vp ON
(rj.paddr = vp.addr AND rj.inst_id = vp.inst_id)
);
*/

Column job_id   heading JOB_ID        format 9999999
Column owner    heading Owner         format a20
Column job_name heading 'Job Name'    format a25
Column subname  heading 'Job Subname' format a20
Column session_id heading 'Session ID' format 9999999
Column elapsed_time heading 'Elapsed Time' format a20

SELECT j.obj# job_id, ju.name owner, jo.name job_name,
       CAST (systimestamp-j.last_start_date AS INTERVAL DAY(3) TO SECOND(2)) elapsed_time
  FROM sys.scheduler$_job j JOIN sys.obj$ jo ON (j.obj# = jo.obj#)
  JOIN sys.user$ ju ON (jo.owner# = ju.user#)
  LEFT OUTER JOIN gv$scheduler_running_jobs rj ON (rj.job_id = j.obj#)
  LEFT OUTER JOIN gv$session vse ON (rj.session_id = vse.sid AND rj.session_serial_num = vse.serial#)
  LEFT OUTER JOIN gv$process vp  ON (rj.paddr = vp.addr AND rj.inst_id = vp.inst_id)
 ORDER BY job_id
/

clear columns