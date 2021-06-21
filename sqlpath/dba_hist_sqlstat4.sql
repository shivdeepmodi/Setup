Accept begin_time char prompt 'Give begin_interval_time[DD-MON-YYYY HH24:MI:SS]:'
Accept end_time char prompt 'Give begin_interval_time[DD-MON-YYYY HH24:MI:SS]:'
 
 
Column clause  new_value clause
 
set termout off
select case when '&&begin_time' is null or '&&end_time' is null then '1=1'
             else 's.begin_interval_time between to_date('||''''||'&begin_time'||''''||') and to_date('||''''||'&end_time'||''''||')'
        end clause
  from dual;
set termout on
 
column sample_end format a21
select to_char(min(s.end_interval_time),'DD-MON-YYYY DY HH24:MI') sample_end
, q.sql_id
, q.plan_hash_value
, sum(q.EXECUTIONS_DELTA) executions
, round(sum(DISK_READS_delta)/greatest(sum(executions_delta),1),1) pio_per_exec
, round(sum(BUFFER_GETS_delta)/greatest(sum(executions_delta),1),1) lio_per_exec
, round((sum(ELAPSED_TIME_delta)/greatest(sum(executions_delta),1)/1000),1) msec_exec
from dba_hist_sqlstat q, dba_hist_snapshot s
where q.SQL_ID=trim('&sql_id.')
and s.snap_id = q.snap_id
and s.dbid = q.dbid
and s.instance_number = q.instance_number
and &&clause
group by s.snap_id
, q.sql_id
, q.plan_hash_value
order by s.snap_id, q.sql_id, q.plan_hash_value
/