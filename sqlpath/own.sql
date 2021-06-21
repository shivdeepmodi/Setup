select owner,segment_type,count(*)
from dba_segments 
where tablespace_name = upper('&1')
group by owner,segment_type
/
