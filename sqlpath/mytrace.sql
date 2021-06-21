col tracefile for a90
SELECT p.tracefile
FROM   v$session s
       JOIN v$process p ON s.paddr = p.addr
WHERE  s.sid = (select sid from v$mystat where rownum < 2);
