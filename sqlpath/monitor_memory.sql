-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/monitoring/monitor_memory.sql
-- Author       : DR Timothy S Hall
-- Description  : Displays memory allocations for the current database sessions.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @monitor_memory
-- Last Modified: 15-JUL-2000
-- -----------------------------------------------------------------------------------
column username  heading 'Username'    format a10
column module    heading 'Module'      format a20
column program   heading 'Program'     format a25
column memory_kb heading 'Memory|(KB)' format 999999


select nvl(a.username,'[oracle]') as username,
       a.module,
       a.program,
       Trunc(b.value/1024) AS memory_kb
from   v$session a,
       v$sesstat b,
       v$statname c
where  a.sid = b.sid
and    b.statistic# = c.statistic#
and    c.name = 'session pga memory'
and    a.program IS NOT NULL
order by b.value desc;
clear columns