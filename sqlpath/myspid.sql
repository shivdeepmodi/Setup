REM SQL to find server process id of current session
REM select spid, s.sid,s.serial#, s.username dbuser, p.username osuser, p.program
REM   from v$process p, v$session s
REM where p.addr = s.paddr
REM and s.sid = (select sid from v$mystat where rownum =1)
REM /

Column spid heading "Current Session SPID" format a20
select a.spid
from v$process a, v$session b
where a.addr = b.paddr
and b.audsid = userenv('sessionid')
/
clear columns