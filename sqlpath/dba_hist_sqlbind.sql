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
Column name heading 'PARAM|NAME' format a10
Column position heading POSITION format 9999999
Column VALUE_STRING format a30
Column datatype_string format a13
Column POSITION heading POS for 99

set termout off
select case when '&&begin_time' is null or '&&end_time' is null then '1=2'
             else 'b.begin_interval_time between to_date('||''''||'&begin_time'||''''||') and to_date('||''''||'&end_time'||''''||')'
        end clause
  from dual;
set termout on


select cast(b.BEGIN_INTERVAL_TIME as date) snapshot_time,a.sql_id, 
       --last_captured,
       a.plan_hash_value, 
	   round(a.ELAPSED_TIME_TOTAL/1000000,2) ELAPSED,
       --round(a.ELAPSED_TIME_TOTAL/decode(a.EXECUTIONS_TOTAL/1000000,0,1,a.EXECUTIONS_TOTAL/1000000),3) tpe, 
       a.EXECUTIONS_TOTAL EXECUTIONS
	   --, a.executions_delta
	   ,a.ROWS_PROCESSED_TOTAL
	   --,a.OPTIMIZER_COST
	   --,a.sql_profile 
	   ,c.name
	   ,c.position
	   ,was_captured
	   ,substr(c.datatype_string,1,13) datatype_string
	   ,value_string
  from dba_hist_sqlstat a, dba_hist_snapshot b, dba_hist_sqlbind c
 where a.snap_id=b.snap_id
 and a.snap_id = b.snap_id
 and a.sql_id = c.sql_id
 and a.sql_id='&&sql_id'
 and b.begin_interval_time between to_date('&begin_time') and to_date('&end_time')
 and c.last_captured between to_date('&begin_time') + 15/24*60 and to_date('&end_time') + 15/24*60
 order by 1
/

set verify on