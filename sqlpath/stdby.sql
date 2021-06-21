set timing off
col status for a20
col GROUP# heading GROUP# for a6

select inst_id,process,CLIENT_PROCESS, status,GROUP#, thread#,block#,blocks, sequence# 
from gv$managed_standby 
--where status not in ('CLOSING','IDLE','CONNECTED') 
/

col value for a20
select name,value,time_computed from V$DATAGUARD_STATS;
set timing on
