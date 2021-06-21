define db_unique_name=&1
select diskgroup,TOTAL_GB,FREE_GB,PCT_FREE,PCT_USED
 from (
SELECT
   (CASE
        WHEN (total_mb/1024) >= 2000 AND (free_mb/1024) < 2000 THEN 'CRITICAL'
                WHEN (total_mb/1024) < 2000 AND (free_mb/total_mb*100) < 10 THEN 'CRITICAL'
                WHEN (free_mb/total_mb*100) between 10 and 20 THEN 'WARNING'
        ELSE 'N/A'
   END) Alert
,  S.NAME diskgroup
,  round(S.TOTAL_MB/1024,2) TOTAL_GB
,  round(S.FREE_MB/1024,2) FREE_GB
,  ROUND(S.free_mb/S.total_mb*100, 2) pct_free
,  ROUND((1-S.free_mb/S.total_mb)*100, 2) pct_used
,  S.STATE
,  S.OFFLINE_DISKS
,v.usage
from
  v$ASM_DISKGROUP_STAT S, V$ASM_VOLUME V
where s.group_number = v.group_number(+)
  and s.name in (select a.name from v$asm_diskgroup_stat a, v$asm_client b where a.group_number = b.group_number and b.db_name = substr('&&db_unique_name',1,8))
)
where
usage is null
 ;

