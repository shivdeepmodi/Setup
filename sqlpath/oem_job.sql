undefine job_name
undefine target_name
accept job_name char prompt 'Give jobname:'

col job_owner for a15
col target_name for a25
col JOB_DESCRIPTION for a80
col job_name for a50
col start_time for a10
col status for a20
col days for a45
set verify off
select j.job_name,j.job_owner,substr(t.target_name,1,25) target_name,j.schedule_type,j.days,j.execution_hours||':'||j.execution_minutes START_TIME 
from sysman.MGMT$JOBS j, sysman.MGMT$JOB_TARGETS t
where upper(j.job_name) like upper('%&&job_name%')
  and j.job_name = t.job_name
  and j.job_owner = t.job_owner;
  

select job_name,job_owner,job_description from sysman.MGMT$JOBS where upper(job_name) like '%&&job_name%' order by start_time;

select job_owner,job_name,substr(TARGET_NAME,1,25) target_name,start_time,status 
from sysman.MGMT$JOB_EXECUTION_HISTORY where upper(job_name) like upper('%&&job_name%') 
and lower(target_name) like lower('&target_name%')
--and trunc(start_time) > trunc(sysdate) -14 
order by start_time;
set verify on
