select inst_id,trunc(first_time), min(sequence#),max(sequence#)
  from gv$archived_log
 where trunc(first_time) > trunc(sysdate) -3
 group by inst_id,trunc(first_time)
 order by trunc(first_time)
/
