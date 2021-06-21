undefine sql_id
set verify off
col name for a10
col VALUE_STRING for a30
col DATATYPE_STRING for a20
col bind_data new_value bind_data for a120

select sql_id,plan_hash_value,child_number,bind_data from v$sql where sql_id = '&&sql_id';

select sql_id,plan_hash_value,child_number,bind_data from v$sql where sql_id = '&&sql_id' and child_number = &child_number;

SELECT NAME,POSITION,DATATYPE,DATATYPE_STRING,VALUE_STRING, LAST_CAPTURED
FROM TABLE(DBMS_SQLTUNE.EXTRACT_BINDS('&&bind_data'))
;
