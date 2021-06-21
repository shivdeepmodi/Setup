Accept table_name char prompt 'Give the table name :'
Accept owner char prompt 'Give the owner[default user] :' 
col owner new_value owner
set termout off verify off
select decode('&&owner',null,user,'&&owner') as owner from dual;
set termout on

Column table_name  heading    'Table Name'     format a20
Column index_name  heading    'Index Name'     format a20
Column column_name heading    'Column Name'    format a20

SELECT table_owner, table_name, index_name, column_name
  FROM dba_ind_columns
 WHERE table_name = upper('&&table_name')
   and table_owner = '&&owner'
/
set verify on
clear columns