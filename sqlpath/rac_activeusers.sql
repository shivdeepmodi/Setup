-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : rac_activeusers.sql
-- | CLASS    : Real Application Clusters                                       |
-- | PURPOSE  : List all currently connected and active user sessions for all   |
-- |            instances in the cluster.                                       |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+


COLUMN instance_name     FORMAT 9        HEADING 'NID'
COLUMN session_status    FORMAT a9         HEADING 'Status'          JUSTIFY right
COLUMN os_username       FORMAT a12        HEADING 'O/S User'        JUSTIFY right
COLUMN os_pid            FORMAT a10       HEADING 'O/S PID'         JUSTIFY left
COLUMN Event   FORMAT a20       HEADING 'Event'  JUSTIFY left
COLUMN session_machine   FORMAT a10        HEADING 'Machine'         JUSTIFY right
col CHILD_CUR for 9999
column "SID:SERIAL#" for a11
column USERINFO format a15
column CurrentSQL for a45 word
prompt
prompt +----------------------------------------------------+
prompt | User Sessions (All)                                |
prompt +----------------------------------------------------+
col inst for 999
col  os_pid for a10
col SESSION_PROGRAM for a15
BREAK ON inst SKIP PAGE

select distinct INST ,USERINFO ,"SID:SERIAL#" ,session_status ,os_pid ,Event ,Secs  ,session_machine,CHILD_CUR ,PHV,CurrentSQL from ( SELECT
     i.inst_id      inst 
  ,  s.osuser||'/'||s.username USERINFO
 -- , s.sql_id
  ,  s.sid||','||s.serial# "SID:SERIAL#"
  , lpad(s.status,9)     session_status
--  , lpad(s.osuser,12)    os_username
  , lpad(p.spid,7)       os_pid
  , s.event            Event
 -- , lpad(s.terminal,10)  session_terminal
  ,(sysdate-sql_exec_start)*24*60*60 Secs 
  , lpad(s.machine,19)   session_machine
  ,s.SQL_CHILD_NUMBER CHILD_CUR
  ,sq.plan_hash_value PHV
  ,s.sql_id||'/'||substr(sq.sql_text,1,80) CurrentSQL FROM 
               gv$session  s
    INNER JOIN gv$process  p ON (s.paddr = p.addr AND s.inst_id = p.inst_id)
    INNER JOIN gv$instance i ON (p.inst_id = i.inst_id)
    INNER JOIN gv$sql sq on (sq.sql_id=s.sql_id and sq.inst_id = s.inst_id) WHERE
      s.status   = 'ACTIVE'
   AND s.username IS NOT null 
--and s.sql_id in ( 'dbp8t5tg6jkhu' ,'2t4fbyn9hxmxy')
-- and sq.sql_text like '%m.rowkey rowkey, c.name%'
--ORDER BY
--    i.inst_id
--  , s.sid
  ) ORDER BY 1 ,CurrentSQL,Secs
/
