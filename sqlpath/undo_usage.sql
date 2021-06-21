SELECT r.NAME "Undo Segment Name", dba_seg.size_mb,
logon_time, 
v$session.SID, v$session.SERIAL#, p.SPID, --v$session.process,
v$session.USERNAME, v$session.STATUS, v$session.OSUSER, v$session.MACHINE, v$session.PROGRAM, v$session.module--, action 
FROM v$lock l, v$process p, v$rollname r, v$session, 
(SELECT segment_name, ROUND(bytes/(1024*1024),2) size_mb FROM dba_segments WHERE segment_type = 'TYPE2 UNDO' ORDER BY bytes DESC) dba_seg 
WHERE l.SID = p.pid(+) AND 
v$session.SID = l.SID AND 
TRUNC (l.id1(+)/65536)=r.usn AND 
l.TYPE(+) = 'TX' AND 
l.lmode(+) = 6 
AND r.NAME = dba_seg.segment_name
--AND v$session.username = 'SYSTEM'
--AND status = 'INACTIVE'
ORDER BY size_mb DESC;