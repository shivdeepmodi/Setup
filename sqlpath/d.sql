Accept statv char prompt 'Read from STAT views(default Y) [Y|N] : ' default Y
set termout off timing off
col ASM_DISKGROUP new_value ASM_DISKGROUP
select decode('&&statv','Y','GV$ASM_DISKGROUP_STAT','N','GV$ASM_DISKGROUP') ASM_DISKGROUP from dual;

col ASM_DISK new_value ASM_DISK
select decode('&&statv','Y','GV$ASM_DISK_STAT','N','GV$ASM_DISK') ASM_DISK from dual;
set termout on
set head off feedback off
prompt
select 'Selecting from '||'&&ASM_DISKGROUP'||' and '||'&&ASM_DISK' from dual;
prompt
set head on feedback on verify off

/*
col disk_group for a30
select distinct substr(files,1,instr(files,'/',1)-1) DISK_GROUP from (
select name   as files from v$datafile
union all
select name   as files from v$controlfile
union all
select member as files from v$logfile
union all
select name   as files from v$tempfile
)
union all
select value as files from v$parameter where name = 'db_recovery_file_dest'
;
*/
col disk_str for a30
col log_str for a30
select distinct substr(name,1,instr(name,'/',1)) disk_str from v$datafile;
select distinct substr(member,1,instr(member,'/',1)) log_str from v$logfile;
prompt
col size_gb for 9999999
select dg_name,sum(size_tb) size_tb,sum(size_gb) size_gb
from
(
select distinct dg.name dg_name, d.name,d.label,d.path, round(d.total_mb/1048576,2) size_tb,round(d.total_mb/1024,2) size_gb,d.state
from &&asm_diskgroup dg, &&asm_disk d
where dg.group_number=d.group_number
and dg.inst_id  = d.inst_id
and dg.name in (
select distinct substr(files,2,instr(files,'/',1)-2) DISK_GROUP from (
select name   as files from v$datafile
union all
select name   as files from v$controlfile
union all
select member as files from v$logfile
union all
select name   as files from v$tempfile
)
union all
select replace(value,'+','') as files from v$parameter where name = 'db_recovery_file_dest'
)
)
group by dg_name
order by dg_name;
set timing on
