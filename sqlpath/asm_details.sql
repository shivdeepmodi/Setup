SELECT SUBSTR(d.name,1,16) AS asmdisk, d.mount_status, d.state, dg.name AS diskgroup 
  FROM V$ASM_DISKGROUP dg, V$ASM_DISK d 
 WHERE dg.group_number = d.group_number;

select NAME,PATH,FREE_MB from v$asm_disk;