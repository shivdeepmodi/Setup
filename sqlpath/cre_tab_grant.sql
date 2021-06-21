set head off feedback off verify off
Accept table_owner char prompt 'Give owner of the table:'
Accept table_name  char prompt 'Give table name        :'

spool &&_connect_identifier._create_grant_&&table_owner._&&table_name..sql
prompt spool &&_connect_identifier._create_grant_&&table_owner._&&table_name..lst
select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||';'
  from dba_tab_privs
 where table_name = upper('&table_name')
   and owner = upper('&table_owner')
/
prompt spool off
spool off
prompt 
prompt The file is &&_connect_identifier._create_grant_&&table_owner._&&table_name..sql
set head on feedback on verify on