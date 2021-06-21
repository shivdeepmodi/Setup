set verify off colsep '|' timing on feedback on
col target_name for a40
col DISKGROUP for a40
col value for a20
col free_mb for a10
col pct_used for 999.99
col total_mb for a20
col used_mb for a10
col usable_total_mb for a10
col TARGET_TYPE for a20

with asmdata as 
(
select target_name,target_type,host_name,diskgroup,max(trunc(cast (COLLECTION_TIMESTAMP as date))) collection_date,
max(decode(metric_column,'free_mb',value)) free_mb,
max(round(decode(metric_column,'percent_used',value),2)) pct_used,
--max(decode(metric_column,'total_mb',value)) total_mb,
max(decode(metric_column,'usable_file_mb',value)) used_mb,
max(decode(metric_column,'usable_total_mb',value)) total_mb
from
(
SELECT 
mc.target_name,
mc.target_type,
tar.host_name,
mc.key_value diskgroup,
mc.VALUE,
--,mc.metric_name,
mc.collection_timestamp,
mc.metric_column
--,ROW_NUMBER () OVER (PARTITION BY mc.target_name, mc.key_value ORDER BY mc.metric_column)   AS seq
FROM sysman.MGMT$METRIC_CURRENT mc , sysman.MGMT$TARGET tar
where (mc.metric_column IN ('free_mb','usable_file_mb','usable_total_mb','percent_used','diskCnt','total_mb') )
and mc.target_name = tar.target_name
and mc.TARGET_GUID = tar.TARGET_GUID
and mc.TARGET_TYPE = tar.TARGET_TYPE
and mc.target_type in ('osm_instance','osm_cluster')
--mc.target_name in ('+ASM_viv2crs055','+ASM1_viv2p1wvworc948.info.corp','+ASM2_viv2p1wvworc949.info.corp')
--where mc.target_name = '+ASM_lon2whsqaorc005.markit.partners'
--and mc.key_value like 'BMM01PD%'
--and (tar.host_name like 'ams5odcpdorc002%' or tar.host_name like 'lon2whsqaorc005%')
)
group by target_name,target_type,host_name,diskgroup,trunc(cast (COLLECTION_TIMESTAMP as date))
)
select collection_date,host_name ,diskgroup,total_gb,free_gb,(100-pct_used) PCT_FREE,PCT_USED,THRESHOLD,ADD_RECOMMEND_TB
 from (
SELECT collection_date,
   host_name,
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
,  diskgroup
,  round(TOTAL_MB/1024,2) TOTAL_GB
,  round(FREE_MB/1024,2) FREE_GB
,  ROUND(free_mb/total_mb*100, 2) pct_free
,  ROUND((1-free_mb/total_mb)*100, 2) pct_used
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
from asmdata
)
where ALERT like 'CRITICAL%'
and (diskgroup not like '%BACKUP%' and diskgroup not like '%CTLLOG%')
order by diskgroup
 ;

