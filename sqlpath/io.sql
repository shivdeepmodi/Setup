alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS'
set lines 140 pages 10000 col TIME_WAITED_MICRO format 99999999999999999999 col END_INTERVAL_TIME format a30

select	event.snap_id, 
	cast(event.END_INTERVAL_TIME as date) END_INTERVAL_TIME, 
	event.waits_ps, 
	event.av_wait_ms,
	stat.read_req_ps,
	stat.read_mbps,
	stat.write_req_ps,
	stat.write_mbps
from	(
	select	snap_id, 
		max(END_INTERVAL_TIME) END_INTERVAL_TIME, 
		round(sum(TOTAL_WAITS/seconds),0) waits_ps, 
		round((sum(TIME_WAITED_MICRO)/1000)/sum(TOTAL_WAITS),3) av_wait_ms
	from    (
	        select snap_id, instance_number, END_INTERVAL_TIME,
	                TOTAL_WAITS - lag(TOTAL_WAITS,1,0) over ( partition by instance_number order by snap_id ) total_waits,
	                TIME_WAITED_MICRO - lag(TIME_WAITED_MICRO,1,0) over ( partition by instance_number order by snap_id ) TIME_WAITED_MICRO,
			seconds,
			lag(snap_id,1,NULL) over ( partition by instance_number order by snap_id ) lag_snap_id
	        from    (
	                select 	s.snap_id, 
				s.END_INTERVAL_TIME, 
				se.TOTAL_WAITS, 
				se.TIME_WAITED_MICRO, 
				se.instance_number,
				((s.END_INTERVAL_TIME+0) - (s.BEGIN_INTERVAL_TIME+0))*(24*60*60) seconds
	                from    dba_hist_system_event se
	                join    dba_hist_snapshot s
	                on      se.snap_id = s.snap_id
	                and     se.instance_number = s.instance_number
			and     se.dbid = s.dbid
	                where   se.event_name = 'db file sequential read'
                	and     se.dbid = ( select dbid from v$database )
	                )
	        )
	where TOTAL_WAITS > 0
	and	lag_snap_id is not null
	group by snap_id
	) event
join	(
	select	snap_id, 
		round(sum(read_req/seconds),0) read_req_ps, 
		round(sum(read_bytes/seconds)/(1024*1024),2) read_mbps, 
		round(sum(write_req/seconds),0) write_req_ps, 
		round(sum(write_bytes/seconds)/(1024*1024),2) write_mbps
	from (
		select	a.snap_id, 
			snap.end_interval_time, 
			a.instance_number,
			a.value read_req, 
			b.value read_bytes, 
			c.value write_req, 
			d.value write_bytes,
			((snap.END_INTERVAL_TIME+0) - (snap.BEGIN_INTERVAL_TIME+0))*(24*60*60) seconds
		from	(
				select	/*+ full(s) */ s.snap_id, 
					s.dbid,
					s.instance_number, 
					s.value - lag(s.value,1,0) over ( partition by instance_number order by snap_id ) value,
					lag(s.snap_id,1,NULL) over ( partition by s.instance_number order by s.snap_id ) lag_snap_id
				from	sys.WRH$_STAT_NAME nm
				join	sys.WRH$_SYSSTAT s
				on	s.stat_id          = nm.stat_id
				and	s.dbid             = nm.dbid
				where	nm.stat_name = 'physical read total IO requests'
			) a
		join	(
				select	/*+ full(s) */ s.snap_id, 
					s.dbid,
					s.instance_number, 
					s.value - lag(s.value,1,0) over ( partition by instance_number order by snap_id ) value,
					lag(s.snap_id,1,NULL) over ( partition by s.instance_number order by s.snap_id ) lag_snap_id
				from	sys.WRH$_STAT_NAME nm
				join	sys.WRH$_SYSSTAT s
				on	s.stat_id          = nm.stat_id
				and	s.dbid             = nm.dbid
				where	nm.stat_name = 'physical read total bytes'
			) b
		on	a.snap_id = b.snap_id
		and	a.instance_number = b.instance_number
		and	a.dbid = b.dbid
		join	(
				select	/*+ full(s) */ s.snap_id, 
					s.dbid,
					s.instance_number, 
					s.value - lag(s.value,1,0) over ( partition by instance_number order by snap_id ) value,
					lag(s.snap_id,1,NULL) over ( partition by s.instance_number order by s.snap_id ) lag_snap_id
				from	sys.WRH$_STAT_NAME nm
				join	sys.WRH$_SYSSTAT s
				on	s.stat_id          = nm.stat_id
				and	s.dbid             = nm.dbid
				where	nm.stat_name = 'physical write total IO requests'
			) c
		on	a.snap_id = c.snap_id
		and	a.instance_number = c.instance_number
		and	a.dbid = c.dbid
		join	(
				select	/*+ full(s) */ s.snap_id, 
					s.dbid,
					s.instance_number, 
					s.value - lag(s.value,1,0) over ( partition by instance_number order by snap_id ) value,
					lag(s.snap_id,1,NULL) over ( partition by s.instance_number order by s.snap_id ) lag_snap_id
				from	sys.WRH$_STAT_NAME nm
				join	sys.WRH$_SYSSTAT s
				on	s.stat_id          = nm.stat_id
				and	s.dbid             = nm.dbid
				where	nm.stat_name = 'physical write total bytes'
			) d
		on	a.snap_id = d.snap_id
		and	a.instance_number = d.instance_number
		and	a.dbid = d.dbid
		join	dba_hist_snapshot snap
		on	a.snap_id = snap.snap_id
		and	a.instance_number = snap.instance_number
		and	a.dbid = snap.dbid
		where	a.dbid = ( select dbid from v$database )
		and     ( a.value > 0 OR c.value > 0 )
		and	a.lag_snap_id is not null
		and	b.lag_snap_id is not null
		and	c.lag_snap_id is not null
		and	d.lag_snap_id is not null
	)
	group by snap_id
	) stat
on	event.snap_id = stat.snap_id
order by snap_id
/


