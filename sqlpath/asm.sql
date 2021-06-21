col DG_NAME for a20
col NAME heading DISK_NAME for a30
col PATH for a40
col SIZE_TB for 9999
col SIZE_GB for 99999
define db_uniq_name=&1

Accept statv char prompt 'Read from STAT views(default Y) [Y|N] : ' default Y
set termout off timing off verify off
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


col asm_compatibility for a20
col DATABASE_COMPATIBILITY for a20
select group_number, name, state,
compatibility asm_compatibility, database_compatibility from v$asm_diskgroup
where name in (select a.name from &&asm_diskgroup a, v$asm_client b where a.group_number = b.group_number and b.db_name = substr('&&db_uniq_name',1,8))
 order by name;
 
 
col attribute_name for a40
col attribute_name for a40
col value for a20
select aa.group_number, ad.name, aa.name attribute_name, aa.value
 from v$asm_attribute aa, &&asm_diskgroup ad
where aa.name like 'compatible%'
  and aa.group_number=ad.group_number
  and ad.name in (select a.name from &&asm_diskgroup a, v$asm_client b where a.group_number = b.group_number and b.db_name = substr('&DB_UNIQ_NAME',1,8));
set timing on

