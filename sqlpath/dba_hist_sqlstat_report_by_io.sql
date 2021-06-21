-- Devloped Yogi - March 2012
-- parameters begin and end sanp Id
PROMPT SEC_PER_EX =>  Seconds per SQL execution
PROMPT PIO_PER_EXEC =>  Physical IO per SQL execution
PROMPT LIO_PER_EXEC =>  Logical IO per SQL execution
PROMPT EXECUTIONS =>  Number of SQL executions

set linesize 150
declare
bsnap number  := &1 ;
esnap number  := &2 ;
--esnap number  := 22241 ;
v_begin_interval_time date;
v_end_interval_time date;
v_snap_number number ;
v_sql_id varchar(13);
v_plan_hash_value number;
v_sql_text char(40);
v_executions number;
v_disk_reads number;
v_cpu_time number;
v_elapsed_time number;
v_buffer_gets number;
v_parsing_schema_name char(20);
cursor c1 (snap number) is
select * from (
select cast(s.begin_interval_time as date), 
       cast(s.end_interval_time as date), 
	   q.sql_id, q.plan_hash_value, 
	   dbms_lob.substr(t.sql_text,40,1),
	   sum(q.EXECUTIONS_DELTA), 
	   round(sum(DISK_READS_delta)/greatest(sum(executions_delta),1)),
       round(sum(BUFFER_GETS_delta)/greatest(sum(executions_delta),1)),
       round((sum(ELAPSED_TIME_delta)/greatest(sum(executions_delta),1)/1000000),1),
       substr(parsing_schema_name,1,20)
  from dba_hist_sqlstat q, dba_hist_snapshot s, dba_hist_sqltext t 
  where s.snap_id = q.snap_id 
    and s.dbid = q.dbid 
	and s.dbid = t.dbid 
	and q.sql_id = t.sql_id 
	and s.instance_number = q.instance_number 
	and s.snap_id = snap 
  group by cast(s.begin_interval_time as date), cast(s.end_interval_time as date), q.sql_id, dbms_lob.substr(t.sql_text,40,1), q.plan_hash_value, parsing_schema_name 
  order by 7 desc
)
where rownum < 30  ;

cursor c2 (snapid number) is
select
substr(to_char(BEGIN_INTERVAL_TIME),1,15)
from dba_hist_snapshot
where snap_id = snapid
and instance_number = 1 ;

cursor c3 (snapid number) is
select
substr(to_char(END_INTERVAL_TIME),1,15)
from dba_hist_snapshot
where snap_id = snapid
and instance_number = 1 ;



begin

dbms_output.put_line('SEC_PER_EX =>  Seconds per SQL execution');
dbms_output.put_line('PIO_PER_EXEC =>  Physical IO per SQL execution');
dbms_output.put_line('LIO_PER_EXEC =>  Logical IO per SQL execution');
dbms_output.put_line('EXECUTIONS =>  Number of SQL executions');

while bsnap <= esnap 
loop

open c1 (bsnap);
loop
fetch c1 into 
v_begin_interval_time,
v_end_interval_time,
v_sql_id, 
v_plan_hash_value,
v_sql_text, 
v_executions,
v_disk_reads, 
v_buffer_gets, 
v_elapsed_time, 
--v_cpu_time, 
v_parsing_schema_name;
exit when c1%notfound;
if ( c1%rowcount = 1 ) then

dbms_output.put_line(chr(10)||'Begin Interval Time: ' || v_begin_interval_time || chr(10) || 'End Interval Time: ' || v_end_interval_time || chr(10));
dbms_output.put_line(
'SQL_ID       ' || ' ' ||
rpad('SQL_TEXT',40,' ') || ' ' || 
lpad('SEC_PER_EXEC',10,' ') || ' ' ||
lpad('PIO_PER_EXEC',15,' ') || ' ' ||
lpad('EXECUTIONS',10,' ') || ' ' ||
lpad('LIO_PER_EXEC',15,' ') || ' ' ||
'PARSING_SCHEMA'
);
dbms_output.put_line('------------------------------------------------------------------------------------------------------------------------------------');
end if;

-- lpad(to_char(v_cpu_time),10,' ') || ' ' ||

dbms_output.put_line(
v_sql_id || ' ' ||
replace(v_sql_text,chr(10),' ') || ' ' || 
lpad(to_char(v_elapsed_time),10,' ') || ' ' ||
lpad(to_char(v_disk_reads),15,' ') || ' ' ||
lpad(to_char(v_executions),10,' ') || ' ' ||
lpad(to_char(v_buffer_gets),15,' ') || ' ' ||
v_parsing_schema_name
);
end loop;
close c1;

bsnap := bsnap + 1 ;

end loop;
end;
/