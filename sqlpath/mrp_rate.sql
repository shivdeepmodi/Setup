select inst_id,START_TIME,to_char(item)||' = '||to_char(sofar)||' '||to_char(units)||' '|| to_char(TIMESTAMP,'dd.mm.yyyy hh24:mi') "Values" 
from gv$recovery_progress where start_time=(select max(start_time) from v$recovery_progress)
/
