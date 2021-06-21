select s.sid,s.serial#,s.username,s.machine,s.program,i.BLOCK_CHANGES
  from v$session s, v$sess_io i
 where i.sid=s.sid;