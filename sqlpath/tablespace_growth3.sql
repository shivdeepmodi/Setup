col SNAP_DATE format a15
col TS_NAME format a20

select 'Database'||','||'Tablespace'||','||'begin_date'||','||'end_date'||','||'no_of_days'||','|| 'alloc_growth'||','||'used_growth'
  from dual;

with growth_trend as
(
select 
db.name DBNAME,
ts.name TS_NAME,
trunc(s.END_INTERVAL_TIME) SNAP_DATE,
max(round((a.tablespace_size*dts.block_size )/(1024*1024),0) ) alloc,
max(round((a.tablespace_usedsize*dts.block_size )/(1024*1024),0)) used,
max(round(a.tablespace_usedsize/a.tablespace_size*100,2)) used_pct
from 
dba_hist_snapshot s, 
dba_hist_tbspc_space_usage  a, 
v$tablespace ts,
dba_tablespaces dts,
v$database db
where 
s.snap_id = a.snap_id
and db.dbid = s.dbid
and a.tablespace_id = ts.ts#
and ts.name = dts.TABLESPACE_NAME
--and ts.name not in ('AUD','AUDITTBS','DBA_TOOLS','DBASPACE','PATROL_TBSP','PERFSTAT',
  --                  'SEMSAUDITDB','SYSTEM','TS_AUDIT_HISTORY','AUDIT_TS','TEMP','SYSAUX') 
--and ts.name not like 'UNDO%' and ts.name not like 'TEMP%'
and s.instance_number=1
and extract(hour from s.END_INTERVAL_TIME) = '07'
group by 
db.name, ts.name,trunc(s.END_INTERVAL_TIME)
order by db.name, ts.name,
trunc(s.END_INTERVAL_TIME)
)
--select be.dbname||','||be.TS_NAME||','||be.snap_date begin_date||','||ee.snap_date end_date||','||(ee.snap_date-be.snap_date) no_of_days||','|| (ee.alloc-be.alloc) alloc_growth||','||(ee.used-be.used) used_growth
select be.dbname,be.TS_NAME,be.snap_date begin_date,ee.snap_date end_date,(ee.snap_date-be.snap_date) no_of_days, (ee.alloc-be.alloc) alloc_growth,(ee.used-be.used) used_growth
  from 
(
select dbname,TS_NAME, snap_date, alloc,used,used_pct 
  from growth_trend 
 where (dbname,TS_NAME, snap_date) in (select dbname,TS_NAME,min(snap_date) from growth_trend group by dbname,TS_NAME)
) be,
(
select dbname,TS_NAME, snap_date, alloc,used,used_pct 
  from growth_trend 
 where (dbname,TS_NAME, snap_date) in (select dbname,TS_NAME,max(snap_date) from growth_trend group by dbname,TS_NAME)
) ee
where be.TS_NAME=ee.TS_NAME
  and be.dbname = ee.dbname
  and be.TS_NAME='&1';
