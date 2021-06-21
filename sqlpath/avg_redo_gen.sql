doc
The script assumes that all redo log groups are of the same size
and the size of the archived logs at the log switch is same
#

declare
cl number;
bytes number;
begin

select avg(count(trunc(first_time))) into cl
  from v$loghist
 group by trunc(first_time);

select distinct bytes/1048576 into bytes from v$log;

dbms_output.put_line('Average Redo Generation per day in MB is :'||round(cl*bytes,2));

end;
/
