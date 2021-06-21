-- Purpose: Show "physical reads" and "block changes" for user sessions.
--          Order by either by changing order by below. 

column  SID_SER# format A10
column osuser format a10
column program for a10
column module for a10
select s.username,
       s.sid ||','|| s.serial# SID_SER#,
       substr(s.osuser,1,10) osuser,
       s.machine, 
       s.terminal,
       s.process, 
       s.status,
       substr(s.program,1,10) program,
       substr(s.module,1,10) module,
       io.physical_reads, io.block_changes
 from v$session S, v$sess_io IO
where s.sid=io.sid
  and  s.type <> 'BACKGROUND'
order by io.physical_reads desc
--order by io.block_changes desc
/
