column table_owner for a10
column name heading 'Table Name' format a30
column object_type heading 'Object Type' format a11
column column_name heading 'Column Name' format a30
column column_position format 999

select owner,name,object_type,column_name,column_position 
  from dba_part_key_columns
 where owner not in ('SYS','SYSTEM')
   and object_type = 'TABLE'
/
