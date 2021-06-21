Column owner    heading 'Owner'     format a15
Column job_name heading 'Job Name'  format a25
Column status   heading 'Status'    format a10
Column lastdate heading 'Last Date' format a20
Column count(*) heading 'Count'     format 999
select owner,job_name,status,to_char(max(log_date),'DD-MON-YYYY HH24:MI:SS') lastdate,count(*)
  from dba_scheduler_job_log a
 group by owner,job_name,status
having max(log_date) >= (select max(log_date) from dba_scheduler_job_log b where b.job_name = a.job_name) 
 order by owner,job_name,status
/
clear columns