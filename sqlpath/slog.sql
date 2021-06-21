col member for a70
col status for a10
select l.group#,l.sequence#,l.thread#,f.member,l.archived,l.bytes/1048576 size_mb,l.status,f.type, l.first_time
  from v$standby_log l, v$logfile f
 where l.group# = f.group#
 order by l.thread#,l.group#;
