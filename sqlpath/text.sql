accept owner char prompt       'Give Owner:'
accept object_type char prompt 'Give Object Type:'
col ddl format a300 word_wrapped print
set head off feedback off lines 300 verify off
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);  
spool &&owner._&1._&&_CONNECT_IDENTIFIER..sql
select dbms_metadata.get_ddl(upper('&&object_type'),upper('&&1'),upper('&&OWNER')) ddl FROM DUAL;
spool off
set head on feedback on lines 300 verify on termout off
undefine object_type 
undefine owner
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',false);  
set termout on