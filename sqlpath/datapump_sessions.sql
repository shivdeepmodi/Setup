select 
   sid, 
   serial#,username,machine,program,job_name,session_type,logon_time,last_call_et
from 
   gv$session s, 
   dba_datapump_sessions d
where 
   s.saddr = d.saddr;