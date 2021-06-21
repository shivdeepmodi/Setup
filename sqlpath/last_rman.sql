def backup_window   = 30

select decode(backup_type,'D','FULL/LvL0','I','Incremental','L','Archive Log',backup_type)
      ,max(vs.completion_time)                                                               latest
from  v$backup_set    vs
     ,v$backup_piece  vp
where vs.recid           = vp.recid
  and vs.completion_time > sysdate - &backup_window
group by  decode(backup_type,'D','FULL/LvL0','I','Incremental','L','Archive Log',backup_type)
/

