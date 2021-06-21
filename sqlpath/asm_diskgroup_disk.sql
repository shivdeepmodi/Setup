select dg.inst_id,dg.name dg_name, dg.label la, d.name,d.path, d.state 
from gv$asm_diskgroup dg, gv$asm_disk d
where dg.group_number=d.group_number
and dg.inst_id  = d.inst_id
and dg.name like '&diskgroup_name'
order by dg_name;