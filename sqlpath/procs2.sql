prompt
accept rows           prompt 'How many rows: '
col program for a20 trunc
col instance_name for a10
col value for a10


prompt Maximum processes allowed per instance
prompt
select i.instance_name,p.name,p.value
  from gv$parameter p, gv$instance i
 where name = 'processes'
   and p.inst_id = i.inst_id
order by name
/

prompt
prompt  Total Open processes per instance
col instance_name for a9
set head on feedback on verify off
select init.instance_name,val.count#, round(val.count#/init.value*100,2) pct
from
(select i.instance_name,p.name,p.value
  from gv$parameter p, gv$instance i
 where name = 'processes'
   and p.inst_id = i.inst_id) init ,
(select i.instance_name,count(*) count#
from gv$process a,  gv$instance i
where i.inst_id = a.inst_id
group by i.instance_name
) val
where val.instance_name = init.instance_name
/

prompt Top processes grouped by username/machine/osuser/program and program

prompt

set head on feedback on

col username for a20
col machine for a32
col status for a8
select * from (
select i.instance_name,s.username,s.machine,s.osuser,substr(s.program,1,20) program,s.status,count(*)
from gv$process a, gv$session s, gv$instance i
where a.addr = s.paddr
  and a.inst_id = s.inst_id
  --and s.username is not null
  and s.inst_id = i.inst_id
group by i.instance_name,s.username,s.machine,s.osuser,s.program,s.status
order by 7 desc
)
where rownum <= &&rows
/
