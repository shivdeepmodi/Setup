col sid_serial for a10
select s.sid||','||s.serial# sid_serial,s.username,s.osuser, s.status,a.open_versions, a.users_executing,chr(10)||a.sql_text
 from v$session s, v$sqlarea a, v$process p
where s.sql_address = a.address
  and s.sql_hash_value = a.hash_value
  and p.addr = s.paddr
  and p.spid = '&spid';