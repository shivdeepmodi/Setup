set lines 300
col db_name for a20
col DG_NAME for a20
col NAME heading DISK_NAME for a30
col PATH for a40
col SIZE_TB for 9999
col SIZE_GB for 99999

--Accept statv char prompt 'Read from STAT views(default Y) [Y|N] : ' default Y
define statv=Y
set termout off timing off verify off
col ASM_DISKGROUP new_value ASM_DISKGROUP
select decode('&&statv','Y','V$ASM_DISKGROUP_STAT','N','V$ASM_DISKGROUP') ASM_DISKGROUP from dual;

col ASM_DISK new_value ASM_DISK
select decode('&&statv','Y','V$ASM_DISK_STAT','N','V$ASM_DISK') ASM_DISK from dual;
set termout on
set head off feedback off
prompt
select 'Selecting from '||'&&ASM_DISKGROUP'||' and '||'&&ASM_DISK' from dual;
prompt
set head on feedback on verify off


select distinct '&&_connect_identifier' db_name,dg.name dg_name, d.state,round(d.total_mb/1048576,2) size_tb,round(d.total_mb/1024,2) size_gb,count(*)
from &&asm_diskgroup dg, &&asm_disk d
where dg.group_number=d.group_number
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
--and dg.name like '%DATA%'
group by dg.name , d.state,round(d.total_mb/1048576,2) ,round(d.total_mb/1024,2)
order by dg_name;
set timing on
