set verify off
select
trunc(b.END_INTERVAL_TIME) SNAP_TIME,
--a.INSTANCE_NUMBER,
a.RESOURCE_NAME,
--CURRENT_UTILIZATION CURRENT_U,
max(MAX_UTILIZATION) MAX_UTILIZATION,
max(INITIAL_ALLOCATION) INITIAL_ALLOCATION,
max(LIMIT_VALUE) LIMIT_VALUE
from DBA_HIST_RESOURCE_LIMIT a , DBA_HIST_SNAPSHOT b
where lower(a.RESOURCE_NAME) like '%' || lower('&resource_name')  || '%' and 
a.INSTANCE_NUMBER = b.INSTANCE_NUMBER
and a.SNAP_ID = b.SNAP_ID
group by
trunc(b.END_INTERVAL_TIME),
--a.INSTANCE_NUMBER,
RESOURCE_NAME
order by trunc(b.END_INTERVAL_TIME)
/
set verify on