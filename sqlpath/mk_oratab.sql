set termout off
col instance_name new_value instance_name
select instance_name from v$instance
/
set termout on head off feedback off trims on  verify off pages 0
col oratab for a90
select '&&INSTANCE_NAME'||':'||SYS_CONTEXT ('USERENV','ORACLE_HOME')||':'||'N' oratab from dual;
set head on feed on  verify on
 
