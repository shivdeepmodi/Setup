col log_date for a20
col job_name for a22
col status for a9
col ACTUAL_START_DATE for a20
col REQ_START_DATE for a20
col run_duration for a13
select job_name, status,
--       trunc(log_date) log_date ,substr(log_Date,11,8) time,substr(log_Date,27,10) zone,
       cast (log_date as date) log_date ,
       --trunc(REQ_START_DATE)||' '||substr(REQ_START_DATE,11,8)||' '||substr(REQ_START_DATE,27,10) REQ_START_DATE,
	   cast (REQ_START_DATE as date) REQ_START_DATE,
	   --trunc(ACTUAL_START_DATE)||' '||substr(ACTUAL_START_DATE,11,8)||' '||substr(ACTUAL_START_DATE,27,10) ACTUAL_START_DATE,
	   cast (ACTUAL_START_DATE as date) ACTUAL_START_DATE,
	   RUN_DURATION 
  from DBA_SCHEDULER_JOB_RUN_DETAILS
 order by job_name,log_date
/
