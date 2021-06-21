set head off feedback off verify off
Accept role char prompt 'Give role:'

spool &&_connect_identifier._create_grant_&&role..sql
prompt spool &&_connect_identifier._create_grant_&&role..lst
select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||';'
  from dba_tab_privs
 where grantee = upper('&role')
/

select 'grant '||privilege||' to '||grantee||';'
  from dba_sys_privs
 where grantee = upper('&role')
/

select 'grant '||granted_role||' to '||grantee||';'
  from dba_role_privs
 where grantee = upper('&role')
/

prompt spool off
spool off
prompt 
prompt The file is &&_connect_identifier._create_grant_&&role..sql
set head on feedback on verify on