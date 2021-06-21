column owner format a16
column object_name format a36
column start_day format a11
column SIZE_INCREASED format 9999999999999999999
prompt Please Enter timstamp as[20-JUN-2012]
select   obj.owner, obj.object_name,obj.object_type, 
         to_char(sn.BEGIN_INTERVAL_TIME,'DD-MON-RRRR') start_day,
         (sum(a.db_block_changes_delta)*8192)/1024 "SIZE_INCREASED(KB)"
from     dba_hist_seg_stat a,
         dba_hist_snapshot sn,
         dba_objects obj
where    sn.snap_id = a.snap_id
and      obj.object_id = a.obj#
and      obj.owner not in ('SYS','SYSTEM')
and      end_interval_time between to_timestamp('&starttime','DD-MON-RRRR') 
         and to_timestamp('&endtime','DD-MON-RRRR') and 
--a.TS#=12
obj.owner='&username'
group by obj.owner, obj.object_name,obj.object_type,to_char(sn.BEGIN_INTERVAL_TIME,'DD-MON-RRRR')
order by 2 asc,5 desc
/
