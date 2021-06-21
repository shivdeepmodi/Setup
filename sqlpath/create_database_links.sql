set head off feedback off trims on verify off escape '\'
break on link_owner
column db_link format a300 word_wrapped
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);

spool recreate_db_links_&&_CONNECT_IDENTIFIER..sql
prompt accept nclpass char prompt 'Give Password for NCLDBA_UPD:' hide
REM
REM --Run to create the script to create all the database links
REM
PROMPT spool recreate_db_links_&&_CONNECT_IDENTIFIER..lst


select decode(owner,'PUBLIC','CONNECT NCLDBA_UPD/\&\&nclpass@'||'&&_CONNECT_IDENTIFIER'
                   ,'NCLDBA_UPD','CONNECT NCLDBA_UPD/\&\&nclpass@'||'&&_CONNECT_IDENTIFIER'
                           ,'CONNECT '||owner||'/timepass@'||'&&_CONNECT_IDENTIFIER') link_owner,
       dbms_metadata.get_ddl('DB_LINK',db_link,owner)  db_link
  from dba_db_links
/
 
PROMPT spool off
spool off
set head on feedback on verify on escape off termout off
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',false);
set termout on
clear breaks
