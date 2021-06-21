set linesize 150
col END_INTERVAL_TIME format a15 tru
col STAT_NAME format a40 tru
col INSTANCE format a10 tru
col begin_interval_time format a15 tru
col end_interval_time format a15 tru
col value format 99999999999
set trimspool on
set trimout on
select
s.snap_id,
to_char(s.BEGIN_INTERVAL_TIME,'DD-MON-YY HH24:MI') begin_interval_time ,
to_char(s.END_INTERVAL_TIME,'DD-MON-YY HH24:MI') end_interval_time ,
a.stat_name,
a.value - b.value value
from 
dba_hist_osstat a,
dba_hist_osstat b,
dba_hist_snapshot s
where
a.SNAP_ID = s.SNAP_ID 
and a.DBID = s.DBID 
and a.snap_id-1 =  b.snap_id
and a.dbid = b.dbid
and a.instance_number = b.instance_number
and a.stat_id = b.stat_id
and a.INSTANCE_NUMBER = 1
and a.stat_name in ('AVG_IOWAIT_TIME')
--and s.begin_interval_time > ( sysdate - 1 )
order by a.stat_name, s.snap_id
/