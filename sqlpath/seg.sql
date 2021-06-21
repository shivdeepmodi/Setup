select owner,segment_name,segment_type,bytes/1048576 from dba_segments where tablespace_name = upper('&1')
order by 4
/
