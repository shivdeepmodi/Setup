select
	to_char(snap_time,'Mon-dd hh24:mi:ss')	time_stamp,
	total_waits - prev_waits			snap_waits,
	time_waited - prev_time				snap_waited,
	round(
		(time_waited - prev_time) /
		decode(
			(total_waits - prev_waits),
				0,null,
			(total_waits - prev_waits)
		),
		2
	)					wait_average
from
	(
	select	
--	starting query: get current and previous values
--	note: time_waited_micro is the version 9 column
--	and time_waited is the version 8 column.
--	The division by 10,000 converts 9i values centiseconds.
		ss.snap_time,
		se.total_waits,
		lag(se.total_waits,1) over (order by se.snap_id)             prev_waits,
		se.time_waited_micro/10000                                   time_waited,
		lag(se.time_waited_micro/10000,1) over (order by se.snap_id) prev_time
--		se.time_waited                                               time_waited,
--		lag(se.time_waited,1) over (order by se.snap_id)             prev_time
	from
		perfstat.stats$snapshot		ss,
		perfstat.stats$system_event	se
	where
		ss.snap_time between sysdate - 1 and sysdate
	and	se.snap_id = ss.snap_id
	and	se.event = 'db file sequential read'
	--
	--	Technically I should include the DBID and INSTANCE_NUMBER in the
	--	join, as these are part of the primary keys of the two tables.
	--	But most people have just one instance and one database.
	)
where
	total_waits - prev_waits >= 0		-- dirty trick to skip instance restarts
order by
	snap_time
;

