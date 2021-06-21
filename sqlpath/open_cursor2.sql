Column sid      heading 'SID'         format 99999999
Column serial#  heading 'SERIAL#'     format 99999999
Column username heading 'Username'    format a20
Column machine  heading 'Machine'     format a40
Column num_curs heading 'Cursors|(#)' format 99999999
--break on report
--compute sum of num_curs on report
accept rows           prompt 'How many rows: '

set head off feedback off
prompt
prompt Max Open Cursors in a session
prompt
select i.instance_name,p.name,p.value
  from gv$parameter p, gv$instance i
 where name = 'open_cursors'
   and p.inst_id = i.inst_id
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

select * from 
(
select inst_id,sid, serial#, username, machine, num_curs,row_number() over (partition by inst_id order by inst_id) rnum
from
(
select s.inst_id,o.sid, s.serial#, username, machine, count(*) num_curs
  from gv$open_cursor o, gv$session s
 where o.sid=s.sid
   and o.inst_id = s.inst_id
 group by s.inst_id,o.sid, s.serial#,username, machine
 order by s.inst_id asc, num_curs desc
)
)
where rnum <=&&rows
;

--clear columns breaks
