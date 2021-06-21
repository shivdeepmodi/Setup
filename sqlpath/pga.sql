col username for a15
col status for a20
col pga_limit for a20
col pga_target for a20
with pga_limit as
(
select i.instance_name,i.inst_id,name,round(value/power(1024,3),2) pga_limit_gb
  from gv$parameter p, gv$instance i
 where i.inst_id = p.inst_id
   and p.name = 'pga_aggregate_limit'
),
pga_target as
(
select i.instance_name,i.inst_id,name,round(value/power(1024,3),2) pga_target_gb
  from gv$parameter p, gv$instance i
 where i.inst_id = p.inst_id
   and p.name ='pga_aggregate_target'
),
pga_usage as
(
select a.inst_id,ROUND(SUM(a.pga_used_mem)/(power(1024,3)),2) PGA_USED_GB
from gv$process a, gv$session s
where a.addr = s.paddr
    and s.inst_id = a.inst_id
	group by a.inst_id
)
select l.instance_name,l.name pga_limit,l.pga_limit_gb, t.name pga_target,t.pga_target_gb,u.pga_used_gb,
       round(u.pga_used_gb/l.pga_limit_gb,2)*100 pct_limit, round(u.pga_used_gb/t.pga_target_gb,2)*100 pct_target
  from pga_limit l, pga_target t, pga_usage u
 where l.inst_id = t.inst_id
   and u.inst_id = t.inst_id;

col status for a20
select i.instance_name,s.username,s.status,ROUND(SUM(a.pga_used_mem)/(power(1024,3)),2) PGA_USED_GB
from gv$process a, gv$session s, gv$instance i
where a.addr = s.paddr
    and s.inst_id = a.inst_id
    and s.inst_id = i.inst_id
	group by i.instance_name,s.username,s.status
	having ROUND(SUM(a.pga_used_mem)/(power(1024,3)),2) > 1
	order by 1;
