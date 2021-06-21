col owner for a10
col tablespace_name for a15
col segment_type for a12
col segment_name for a30
col table_name for a21
select * from (
select s.owner,s.tablespace_name,l.table_name,l.segment_name,segment_type,s.bytes/1048576 size_mb
  from dba_segments s, dba_lobs l
 where s.tablespace_name = upper('&1')
   and l.tablespace_name = s.tablespace_name
   --and s.owner = l.owner
   and s.segment_name = l.segment_name
order by 6 desc
)
where rownum <=5
/
