undefine sid
col sid for 99999
col seq# for 999999
col event for a28

@session2 &&sid
select sid,seq#,event,state,seconds_in_wait from v$session_wait where sid=&&sid;

select sysdate,block_gets,consistent_gets from v$sess_io where sid=&&sid;

select sid,sql_id,LAST_SQL_ACTIVE_TIME,SQL_EXEC_ID,CURSOR_TYPE from v$open_cursor where sid = &&sid;
