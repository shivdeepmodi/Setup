select t.owner,t.index_name,t.tablespace_name, t.size_kb table_size, s.size_kb extent_size
  from
(
select index_name, tablespace_name,owner,round(num_rows* avg_row_len/1048576,2) size_kb
  from dba_indexes
 where partitioned = 'NO'
 ) t,
(
select segment_name,tablespace_name,owner,round(bytes/1048576,2) size_kb
  from dba_segments
 where segment_type = 'INDEX'
) S
 where t.index_name = s.segment_name
   and t.owner = s.owner
   and t.size_kb > 1000
union all
select t.table_owner owner,t.index_name, t.tablespace_name,t.size_kb table_size, s.size_kb extent_size
  from
(
select index_name, tablespace_name,index_owner,round(num_rows* avg_row_len/1048576,2) size_kb
  from dba_ind_partitions
 ) t,
(
select segment_name,tablespace_name,owner,round(bytes/1048576,2) size_kb
  from dba_segments
 where segment_type = 'INDEX PARTITION'
) S
 where t.index_name = s.segment_name
   and t.table_owner = s.owner
   and t.size_kb > 1000
 order by 2
/
