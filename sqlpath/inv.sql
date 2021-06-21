Column object_name   heading 'Object Name'   format a30
Column object_type   heading 'Object Type'   format a20
Column owner         heading 'Owner'         format a19
Column status        heading 'Status'        format a7
Column created       heading 'Created'       format a20
Column last_ddl_time heading 'Last DDL Time' format a20

select object_name, object_type, owner, status, created, last_ddl_time 
  from dba_objects 
 where status = 'INVALID'
 order by object_name, owner
/
--clear columns