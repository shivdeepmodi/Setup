col sql_text for a300
undefine sql_id
set define off timing off heading off feedback off termout off verify off
select 'select inst_id,sql_id,reason_not_shared, count(*) cursors, count(distinct sql_id) sql_ids
from gv$sql_shared_cursor
unpivot(val for reason_not_shared in(
' 
|| listagg(
  '  '||listagg(column_name,',') within group (order by column_id) ,
  ',
') within group(order by line_no)
||'
))
where val = ''Y''
and sql_id = ''&&sql_id''
group by inst_id,sql_id,reason_not_shared
order by 2 desc, 3, 1;' as sql_text
from (
  select column_name,
  column_id,
  ceil(row_number() over(order by column_id) / 4) line_no
  from dba_tab_columns where owner = 'SYS' and table_name = 'V_$SQL_SHARED_CURSOR'
  and data_length = 1
)
group by line_no
.
spool /tmp/zzsql_cursor_mismatch.sql
/
spool off
set define on timing on heading on feedback on termout on
select inst_id,sql_id,plan_hash_value,PARSING_SCHEMA_NAME,parse_calls,child_number from gv$sql where sql_id ='&&sql_id';
@/tmp/zzsql_cursor_mismatch.sql
set verify on
undefine sql_id
