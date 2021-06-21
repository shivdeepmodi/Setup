--set termout off
alter session set nls_date_format='DD-MM-YYYY';
--set termout on
with dates as
(select SYSDATE as Today,
        trunc((sysdate-28),'month') as FirstDay    ,
        trim(to_date(last_day(sysdate-28),'DD/MM/YYYY')) as lastday
from dual
) ,
MonthStart   as
( SELECT TO_DATE(TO_CHAR (snpshot.begin_interval_time,'DD-MM-YYYY'),'DD-MM-YYYY') daywise
, dhts.tsname tablespacename
, max(round((dhtsu.tablespace_size* dtblspc.block_size )/(1024*1024*1024),2) ) maximum_allocsize_GB
, max(round((dhtsu.tablespace_usedsize* dtblspc.block_size )/(1024*1024*1024),2)) maximum_usedsize_GB
FROM DBA_HIST_TBSPC_SPACE_USAGE dhtsu
, DBA_HIST_TABLESPACE_STAT dhts
, DBA_HIST_SNAPSHOT snpshot
, DBA_TABLESPACES dtblspc
WHERE dhtsu.tablespace_id= dhts.ts#
AND dhtsu.snap_id = snpshot.snap_id
AND dhts.tsname = dtblspc.tablespace_name
AND dhts.tsname NOT IN ('SYSAUX','SYSTEM','UNDOTBS1','UNDOTBS2','UNDOTBS3')
AND TO_DATE(TO_CHAR (snpshot.begin_interval_time,'DD-MM-YYYY'),'DD-MM-YYYY') = ( select to_date(FirstDay,'DD-MM-YYYY') from dates)
GROUP BY TO_DATE(TO_CHAR (snpshot.begin_interval_time,'DD-MM-YYYY'),'DD-MM-YYYY')
, dhts.tsname
) ,
MonthEnd   as
( SELECT TO_DATE(TO_CHAR (snpshot.begin_interval_time,'DD-MM-YYYY'),'DD-MM-YYYY') daywise
, dhts.tsname tablespacename
, max(round((dhtsu.tablespace_size* dtblspc.block_size )/(1024*1024*1024),2) ) maximum_allocsize_GB
, max(round((dhtsu.tablespace_usedsize* dtblspc.block_size )/(1024*1024*1024),2)) maximum_usedsize_GB
FROM DBA_HIST_TBSPC_SPACE_USAGE dhtsu
, DBA_HIST_TABLESPACE_STAT dhts
, DBA_HIST_SNAPSHOT snpshot
, DBA_TABLESPACES dtblspc
WHERE dhtsu.tablespace_id= dhts.ts#
AND dhtsu.snap_id = snpshot.snap_id
AND dhts.tsname = dtblspc.tablespace_name
AND dhts.tsname NOT IN ('SYSAUX','SYSTEM','UNDOTBS1','UNDOTBS2','UNDOTBS3')
AND TO_DATE(TO_CHAR (snpshot.begin_interval_time,'DD-MM-YYYY'),'DD-MM-YYYY') = ( select to_date(lastday,'DD-MM-YYYY') from dates)
GROUP BY TO_DATE(TO_CHAR (snpshot.begin_interval_time,'DD-MM-YYYY'),'DD-MM-YYYY')
, dhts.tsname
)  ,
TodayFree as
(
SELECT TABLESPACE_NAME tablespacename,
ROUND((USED_SPACE* ( select  value  from v$parameter  where    name like 'db_block_size' ))/1024/1024/1024) USED_SPACE ,
ROUND( (TABLESPACE_SIZE* ( select  value  from v$parameter  where    name like 'db_block_size' )) /1024/1024/1024) TABLESPACE_SIZE ,
ROUND((( TABLESPACE_SIZE-USED_SPACE)*( select  value  from v$parameter  where    name like 'db_block_size' ))/1024/1024/1024) FREE_SPACE  ,
ROUND (USED_PERCENT ,2) USED_PERCENT
from
DBA_TABLESPACE_USAGE_METRICS
) ,
Summary  as
(
select
MonthEnd.tablespacename ,
TodayFree.USED_PERCENT UsedPercent ,
TodayFree.TABLESPACE_SIZE TotalSpace_GB,
TodayFree.FREE_SPACE FreeSpace_GB,
  round(((MonthEnd.maximum_usedsize_GB - MonthStart.maximum_usedsize_GB)/30 * 7)) WeeklyGrowth_GB   ,
  round( (MonthEnd.maximum_usedsize_GB - MonthStart.maximum_usedsize_GB )/30) Avg_Daily_GB ,
  round( MonthEnd.maximum_usedsize_GB - MonthStart.maximum_usedsize_GB )  Proj_30Days_GB ,
round( (MonthEnd.maximum_usedsize_GB - MonthStart.maximum_usedsize_GB )*3)  Proj_90Days_GB
from
MonthEnd ,
MonthStart ,
TodayFree
where
MonthEnd.tablespacename=MonthStart.tablespacename and
TodayFree.tablespacename=MonthEnd.tablespacename and
TodayFree.tablespacename=MonthStart.tablespacename
)
select (select name from v$database ) DB_NAME ,tablespacename ,UsedPercent,TotalSpace_GB ,FreeSpace_GB, round(DECODE(Avg_Daily_GB,0,FreeSpace_GB,FreeSpace_GB / Avg_Daily_GB)) Days_Remaining
,Avg_Daily_GB
,WeeklyGrowth_GB
,Proj_30Days_GB,Proj_90Days_GB
from
Summary where Avg_Daily_GB > 0
order by 2 desc
;
set termout off
--@date.sql
set termout on
