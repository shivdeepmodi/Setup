select username,tablespace_name, decode(max_bytes, -1, 'unlimited', ceil(max_bytes/1048576) || 'M' ) Quota
from   dba_ts_quotas
/
