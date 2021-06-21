prompt
prompt
prompt Finds inefficients sql by computing ratio of logical_reads to rows_processed. First page should probably print bad stuff. 
prompt Returns data for SELECT, INSERT, UPDATE AND DELETE ONLY
prompt This is just a start for investigation and might not be reliable eg:-
prompt
prompt 1. Query performing index lookup by visting large no of blocks and returning only one row
prompt 2. SQL is not in cache
prompt 3. SQL hurting business is not listed on top of report


col dr heading PIO
col bg heading LIO
col exe heading runs
col rp heading rows
col rpr heading LIO/row
col rpe heading LIO/run

set pagesize 50
set pause on
set pause 'More: '


select hash_value,
sum(disk_reads) dr,
sum(buffer_gets) bg,
sum(rows_processed) rp,
sum(buffer_gets)/greatest(sum(rows_processed),1) rpr,
sum(executions) exe,
sum(buffer_gets)/greatest(sum(executions),1) rpe
from v$sql
where command_type in (2,3,6,7)
group by hash_value
order by 5 desc;
set pagesize 10000
set pause off

