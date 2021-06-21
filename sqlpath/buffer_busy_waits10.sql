column object_name format a20
column owner format a20
column object_type format a20
column sample_time format a27
column sql_text format a50
set verify off

prompt Histogram of Buffer Busy Wait
select WAIT_TIME_MILLI, WAIT_COUNT, round((WAIT_COUNT/tot) * 100, 2) pct
from v$event_histogram,
   (select sum(WAIT_COUNT) tot
   from v$event_histogram
   where event = 'buffer busy waits'
   )
where event = 'buffer busy waits'
/

prompt top 5 buffer busy waits
select sql_text, seconds_wait, waits, p1 file#, p2 block#
from v$sql ,
( select * from
  (select p1 , p2 , count(*) waits, sum(time_waited)/1000000 seconds_wait, sql_id
   from V$ACTIVE_SESSION_HISTORY
   where event= 'buffer busy waits'
   group by p1, p2, sql_id
   order by 4 desc)
   where rownum < 6
) a
where a.sql_id = v$sql.sql_id(+)
/
column file# new_value fv
column block# new_value bv
Prompt top waited on block information
select OBJECT_NAME, OBJECT_TYPE, OWNER,
seconds_wait, waits, p1 file#, p2 block#
from dba_objects ,
( select * from
  (select p1 , p2 , count(*) waits, sum(time_waited)/1000000 seconds_wait,
   CURRENT_OBJ#
   from V$ACTIVE_SESSION_HISTORY
   where event= 'buffer busy waits'
   group by p1, p2, CURRENT_OBJ#
   order by 4 desc)
   where rownum < 2
) a
where current_obj# = object_id
/
prompt Times of Break Down Of top waited on Block
select sample_time, TIME_WAITED/1000000 seconds_wait, sql_text
from V$ACTIVE_SESSION_HISTORY outer left join v$sql using(sql_id)
where event= 'buffer busy waits'
and CURRENT_FILE#  = nvl(to_number('&fv'), -1)
and CURRENT_BLOCK# = nvl(to_number('&bv'), -1)
order by 1
/

set verify on