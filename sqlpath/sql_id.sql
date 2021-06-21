undefine sql_id
define sql_id=&1
undefine inst_id
col sql_profile for a20
set verify off timing off
col first_load_time for a30
col is_bind_aware heading 'BIND|AWARE' for a5
col is_bind_sensitive heading 'BIND|SENS|ITIVE' for a5
col IS_SHAREABLE heading 'IS|SHARE|ABLE' for a5
col plan_hash_value for 9999999999 heading PHV
col PARSING_SCHEMA_NAME for a10 heading 'PARSE|SCHEMA' trunc
col child_number heading 'CHILD|NO' for 9999
col sql_patch for a20
col SQL_PLAN_BASELINE for a10 trunc
col ROWS_PROCESSED heading ROWS
col inst_id heading INST for 9
col users_executing heading 'USERS|EXECU' for 999

alter session set nls_date_format='DD-MON-YY HH24:MI:SS';

select inst_id,PARSING_SCHEMA_NAME,child_number,sql_id,PLAN_HASH_VALUE,IS_SHAREABLE,is_bind_aware,is_bind_sensitive,SQL_PROFILE,
sql_patch,SQL_PLAN_BASELINE, PLAN_HASH_VALUE,last_active_time
--,FIRST_LOAD_TIME
from gv$sql where sql_id = '&&sql_id'
order by last_active_time,inst_id,child_number
/

select  inst_id,sql_id,child_number,
        ROUND(cpu_time/1000000,3) total_cpu_sec,
        ROUND(elapsed_time/1000000,3) total_ela_sec,
  user_io_wait_time/1000000 total_iowait_sec,
        buffer_gets total_LIOS,
        disk_reads total_pios,last_active_time
from gv$sql
where sql_id = ('&&sql_id')
order by last_active_time,inst_id, child_number
/

select
        child_number,
        --plan_hash_value plan_hash,
        parse_calls parses,
        loads h_parses,
        executions,
        fetches,
        rows_processed,
        round(rows_processed/nullif(fetches,0),2) rows_per_fetch,
        ROUND(cpu_time/NULLIF(executions,0)/1000000,3)     cpu_sec_exec,
        ROUND(elapsed_time/NULLIF(executions,0)/1000000,3) ela_sec_exec,
        ROUND(buffer_gets/NULLIF(executions,0),3)  lios_per_exec,
        ROUND(disk_reads/NULLIF(executions,0),3)   pios_per_exec,
        sorts
--      address,
--      sharable_mem,
--      persistent_mem,
--      runtime_mem,
--   , PHYSICAL_READ_REQUESTS
--   , PHYSICAL_READ_BYTES
--   , PHYSICAL_WRITE_REQUESTS
--   , PHYSICAL_WRITE_BYTES
--   , IO_CELL_OFFLOAD_ELIGIBLE_BYTES
--   , IO_INTERCONNECT_BYTES
--   , IO_CELL_UNCOMPRESSED_BYTES
--   , IO_CELL_OFFLOAD_RETURNED_BYTES
  ,     users_executing
  , last_active_time
       -- , address               parent_handle
       -- , child_address   object_handle
from gv$sql
where sql_id = ('&&sql_id')
order by last_active_time,inst_id, child_number
/


Prompt  SQL can show how many times the SQL statement was executed, organized into three buckets for each child cursor
--Prompt
--select * from GV$SQL_CS_HISTOGRAM where sql_id ='&&sql_id' and child_number=&&child_number and inst_id=&&inst_id;

--Prompt
--Prompt Shows the selectivity of the different values passed to the bind variable.
--Prompt

--select * from GV$SQL_CS_SELECTIVITY where sql_id = '&&sql_id' and child_number=&&child_number and inst_id=&&inst_id;

--Prompt
Prompt SQL can shows shows the activities by the cursors marked either Bind-Aware or Bind-Sensitive.
--Prompt
--select * from GV$SQL_CS_STATISTICS where sql_id = '&&sql_id' and child_number=&&child_number and inst_id=&&inst_id;

accept get_sql_text char prompt 'Get SQL Text[y|n]: ' default n
--define get_sql_text=n

declare
   my_var long;
begin
   for x in ( select sql_fulltext from gv$sqlarea where  sql_id = '&&sql_id' and '&&get_sql_text'='y') 
   loop
       my_var := dbms_lob.substr( x.sql_fulltext, 32000, 1 );
   end loop;
   dbms_output.put_line(my_var);
end;
/
set verify on timing on
