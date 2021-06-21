Column group_number         heading 'ASM|Disk|Group|#'       format 999
Column name                 heading 'ASM|Disk Group Name'    format a15
Column state                heading 'State'                  format a10
Column type                 heading 'Redundancy|Type'        format a10
Column total_mb             heading 'Allocated Space|(MB)'   format 999999999999
Column free_mb              heading 'Free Space|(MB)'        format 999999999999
Column unbalanced           heading 'Unbalanced'             format a10
Column offline_disks        heading 'Disks|Offline(#)'       format 9999
Column allocation_unit_size heading 'Allocation|Unit Size|(Bytes)' format 9999999
Column fpct                 heading 'Free|(%)'               format 999.99
Column upct                 heading 'Used|(%)'               format 999.99
Column block_size           heading 'Block|Size'             format 99999999999
Column usable_file_mb       heading 'usable_file_mb'         format 99999999999
Prompt
Prompt The GROUP_NUMBER, TOTAL_MB, and FREE_MB columns are only meaningful if the disk group is mounted by 
Prompt the instance. Otherwise, their values will be 0.
set verify off
select group_number
	   ,name
	   ,state
	   ,type
	   ,offline_disks,
       allocation_unit_size,
       block_Size
	   ,total_mb
	   ,free_mb
	   ,round(free_mb/total_mb*100,2) fpct
	   ,round((total_mb-free_mb)/total_mb*100,2) upct
	   ,usable_file_mb
	   --,unbalanced
	   --,voting_files
from v$asm_diskgroup
where name='&1'
/

col DG_NAME for a20
col NAME heading DISK_NAME for a30
col PATH for a40
col SIZE_TB for 9999
col SIZE_GB for 99999
select --dg.inst_id,
distinct dg.name dg_name, d.name,d.label,d.path, round(d.total_mb/1048576,2) size_tb,round(d.total_mb/1024,2) size_gb,d.state
from gv$asm_diskgroup dg, gv$asm_disk d
where dg.group_number=d.group_number
and dg.inst_id  = d.inst_id
and dg.name = '&1' 
order by dg_name;
set verify 
clear columns
