select a.sql_id, a.plan_hash_value, b.begin_interval_time, a.EXECUTIONS_TOTAL, a.executions_delta, a.sql_profile 
  from dba_hist_sqlstat a, dba_hist_snapshot b 
 where a.snap_id=b.snap_id
   and a.sql_id='&sql_id'
 order by begin_interval_time
/