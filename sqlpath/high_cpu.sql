COLUMN username FORMAT a10
COLUMN sid FORMAT 999,999,999
COLUMN serial# FORMAT 999,999,999
COLUMN sql_id FORMAT a10
COLUMN machine FORMAT a10
COLUMN osuser format a10
COLUMN module format a10
COLUMN sql_text format a40
COLUMN "cpu usage (seconds)" FORMAT 999,999,999.0000


SELECT 
   s.username,
   t.sid,
   s.serial#,
s.osuser,
s.machine,
   s.sql_id,
s.module,
f.sql_text, 
SUM(VALUE/100) as "cpu usage (seconds)"
FROM
   v$session s,
   v$sesstat t,
   v$statname n,
   v$sql f 
 WHERE
   t.STATISTIC# = n.STATISTIC#
and s.sql_id=f.sql_id
AND
   NAME like '%CPU used by this session%'
AND
   t.SID = s.SID
AND
   s.status='ACTIVE'
AND
   s.username is not null
GROUP BY username,t.sid,s.sql_id,s.osuser,s.machine,s.module,s.serial#,f.sql_text, value 
order by 9 desc
/
