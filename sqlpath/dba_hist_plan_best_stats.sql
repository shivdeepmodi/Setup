-- Following query from dba_hist_sqlstat can retrieve the list of SQL IDs whose plans have changed. 
-- It orders the SQL IDs,so that those SQL IDs for which maximum gains can be achieved by fixing plan, are listed first.
-- https://blog.pythian.com/pro-active-awr-data-mining-to-find-change-in-sql-execution-plan/
--
set numformat 999,999,999
column plan_hash_value format 99999999999999
column min_snap format 999999
column max_snap format 999999
column min_avg_ela format 999,999,999,999,999
column avg_ela format 999,999,999,999,999
column ela_gain format 999,999,999,999,999
select sql_id,
       min(min_snap_id) min_snap,
       max(max_snap_id) max_snap,
       max(decode(rw_num,1,plan_hash_value)) plan_hash_value,
       max(decode(rw_num,1,avg_ela)) min_avg_ela,
       avg(avg_ela) avg_ela,
       avg(avg_ela) - max(decode(rw_num,1,avg_ela)) ela_gain,
       -- max(decode(rw_num,1,avg_buffer_gets)) min_avg_buf_gets,
       -- avg(avg_buffer_gets) avg_buf_gets,
       max(decode(rw_num,1,sum_exec))-1 min_exec,
       avg(sum_exec)-1 avg_exec
from (
  select sql_id, plan_hash_value, avg_buffer_gets, avg_ela, sum_exec,
         row_number() over (partition by sql_id order by avg_ela) rw_num , min_snap_id, max_snap_id
  from
  (
    select sql_id, plan_hash_value , sum(BUFFER_GETS_DELTA)/(sum(executions_delta)+1) avg_buffer_gets,
    sum(elapsed_time_delta)/(sum(executions_delta)+1) avg_ela, sum(executions_delta)+1 sum_exec,
    min(snap_id) min_snap_id, max(snap_id) max_snap_id
    from dba_hist_sqlstat a
    where exists  (
       select sql_id from dba_hist_sqlstat b where a.sql_id = b.sql_id
         and  a.plan_hash_value != b.plan_hash_value
         and  b.plan_hash_value > 0 
         and b.sql_id = '&sql_id')
    and plan_hash_value > 0
    group by sql_id, plan_hash_value
    order by sql_id, avg_ela
  )
  order by sql_id, avg_ela
  )
group by sql_id
having max(decode(rw_num,1,sum_exec)) > 1
order by 7 desc
/
spool off
clear columns
set numformat 9999999999
