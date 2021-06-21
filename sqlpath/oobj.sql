set verify off
Accept owner char prompt 'Give owner[user]: '
Column object_id     heading 'Object ID'     format 9999999
Column object_name   heading 'Object Name'   format a30
Column owner         heading 'Owner'         format a15
Column object_type   heading 'Object Type'   format a15
Column status        heading 'Status'        format a7
Column to_char(created)       heading 'Created'       format a20
Column to_char(last_ddl_time) heading 'Last DDL Time' format a20
col owner new_value owner

set termout off
select decode('&&owner',null,user,'&&owner') as owner from dual;
set termout on


select object_id,object_name, object_type, owner, status, to_char(created) , to_char(last_ddl_time)
  from dba_objects 
 where owner = upper(trim('&&owner'))
 order by object_name;

set verify on