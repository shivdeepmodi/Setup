col DG_NAME for a20
col NAME heading DISK_NAME for a30
col PATH for a40
col SIZE_TB for 9999
col SIZE_GB for 99999

Accept statv char prompt 'Read from STAT views(default Y) [Y|N] : ' default Y
set termout off timing off
col ASM_DISKGROUP new_value ASM_DISKGROUP
col diskgroup new_value diskgroup
select decode('&&statv','Y','GV$ASM_DISKGROUP_STAT','N','GV$ASM_DISKGROUP') ASM_DISKGROUP from dual;

col ASM_DISK new_value ASM_DISK
select decode('&&statv','Y','GV$ASM_DISK_STAT','N','GV$ASM_DISK') ASM_DISK from dual;
set termout on
set head off feedback off
prompt
select 'Selecting from '||'&&ASM_DISKGROUP'||' and '||'&&ASM_DISK' from dual;
prompt
set head on feedback on verify off

Accept diskgroup char prompt 'Diskgroup Name? : '

select --dg.inst_id,
distinct dg.name dg_name, d.name,d.label,d.path, round(d.total_mb/1048576,2) size_tb,round(d.total_mb/1024,2) size_gb,d.state
from &&asm_diskgroup dg, &&asm_disk d
where dg.group_number=d.group_number
and dg.inst_id  = d.inst_id
and dg.name like decode('&diskgroup',NULL,'%',upper('&diskgroup%'))
order by dg_name;
set timing on

