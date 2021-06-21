REM Run this to temporily change the passwords for all the users in the database to timepass

set head off feedback off trims on
spool change_password_to_timepass_&&_CONNECT_IDENTIFIER..sql
PROMPT spool change_password_to_timepass_&&_CONNECT_IDENTIFIER..lst
 select 'alter user '||username||' profile default;'
  from dba_users
 where username not in ('SYS','SYSTEM','RMAN','OUTLN','TSMSYS','DIP','DBSNMP','DBM_USER','NCLDBA','NCLDBA_UPD','XDB','PERFSTAT','ANONYMOUS')
   and username not like 'IMDD%';
      
 select 'alter user '||username||' identified by timepass;'
  from dba_users
 where username not in ('SYS','SYSTEM','RMAN','OUTLN','TSMSYS','DIP','DBSNMP','DBM_USER','NCLDBA','NCLDBA_UPD','XDB','PERFSTAT','ANONYMOUS')
   and username not like 'IMDD%';
  
PROMPT spool off
spool off
set head on feedback on
prompt 
prompt The sql file created is change_password_to_timepass_&&_CONNECT_IDENTIFIER..sql
prompt