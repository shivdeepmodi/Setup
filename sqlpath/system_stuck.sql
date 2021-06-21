break on report

col event for a60
compute sum of sessions on report

select event,count(*) sessions from v$session_wait
 where state = 'WAITING'
 group by event
 order by 2 desc;

clear breaks
