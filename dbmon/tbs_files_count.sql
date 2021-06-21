column db_unique_name new_value db_unique_name
column host_name new_value host_name
col DB_NAME for a20
column database_role new_value database_role for a20
column host_name for a20
col datafile_count new_value datafile_count
set termout off lines 300 colsep '|' timing on
select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name
from gv$instance;
select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select database_role from v$database;
set verify off termout &1
spool &2 replace
select '&&db_unique_name' db_name,'&&database_role' database_role,'&&host_name' host_name,
       tablespace_name,count(*)
from dba_data_files
group by '&&db_unique_name' ,'&&database_role','&&host_name',tablespace_name
having count(*) > 1000
order by 1
/
spool off
