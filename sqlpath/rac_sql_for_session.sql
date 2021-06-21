REM
REM Name:    rac_sql_for_session.sql
REM
REM Purpose:
REM
REM          Shows full SQL text for a given session.
REM
REM ADDED rule hint for 10g
set pages 1000 linesize 200 trims on echo off verify off feedback off set long 5000
col orauser     format a10      trunc
col sid         format 9999
col osuser      format a10
col shadow      format a5
--col program   format a10      trunc
col sqlh        format 9999999999       heading 'SQL HASH|VALUE'
col sql_text    format a64 wrap
break on inst_id on orauser on sid on osuser on shadow on sqlh on sqlid on SQL_HASH_VALUE
SELECT /*+rule*/        s.inst_id, s.username   orauser
        ,s.sid          sid
        ,osuser         osuser
        ,spid           shadow
--      ,s.program      program
        ,s.sql_id        sqlid
        ,s.SQL_HASH_VALUE SQL_HASH_VALUE
        ,t.sql_text
FROM     gv$sqltext t
        ,gv$session s
        ,gv$process p
WHERE
t.inst_id=s.inst_id and s.inst_id=p.inst_id and t.hash_value = s.sql_hash_value
AND      p.addr = s.paddr (+)
AND      sid = &sid
ORDER BY orauser
        ,sid
        ,osuser
        ,shadow
--      ,program
        ,t.hash_value
        ,t.piece
;

