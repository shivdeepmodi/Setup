select * from (
SELECT
  (CASE
        WHEN (total_mb/1024) > 60000 THEN
            CASE
            WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) between 9000 and 10000) THEN 'WARNING' 
			WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) < 9000) THEN 'CRITICAL' 
			WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) > 10000) THEN 'N/A'
			ELSE 'N/A_60T'
            END
        WHEN (total_mb/1024) between 20000 AND 60000 THEN
            CASE
            WHEN (free_mb/total_mb*100) < 20 and ((free_mb/1024) between 3000 and 4000) THEN 'WARNING'
			WHEN (free_mb/total_mb*100) < 20 and ((free_mb/1024) < 3000 ) THEN 'CRITICAL'
            WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) > 4000 THEN 'N/A'
			ELSE 'N/A_BW_20T_60T'
            END
        WHEN (total_mb/1024) < 20000 THEN
		    CASE 
			WHEN (free_mb/total_mb*100) between 15 and 20 THEN 'WARNING'
			WHEN (free_mb/total_mb*100) < 15 THEN 'CRITICAL'
			ELSE 'N/A'
			END
     END) Alert
 ,  S.NAME
 ,  S.TOTAL_MB
 ,  S.FREE_MB
 ,  ROUND(S.free_mb/S.total_mb*100, 2) pct_free
 ,  S.STATE
 ,  S.OFFLINE_DISKS
 ,  v.usage
 from  v$ASM_DISKGROUP_STAT s LEFT OUTER JOIN  V$ASM_VOLUME V  on (s.group_number = v.group_number)
, v$parameter p 
where p.name='cluster_database' 
and upper(p.value) = 'TRUE'
and v.usage is null
)
where alert <> 'N/A'
;
