Column sid      heading 'SID'         format 99999999
Column serial#  heading 'SERIAL#'     format 99999999
Column username heading 'Username'    format a20
Column machine  heading 'Machine'     format a20
Column num_curs heading 'Cursors|(#)' format 99999999
--break on report
--compute sum of num_curs on report
accept rows           prompt 'How many rows: '

set head off feedback off
prompt
prompt App team,
prompt
select 'Maximum Cursors allowed in a session: '||value
  from v$parameter
 where name = 'open_cursors'
 order by name
/

select  'Total Open Cursors in Database: '||count(*) from  gv$open_cursor o, gv$session s
 where o.sid=s.sid
   and o.inst_id = s.inst_id
/


prompt
select 'Top Open cursor per session' from dual
/
prompt
set head on feedback on

select * from (
select o.sid, s.serial#, username, machine, count(*) num_curs
  from gv$open_cursor o, gv$session s
 where o.sid=s.sid
   and o.inst_id = s.inst_id
 group by o.sid, s.serial#,username, machine
 order by  num_curs desc 
)
where rownum < &rows;

--clear columns breaks
