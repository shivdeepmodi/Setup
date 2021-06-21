select to_char(s.begin_interval_time, 'YYYY-MM-DD HH24'), max(value)/(1024*1024*1024)
from   dba_hist_pgastat p
     , dba_hist_snapshot s
where  name = 'total PGA allocated'
and    s.instance_number = p.instance_number
and    s.snap_id = p.snap_id
group by to_char(s.begin_interval_time, 'YYYY-MM-DD HH24')
order by 1;