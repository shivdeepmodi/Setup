select i.instance_name,name,value 
  from gv$parameter p, gv$instance i
 where p.name like 'log_archive_dest%' 
 and p.name not like '%state%' 
 and p.value is not null
 and p.inst_id = i.inst_id
 order by 1,2;
