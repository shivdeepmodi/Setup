set verify off
undefine change
undefine restore_point_name
define change=&1
define restore_point_name=&2
column dbrole new_value dbrole
select replace(database_role,' ','_') dbrole from v$database;
column host_name new_value host_name
select substr(host_name,1,instr(host_name,'.',1)-1) host_name from v$instance;

prompt CREATE RESTORE POINT /*+ &&change &&_CONNECT_IDENTIFIER &&host_name &&dbrole*/ &&restore_point_name GUARANTEE FLASHBACK DATABASE;
CREATE RESTORE POINT /*+ &&change &&_CONNECT_IDENTIFIER &&host_name &&dbrole*/ &&restore_point_name GUARANTEE FLASHBACK DATABASE;

set verify on
