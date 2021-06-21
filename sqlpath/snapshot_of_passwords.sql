REM Run this to store the passwords for all the users in the database

set head off feedback off trims on
spool revert_passwords_&&_CONNECT_IDENTIFIER..sql
PROMPT spool revert_passwords_&&_CONNECT_IDENTIFIER..lst
 --select 'alter user '||username||' identified by values '||''''||password||''''||';'
select 'alter user '||username||' identified '||decode(password,'EXTERNAL','EXTERNALLY','by values '||''''||password||'''')||';'
  from dba_users
 where username not in ('SYS','SYSTEM','RMAN','OUTLN','TSMSYS','DIP','DBM_USER','NCLDBA_UPD','XDB','PERFSTAT','ANONYMOUS')
   and username not like 'IMDD%';
  
 select 'alter user '||username||' profile '||profile||';'
  from dba_users
 where username not in ('SYS','SYSTEM','RMAN','OUTLN','TSMSYS','DIP','DBM_USER','NCLDBA_UPD','XDB','PERFSTAT','ANONYMOUS')
   and username not like 'IMDD%';
PROMPT spool off
spool off
prompt
prompt The file created is revert_passwords_&&_CONNECT_IDENTIFIER..sql
prompt
set head on feedback on