Column group_number  heading 'ASM|Disk|Group|#'    format 999
Column disk_number   heading 'ASM|Disk|#'          format 999      
Column name          heading 'ASM Disk Name'       format a23      
Column failgroup     heading 'ASM Disk|Failgroup'  format a15      
Column total_mb      heading 'Total|(MB)'          format 99999    
Column free_MB       heading 'Free|(MB)'           format 99999    
Column mode_status   heading 'Mode|Status'         format a08      
Column mount_status  heading 'Mount|Status'        format a07      
Column mode_status   heading 'Mode|Status'         format a07      
Column state         heading 'Disk|State'          format a08      
Column path          heading 'Disk Path'           format a18      
Column redundancy    heading 'Redundancy' 		   format a10

select group_number,disk_number,name,failgroup,total_mb,free_mb,mount_status,mode_status,state,redundancy,path
  from v$asm_disk
order by name
/
clear columns