prompt
set head off feedback off
select 'Maximum processes allowed in : '||value
  from v$parameter
where name = 'processes'
order by name
/
 
select  'Total Open processes in Database: '||count(*) from  gv$process
/
prompt
select 'Number of user processes grouped by username/osuser and program' from dual
/
prompt
 
set head on feedback on
col instance_name for a8
col username for a20
col machine for a30
select i.instance_name,s.username,s.machine,s.osuser,s.program,count(*)
from gv$process a, gv$session s, gv$instance i
where a.addr = s.paddr
  and a.inst_id = s.inst_id
  and s.username is not null
  and s.inst_id = i.inst_id
group by i.instance_name,s.username,s.machine,s.osuser,s.program
order by 6 desc
/