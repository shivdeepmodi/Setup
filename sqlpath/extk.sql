select tablespace_name,initial_extent/1024,next_extent/1024
from dba_tablespaces where tablespace_name = upper('&1')
/
