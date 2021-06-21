/*
  select sid,spid,osuser,s.username
   from v$process p, v$session s
  where p.addr = s.paddr
    and spid = '&spid'
*/

select s.sid||','||s.serial# sid_serial,s.username,s.osuser, s.status,a.open_versions, a.users_executing,a.sql_text
 from v$session s, v$sql a, v$process p
where s.sql_address = a.address
  and s.sql_hash_value = a.hash_value
  and p.addr = s.paddr
  and s.username is not null
  and spid = '&spid'
order by 1;