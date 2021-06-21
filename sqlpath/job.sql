Column what        heading 'What'      format a70 newline
Column job         heading 'Job'       format 999999999
Column failures    heading 'Failures'  format 999
Column broken      heading 'Broken'    format a6
Column schema_user heading 'Job owner' format a15 
Column next_date   heading 'Next Date' format a20
Column last_date   heading 'Last Date' format a20
Column interval    heading 'Interval'  format a60 newline
Column sysdate     heading 'Sysdate'   format a20


select job,broken,schema_user,failures,next_date,last_date,sysdate,what,interval
  from dba_jobs;

--clear columns