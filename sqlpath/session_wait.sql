Column seconds_in_wait heading 'Seconds|In|Wait' format 9999999
Column event           heading 'Event'           format a30
Column wait_time       heading 'Wait Time'       format 9999
Column command         heading 'Command'         format a15
Column state           heading 'State'           format a20
Column username        heading 'Username'        format a15
Column status          heading 'Status'          format a8
Column name            heading 'Event Name'      format a50
Column parameter1      heading 'Parameter1'      format a20
Column parameter2      heading 'Parameter2'      format a20
Column parameter3      heading 'Parameter3'      format a20
Column wait_class                                format a20

select s.sid,s.username,s.status,decode(s.command,0,'transition',
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
                                                  'OTHER') command,w.event,w.wait_class,w.p1,w.p2,w.p3,w.wait_time,w.seconds_in_wait,w.state
  from gv$session s, gv$session_wait w
 where s.sid = w.sid
   and s.username is not null
 order by seconds_in_wait desc;
--clear columns

Prompt Get event details
SELECT * FROM v$event_name WHERE name = '&event';
