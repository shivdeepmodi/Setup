col BEGIN_INTERVAL_TIME for a30
col END_INTERVAL_TIME for a30
select  i.instance_name, begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
round((elapsed_time_delta/decode(nvl(executions_delta,0),0,1,decode(nvl(executions_delta,0),0,1,executions_delta)))/1000000, 2) avg_etime,
round((buffer_gets_delta/decode(nvl(executions_delta,0),0,1,decode(nvl(executions_delta,0),0,1,executions_delta))),2) avg_lio,
round((disk_reads_delta/decode(nvl(executions_delta,0),0,1,decode(nvl(executions_delta,0),0,1,executions_delta))),2) avg_pio
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS, GV$instance i
where sql_id = '&sql_id'   
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and i.instance_number = s.instance_number
--and executions_delta > 0
and ss.begin_interval_time >= sysdate - 90
order by 2 asc;
