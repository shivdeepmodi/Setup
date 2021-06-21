column table_owner for a11
column name heading 'Partition Name' format a30
column object_type heading 'Object Type' format a11
column column_name heading 'Partitioned Column Name' format a30
column column_position format 999
column data_type format a10

select distinct p.table_owner,p.table_name,c.column_name, c.data_type
  from
(
select table_name,table_owner,partition_name
  from dba_tab_partitions
 where table_owner not in ('SYS','SYSTEM')
) p
,
(
select table_name,owner,column_name, data_type
  from dba_tab_columns
 where owner not in ('SYS','SYSTEM')
) c
,
(
select owner,name,object_type,column_name,column_position 
  from dba_part_key_columns
 where owner not in ('SYS','SYSTEM')
   and object_type = 'TABLE'
) k
 where p.table_name = c.table_name
   and p.table_owner = c.owner
   and k.name = c.table_name
   and k.owner = c.owner
   and c.column_name = k.column_name
 order by p.table_owner, p.table_name
/
