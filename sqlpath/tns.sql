select dbu.value||'=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(PORT=1521)(HOST='||rl.value||'))(CONNECT_DATA=(SERVICE_NAME='||dbu.value||')))'
--select dbu.value , rl.value 
from 
(select value from v$parameter where name = 'db_unique_name') dbu,(select substr(value,1,instr(value,':')-1) value from v$parameter where name = 'remote_listener') rl;
