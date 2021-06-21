accept tablespace_name char prompt 'Give Tablespace:' 
set verify off
column table_name heading Table
column table_size heading 'Size|(MB)' format 999999999  
column extent_size heading 'Allocated Extent|Size(MB)' format 999999999
select t.owner,t.table_name, t.size_kb table_size, s.size_kb extent_size
  from 
(
select table_name, owner,round(num_rows* avg_row_len/1048576,2) size_kb
  from dba_tables
 where tablespace_name = upper('&&tablespace_name')
   and partitioned = 'NO'
 ) t,
(
select segment_name,owner,round(bytes/1048576,2) size_kb
  from dba_segments
 where tablespace_name = upper('&&tablespace_name')
   and segment_type = 'TABLE'
) S
 where t.table_name = s.segment_name
   and t.owner = s.owner
union all
select t.table_owner,t.table_name, t.size_kb table_size, s.size_kb extent_size
  from 
(
select table_name, table_owner,round(num_rows* avg_row_len/1048576,2) size_kb
  from dba_tab_partitions
 where tablespace_name = upper('&&tablespace_name')
) t,
(
select segment_name,owner,round(bytes/1048576,2) size_kb
  from dba_segments
 where tablespace_name = upper('&&tablespace_name')
   and segment_type = 'TABLE PARTITION'
) S
 where t.table_name = s.segment_name
   and t.table_owner = s.owner
 order by 3
/
set verify on
