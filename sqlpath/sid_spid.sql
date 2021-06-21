Column sid                            heading  'SID'       format 999999
Column serial#                        heading 'SERIAL#'    format 99999
Column username                       heading 'Username'   format a17
Column osuser                         heading 'Osuser'     format a10
Column program                        heading 'Program'    format a40
Column last_call_et heading last_call heading 'Last Call'  format 9999999


select s.sid, s.serial#, a.spid, s.username,s.osuser,s.program,s.last_call_et
from gv$process a, gv$session s
where a.addr = s.paddr
  and a.inst_id = s.inst_id
  and s.username is not null
order by s.sid
/