set termout off lines 300 trimspool on
column db_unique_name new_value db_unique_name
column host_name new_value host_name
col DB_NAME for a20
column database_role new_value database_role
column host_name for a20
set termout off lines 300 colsep '|' timing on
select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name 
from gv$instance;
select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select database_role from v$database;
set verify off
--select '&&db_unique_name' db_name,'&&database_role' database_role,'&&host_name' host_name, fr.* 
set termout &1
spool &2 replace
select '&&db_unique_name' db_name,'&&database_role' database_role,'&&host_name' host_name, 
       sum(PERCENT_SPACE_USED) PERCENT_SPACE_USED,sum(PERCENT_SPACE_RECLAIMABLE ) PERCENT_SPACE_RECLAIMABLE 
from v$flash_Recovery_area_usage fr 
where exists(select sum(PERCENT_SPACE_USED) from v$flash_recovery_area_usage having sum(PERCENT_SPACE_USED) > 70)
and PERCENT_SPACE_USED<>0
group by '&&db_unique_name','&&database_role','&&host_name'
/
spool off
set termout on
