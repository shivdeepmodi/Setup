set lines 300 colsep '|'
column db_unique_name new_value db_unique_name
column host_name new_value host_name
column database_role new_value database_role
col DB_NAME for a20
column host_name for a20
set timing on termout off
select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name 
from gv$instance;
select database_role from v$database;
set verify off termout &1
col name for a47
col time for a35
col GUARANTEE_FLASHBACK_DATABASE for a9
spool &2 replace
select '&&db_unique_name' db_name,'&&database_role','&&host_name' host_name,name,time,GUARANTEE_FLASHBACK_DATABASE from v$restore_point;
spool off

