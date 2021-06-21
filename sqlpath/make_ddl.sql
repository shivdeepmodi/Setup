define object_type=&1
define object_name=&2
define owner=&3

column ddl format a300 word_wrapped

set feedback off termout off verify off head off
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);
set termout on

select dbms_metadata.get_ddl(upper('&&object_type'),'&&object_name',decode('&&owner','SYS',NULL,'&&owner')) ddl FROM DUAL
/
set termout off
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',false);
set head on feedback on verify on head on termout on