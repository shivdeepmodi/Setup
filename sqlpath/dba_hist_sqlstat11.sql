undefine sql_id
@date
set verify off
Prompt Session Details for the user connected between specific time interval.
Prompt ===================================================================
Prompt select sql_id,sql_plan_hash_value,SAMPLE_TIME
Prompt   from DBA_HIST_ACTIVE_SESS_HISTORY
Prompt  where user_id = 5339
Prompt    and CAST(sample_time AS DATE) between to_date('10-FEB-2011 13:45:00') and to_date('10-FEB-2011 14:15:00')
Prompt ===================================================================
Accept begin_time char prompt 'Give begin_interval_time[DD-MON-YYYY HH24:MI:SS]:'
Accept end_time char prompt 'Give begin_interval_time[DD-MON-YYYY HH24:MI:SS]:'

Column clause  new_value clause

col ELAPSED_TIME_DELTA heading 'ELAPSED|TIME|DELTA(Sec)'
col END_INTERVAL_TIME for a25
col PARSING_SCHEMA_NAME for a14
col END_OF_FETCH_COUNT_DELTA heading 'END|OF|FETCH|COUNT|DELTA'
col ROWS_PROCESSED_DELTA heading 'ROWS|PROCESSED|DELTA'
col END_OF_FETCH_COUNT_TOTAL heading 'END|OF|FETCH|COUNT|TOTAL'
col sql_profile for a15 trunc
col snap_id for 999999

set termout off
select case when '&&begin_time' is null or '&&end_time' is null then '1=1'
             else 'b.begin_interval_time between to_date('||''''||'&begin_time'||''''||') and to_date('||''''||'&end_time'||''''||')'
        end clause
  from dual;
set termout on

SELECT i.instance_name,cast(SS.END_INTERVAL_TIME as date) END_INTERVAL_TIME,STAT.SNAP_ID ,STAT.SQL_ID, PLAN_HASH_VALUE, 
--PARSING_SCHEMA_NAME, 
round(ELAPSED_TIME_DELTA/1000000,2) ELAPSED_TIME_DELTA,
executions_delta,executions_total,ROWS_PROCESSED_DELTA,
substr(sql_profile,1,20) sql_profile,
END_OF_FETCH_COUNT_DELTA
FROM DBA_HIST_SQLSTAT STAT, DBA_HIST_SQLTEXT TXT, DBA_HIST_SNAPSHOT SS , GV$instance i
WHERE STAT.SQL_ID = TXT.SQL_ID 
  AND i.inst_id = STAT.instance_number
  AND STAT.DBID = TXT.DBID 
  AND SS.DBID = STAT.DBID 
  AND SS.INSTANCE_NUMBER = STAT.INSTANCE_NUMBER 
  AND STAT.SNAP_ID = SS.SNAP_ID 
  --AND STAT.INSTANCE_NUMBER = 1 
  AND STAT.SQL_ID = '&&sql_id' 
  AND END_OF_FETCH_COUNT_DELTA <>0
  ---AND executions_delta <>0
--AND trunc(SS.END_INTERVAL_TIME) = trunc(sysdate) 
 and &&clause
ORDER BY SS.END_INTERVAL_TIME
/

