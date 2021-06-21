set lines 300 colsep '|' termout off
column db_unique_name new_value db_unique_name
column host_name new_value host_name
column database_role new_value database_role
col DB_NAME for a20
column host_name for a20

select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name 
from gv$instance;
select database_role from v$database;

set verify off

set lines 300 colsep '|'
column db_unique_name new_value db_unique_name
column host_name new_value host_name
column database_role new_value database_role
col DB_NAME for a20
column host_name for a20

col value for a20
col Day for a3
col Hour for a4
col Min for a3
col Sec for a3

set timing on
select value as db_unique_name  from v$parameter where name = 'db_unique_name';

select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name
from gv$instance;

select database_role from v$database;
set echo off verify off termout &1
spool &2 replace
select '&&db_unique_name' as  DB_NAME,'&&database_role' database_role,'&&host_name' host_name
       ,name
       ,nvl(value,'MRP NOT RUNNING') value
           ,substr(value,2,3) Day
       ,substr(value,5,2) Hour
           ,substr(value,8,2) Min
           ,substr(value,11,2) Sec
           ,time_computed
           --from (select 'LAG' as name,'+12 22:33:44' as value from dual) where 1=1
  from V$DATAGUARD_STATS
 where name in ('transport lag','apply lag')
   and ( to_number(substr(value,2,3)) > 0 or to_number(substr(value,5,2)) > 1 or to_number(substr(value,8,2)) > 50
         or value is null
       )
           ;
spool off
set termout on
