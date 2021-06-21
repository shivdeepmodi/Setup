/*
Altertenate sql to get the below output

select s.sid||','||s.serial# sid_serial, s.username,s.osuser, s.program,s.status, a.open_versions, a.users_executing,a.sql_text
  from v$session s, v$sqlarea a
 where s.sql_hash_value = a.hash_value
   and s.sql_address = a.address
   and s.username is not null
 order by 1
 
*/

col sid_serial for a15
col osuser for a10
select s.sid||','||s.serial# sid_serial,spid,s.username,s.osuser, s.machine,s.program,s.status,
       --a.open_versions, 
	   --a.users_executing,
	   logon_time,
	   last_call_et,
       a.sql_text
 from v$session s, v$sql a, v$process p
where s.sql_address = a.address
  and s.sql_hash_value = a.hash_value
  and p.addr = s.paddr
  and s.sid = '&sid'
order by 1;