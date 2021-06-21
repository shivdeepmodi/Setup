set verify off colsep '|' timing on feedback on
select sysdate,'&&host_name' host_name,diskgroup,TOTAL_GB,FREE_GB,PCT_FREE,PCT_USED,THRESHOLD,ADD_RECOMMEND_TB
 from (
SELECT
   (CASE
        WHEN (total_mb/1024) > 60000 THEN
			CASE
			WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) < 10000) THEN 'CRITICAL_GT60T' -- less than 10% should be less than 10TB
			WHEN (free_mb/total_mb*100) > 10 THEN 'NA_GT60T'
            WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) > 10000) THEN 'NA_GT60T'
			END 
		WHEN (total_mb/1024) between 20000 AND 60000 THEN
			CASE
			WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) < 4000 THEN 'CRITICAL_BW_20T_60T'
			WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) > 4000 THEN 'NA_BW_20T_60T'
            ELSE 'NA_BW_20T_60T'
			END 
		WHEN (total_mb/1024) < 20000 AND (free_mb/total_mb*100) < 20 THEN 'CRITICAL_LT20T'
        ELSE 'N/A'
   END) Alert
,  S.NAME diskgroup
,  round(S.TOTAL_MB/1024,2) TOTAL_GB
,  round(S.FREE_MB/1024,2) FREE_GB
,  ROUND(S.free_mb/S.total_mb*100, 2) pct_free
,  ROUND((1-S.free_mb/S.total_mb)*100, 2) pct_used
,  S.STATE
,  S.OFFLINE_DISKS
,   (CASE
        WHEN (total_mb/1024) > 60000 THEN
			CASE
			WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) < 10000) THEN 'GT60T_MIN(10%, 10TB)' -- less than 10% should be less than 10TB
			WHEN (free_mb/total_mb*100) > 10 THEN 'NA_GT6T'
			END 
		WHEN (total_mb/1024) between 20000 AND 60000 THEN
			CASE
			WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) < 4000 THEN 'BW_20T_60T_MIN(20%, 4TB)'
			WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) > 4000 THEN 'NA_BW_20T_60T'
            ELSE 'NA_BW_20T_60T'
			END 
		WHEN (total_mb/1024) < 20000 AND (free_mb/total_mb*100) < 20 THEN 'LT20T_20%'
        ELSE 'N/A'
   END) THRESHOLD
,   (CASE
        WHEN (total_mb/1024) > 60000 THEN
			CASE
			WHEN (free_mb/total_mb*100) < 10 AND ((free_mb/1024) < 10000) THEN ceil(round((10-round(free_mb/1024/1024,2) + 4),2)) -- 4TB above threshold
			WHEN (free_mb/total_mb*100) > 10 THEN 0
			END 
		WHEN (total_mb/1024) between 20000 AND 60000 THEN
			CASE
			WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) < 4000 THEN ceil(round(4-round(free_mb/1024/1024,2) + 2,2)) -- 2TB above threshold
			WHEN (free_mb/total_mb*100) < 20 and (free_mb/1024) > 4000 THEN 0
			END 
		WHEN (total_mb/1024) < 20000 AND (free_mb/total_mb*100) < 20 THEN ceil(round(0.2*total_mb/1048576,2)) -- 20% allocated
        ELSE 0
   END) ADD_RECOMMEND_TB
,v.usage
from
   v$ASM_DISKGROUP_STAT S LEFT OUTER JOIN  V$ASM_VOLUME V
    on (s.group_number = v.group_number)
)
where
ALERT like 'CRITICAL%'
and diskgroup not like '%_CTLLOG%' 
and usage is null
 ;

