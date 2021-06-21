select owner,segment_name,segment_type,round(bytes/1048576,0) size_MB from dba_segments where tablespace_name = upper('&1')
and bytes/1048576 > 500
order by 4
/
 
