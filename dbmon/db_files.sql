set termout off  lines 300 verify off


column db_unique_name new_value db_unique_name for a20
column host_name new_value host_name
col DB_NAME for a20
column database_role new_value database_role for a20
column host_name for a20
col param_name for a10
col max_dbfiles new_value max_dbfiles heading MAX_DBFILES  for 99999
col datafile_count new_value datafile_count

select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name
from gv$instance;
select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select database_role from v$database;
select value as max_dbfiles from v$parameter where name = 'db_files';
select count(*) datafile_count from v$datafile;

set colsep '|'
set termout &1
spool &2 replace
select '&&db_unique_name' db_name,'&&database_role' database_role,'&&host_name' host_name,
       'db_files' as param_name,&&max_dbfiles as max_dbfiles,&&datafile_count as datafile_count,(&&max_dbfiles-&&datafile_count) DATAFILES_CAN_BE_ADDED
from dual 
where &&max_dbfiles-&&datafile_count < 20
/
spool off
set termout on
