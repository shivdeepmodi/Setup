Column sid                            heading 'SID'       format 999999
Column serial#                        heading 'SERIAL#'    format 99999
Column osuser                         heading 'Osuser'     format a10
Column program                        heading 'Program'    format a20
Column last_call_et heading last_call heading 'Last Call'  format 9999999
Column status                         heading 'Status'     format a8
Column in_list_rank                   heading 'Rank'       format 99 noprint
Column command                        heading 'Command'    format a10
Column username                       heading 'Username'   format a15
Column machine                        heading 'Machine'    format a20
Column terminal                       heading 'Terminal'   format a10
Column logon_time                     heading 'Logon Time' format a20
Column server                         heading 'Server'     format a9
column module for a10
column inst_id                        heading 'INST_ID'    format 99
undefine sid
define sid=&1
select sid,
       serial#,sql_id,
       inst_id,
       username,--module,
       osuser, 
       machine,
       terminal,
--       server,
       decode(s.command,0,'0',
                        1,'CREATE TABLE',
                        2,'INSERT',
                        3,'SELECT',
                        6,'UPDATE',
                        7,'DELETE',
                        9,'CREATE INDEX',
                        11,'ALTER INDEX',
                        15,'ALTER TABLE',
                        21,'CREATE VIEW',
                        26,'LOCK TABLE',
                        44,'COMMIT',
                        45,'ROLLBACK',
                        47,'PLSQL EXECUTE',
                        62,'ANALYZE TABLE',
                        63,'ANALYZE INDEX',
                        s.command
             ) command,
       logon_time,
       last_call_et,
       substr(s.program,1,20) program,
       s.status
	     from gv$session s
 where username is not null
   and sid=&sid
/
