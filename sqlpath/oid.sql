set verify off
Column object_id              heading 'Object ID'     format 9999999
Column object_name            heading 'Object Name'   format a30
Column owner                  heading 'Owner'         format a10
Column object_type            heading 'Object Type'   format a15
Column status                 heading 'Status'        format a7
Column to_char(created)       heading 'Created'       format a20
Column to_char(last_ddl_time) heading 'Last DDL Time' format a20

select object_name, object_type, owner, status, to_char(created), to_char(last_ddl_time)
  from dba_objects where object_id = '&object_id'
/
set verify on
clear columns