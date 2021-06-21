Accept username char prompt 'Give the username :'
set head off verify off feedback off
spool &&_connect_identifier._&&username._password.lst
select 'alter user &&username identified '||decode(password,'EXTERNAL','EXTERNALLY','by values '||''''||password||'''')||' profile '||profile||';'
  from dba_users
 where username = upper('&&username')
/
spool off
set head on verify on feedback on
prompt
prompt password file is &&_connect_identifier._&&username._password.lst
prompt