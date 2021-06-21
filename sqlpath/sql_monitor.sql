alter session set nls_Date_format='DD-MON-YYYY HH24:MI:SS'
/
col SERVICE_NAME for a20
col status for a10
col sid for 99999
col serial# for 99999
col SERVICE_NAME for a15 trunc
col module for a17
col action for a17
col username for a15
select inst_id,sid,SESSION_SERIAL# serial#,username,SERVICE_NAME,sql_id,SQL_PLAN_HASH_VALUE,SQL_EXEC_START,
module,action,
--FIRST_REFRESH_TIME,LAST_REFRESH_TIME,
PROGRAM,PROCESS_NAME,STATUS,ELAPSED_TIME/100000 elapsed_secs
from gv$sql_monitor where status not like 'DONE%' order by elapsed_time desc;

