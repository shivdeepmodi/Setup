select Day,LogSwitch, round(LogSwitch*log_size/1048576/1024,0) REDO_GB_PER_DAY from
(select max(bytes) log_Size from v$log ) l,
(select trunc(first_time) Day, count(*) LogSwitch
  from v$log_history
 group by trunc(first_time)
 order by 1
)
/
