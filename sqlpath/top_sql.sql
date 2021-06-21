Column Module for a20
Column SQL     newline
Column object_status newline
Column optimizer_mode for a14

Accept id number prompt 'Order SQL by? [CPU|Disk Reads|Buffer Gets|Executions] : '

select * from (
select (cpu_time/1000000) "CPU_Seconds",
       disk_reads "Disk_Reads",
       buffer_gets "Buffer_Gets",
       executions "Executions",
--       case when rows_processed = 0 then null
--       else (buffer_gets/nvl(replace(rows_processed,0,1),1))
--        end "Buffer_gets/rows_proc",
--       (buffer_gets/nvl(replace(executions,0,1),1)) "Buffer_gets/executions",
       (elapsed_time/1000000) "Elapsed_Seconds",
       module "Module",
--         OBJECT_STATUS,
--         IS_OBSOLETE,
--         PLAN_HASH_VALUE,
--         OPTIMIZER_MODE,
--         OPTIMIZER_COST,
       sql_id "SQL"
  from v$sql s
 order by &&id desc nulls last
)
where rownum <=10
/
