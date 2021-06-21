REM Use the query to find which session has been assigned which rollback segment.

col rbs for a20

select sid,username,osuser,r.name as rbs,xidusn,xidslot,xidsqn,t.status
from v$session s, v$transaction t, v$rollname r
where t.ses_addr = s.saddr
and t.xidusn = r.usn
/