set verify off heading off feedback off

accept schema_owner prompt 'Enter value for object owner : '

spool &&schema_owner._grants_&&_connect_identifier..sql

select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||';'
  from dba_tab_privs
 where owner = '&schema_owner'
/

spool off
set heading on feedback on verify on
