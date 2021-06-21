Column sid                            heading  'SID'       format 999
Column serial#                        heading 'SERIAL#'    format 99999
Column osuser                         heading 'Osuser'     format a10
Column program                        heading 'Program'    format a20
Column last_call_et heading last_call heading 'Last Call'  format 9999999
Column status                         heading 'Status'     format a8
Column in_list_rank                   heading 'Rank'       format 99 noprint
Column command                        heading 'Command'    format a10
Column username                       heading 'Username'   format a13
Column machine                        heading 'Machine'    format a20
Column terminal                       heading 'Terminal'   format a10
Column logon_time                     heading 'Logon Time' format a20
Column server                         heading 'Server'     format a9

select sid,
       serial#,
       username,
       osuser, 
       machine,
       terminal,
       server,
       substr(s.program,1,20) program,
       s.status,
       decode(s.command,0,'transition',
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
                        'OTHER'
             ) command,
       logon_time,
       last_call_et
  from v$session s
 where username is not null
   and status = 'ACTIVE'
/
