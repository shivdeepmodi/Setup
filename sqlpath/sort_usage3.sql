set linesize 200
col sql_text format a80
col sid_serial format a12
col sqlid format a16
SELECT S.sid || ',' || S.serial# sid_serial, T.blocks * TBS.block_size / 1024 / 1024 mb_used, S.sql_id sqlid, Q.sql_text sql_text, s.status, p.spid
FROM v$sort_usage T, v$session S, v$sqlarea Q, dba_tablespaces TBS, v$process p
WHERE T.session_addr = S.saddr
AND S.paddr = P.addr
AND T.sqladdr = Q.address (+)
AND T.tablespace = TBS.tablespace_name
ORDER BY mb_used desc;