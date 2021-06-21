Accept object_type char prompt 'Give Object Type : '
Accept object_name char prompt 'Give Object Name : '
Accept owner       char prompt 'Give Owner       : '

column ddl format a300 word_wrapped

set feedback off termout off verify off head off
column upobj new_value upobj
select upper('&&object_type') upobj
  from dual;
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);  
set termout on

select dbms_metadata.get_ddl(upper('&&object_type'),upper('&&OBJECT_NAME'),upper('&&OWNER')) ddl FROM DUAL;
undefine object_type
undefine object_name
undefine owner
set termout off
execute DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',false);
set head on feedback on verify on head on termout on