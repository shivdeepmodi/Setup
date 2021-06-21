-- Purpose: Show who's using sort space.
/*
select s.sid,s.serial#,s.username, s.osuser, s.program, sum(u.extents) "EXTENTS", sum(u.blocks) "BLOCKS"
from gv$sort_usage u, gv$session s
where u.session_addr = s.saddr
  and u.inst_id = s.inst_id
group by s.sid,s.serial#,s.username, s.osuser, s.program
order by s.username, s.program
/
*/
col status for a8
col tablespace for a10
col sid   for 99999
col serial# for 999999
col username for a15
col osuser for a12
col program for a20

Prompt TEMP Blocks usage
prompt =================================
with total as (
select dt.tablespace_name, sum(dt.blocks) total_blocks
  from dba_temp_files dt, v$tempfile v
 where file#= file_id
   and file_name = name
 group by dt.tablespace_name
),
used as 
(select instance_name,tablespace,sum(blocks) blocks_in_use
  from gV$TEMPSEG_USAGE temp, gv$instance inst
 where temp.inst_id = inst.inst_id
 group by instance_name,tablespace
)
select total.tablespace_name, total.total_blocks, used.blocks_in_use, round(used.blocks_in_use/total.total_blocks*100,2) used_pct
  from total, used
 where total.tablespace_name = used.tablespace
/

Prompt TEMP Blocks usage / instance
prompt =================================
with total as (
select dt.tablespace_name, sum(dt.blocks) total_blocks
  from dba_temp_files dt, v$tempfile v
 where file#= file_id
   and file_name = name
 group by dt.tablespace_name
),
used as 
(select instance_name,tablespace,sum(blocks) blocks_in_use
  from gV$TEMPSEG_USAGE temp, gv$instance inst
 where temp.inst_id = inst.inst_id
 group by instance_name,tablespace
)
select used.instance_name,used.tablespace, total.total_blocks, used.blocks_in_use, round(used.blocks_in_use/total.total_blocks*100,2) used_pct
  from total, used
 where total.tablespace_name = used.tablespace
/

col service_name for a15  trunc
col tablespace for a10
col SID_SERIAL for a15
SELECT   S.INST_ID,S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, 
P.spid pid, 
s.service_name,
s.sql_id,
s.status,
--P.program, 
T.segtype ,
SUM (T.blocks)* TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
COUNT(*) statements
FROM     gv$tempseg_usage T, gv$session S, dba_tablespaces TBS, gv$process P
WHERE    T.session_addr = S.saddr
AND      S.paddr = P.addr
AND   s.inst_id=p.inst_id
and   t.inst_id=p.inst_id
and   s.inst_id=t.inst_id
AND      T.tablespace = TBS.tablespace_name
having SUM (T.blocks) * TBS.block_size / 1024 / 1024>100
GROUP BY 
s.inst_id,
S.sid, 
S.serial#, S.username, 
S.osuser, P.spid, 
S.Service_name,
S.sql_id,
s.status,
--P.program, 
TBS.block_size, T.tablespace,segtype
ORDER BY mb_used desc;

/*
col sql_text format a80
col sid_serial format a12
col sqlid format a16
SELECT S.sid || ',' || S.serial# sid_serial, T.blocks * TBS.block_size / 1024 / 1024 mb_used, S.sql_id sqlid, Q.sql_text sql_text
FROM v$sort_usage T, v$session S, v$sqlarea Q, dba_tablespaces TBS
WHERE T.session_addr = S.saddr
AND T.sqladdr = Q.address (+)
AND T.tablespace = TBS.tablespace_name
ORDER BY mb_used desc;
*/
