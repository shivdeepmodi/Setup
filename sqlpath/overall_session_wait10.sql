select a.sid,
       b.username,
       a.wait_class,
       a.total_waits,
       a.time_waited         
  from v$session_wait_class a, v$session b
 where b.sid = a.sid 
   and b.username is not null 
   and b.sid = '&sid'
 order by 1,2,3
/