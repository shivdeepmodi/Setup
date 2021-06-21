set verify off

Accept object_name char prompt 'Give object_name:'

Column object_id     heading 'Object ID'     format 9999999
Column object_name   heading 'Object Name'   format a30
Column owner         heading 'Owner'         format a19
Column object_type   heading 'Object Type'   format a15
Column status        heading 'Status'        format a7
Column created       heading 'Created'       format a20
Column last_ddl_time heading 'Last DDL Time' format a20


select object_name, object_type, owner, status, created, last_ddl_time, object_id
  from dba_objects 
 where upper(object_name) = UPPER('&&object_name')
   and object_type = 'TABLE'
/
--clear columns
--set verify on
undefine object_name
