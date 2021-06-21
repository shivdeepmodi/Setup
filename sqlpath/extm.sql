select tablespace_name,initial_extent/1048576,next_extent/1048576
from dba_tablespaces where tablespace_name = upper('&1')
/
