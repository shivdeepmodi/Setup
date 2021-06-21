REM --Run to create the script to drop all the  database links
set head off feedback off trims on verify off escape '\'
break on link_owner
spool drop_db_links_&&_CONNECT_IDENTIFIER..sql
PROMPT spool drop_db_links_&&_CONNECT_IDENTIFIER..lst
prompt accept nclpass char prompt 'Give Password for NCLDBA:' hide

select decode(owner,'PUBLIC','CONNECT NCLDBA/\&\&nclpass@'||'&&_CONNECT_IDENTIFIER'
                   ,'NCLDBA','CONNECT NCLDBA/\&\&nclpass@'||'&&_CONNECT_IDENTIFIER' 
                           ,'CONNECT '||owner||'/timepass@'||'&&_CONNECT_IDENTIFIER') link_owner,
       decode(owner,'PUBLIC',chr(10)||'DROP PUBLIC DATABASE LINK ',chr(10)||'DROP DATABASE LINK ')|| db_link||';'
   from dba_db_links;
   
PROMPT spool off
spool off

set head on feedback on verify on escape off
clear breaks