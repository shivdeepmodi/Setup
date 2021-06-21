undefine sql_id
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
Column snapshot_time format a20
Column ROWS_PROCESSED_TOTAL heading 'ROWS|PROCESSED|TOTAL' format 999999999999
column tpe heading 'TIME|PER|EXECUTION' 
Column OPTIMIZER_COST heading 'OPTIMIZER|COST'
Column SQL_PROFILE format a10

set termout off
select case when '&&begin_time' is null or '&&end_time' is null then '1=1'
             else 'b.begin_interval_time between to_date('||''''||'&begin_time'||''''||') and to_date('||''''||'&end_time'||''''||')'
        end clause
  from dual;
set termout on


select cast(b.BEGIN_INTERVAL_TIME as date) snapshot_time,a.sql_id, 
       a.plan_hash_value, round(a.ELAPSED_TIME_TOTAL/1000000,2) ELAPSED,
       round(a.ELAPSED_TIME_TOTAL/decode(a.EXECUTIONS_TOTAL/1000000,0,1,a.EXECUTIONS_TOTAL/1000000),3) tpe, 
       a.EXECUTIONS_TOTAL EXECUTIONS
           --, a.executions_delta
           ,a.ROWS_PROCESSED_TOTAL
           ,a.OPTIMIZER_COST
           ,a.sql_profile 
  from dba_hist_sqlstat a, dba_hist_snapshot b 
 where a.snap_id=b.snap_id
 and a.sql_id='&&sql_id'
 and &&clause
 order by 1
/

select trunc(cast(b.BEGIN_INTERVAL_TIME as date)) snapshot_time,a.sql_id, 
       a.plan_hash_value, 
           round(sum(a.ELAPSED_TIME_TOTAL/1000000),2) ELAPSED_TOT,
       round(avg(round(a.ELAPSED_TIME_TOTAL/a.EXECUTIONS_TOTAL/1000000,3)),2) AVG_ELA_EXE, 
       sum(a.EXECUTIONS_TOTAL) EXECUTIONS_TOT
           --, a.executions_delta
           ,sum(a.ROWS_PROCESSED_TOTAL) ROW_PROCESSED_TOT
--         ,a.OPTIMIZER_COST
        --   ,a.sql_profile 
  from dba_hist_sqlstat a, dba_hist_snapshot b 
 where a.snap_id=b.snap_id
 and a.sql_id='&&sql_id'
 group by trunc(cast(b.BEGIN_INTERVAL_TIME as date)) ,a.sql_id, a.plan_hash_value
 order by 1
/
set verify on
