set verify off

Accept howManyDays char prompt 'How Many Days?:'

with myview as
(
 select first_time, round((first_time - (lag(first_time,1) over (order by first_time))) * 1440,0) switch
 from  v$loghist
 where  trunc(first_time) > trunc(sysdate - &&howManyDays)
)
select  'NO.OF SWITCHES' as "LOG SWITCH TIME",
 (select count(1) from myview where switch < 10) "< 5 mins",
 (select count(1) from myview where switch >= 5 and switch < 10) "5-10 mins",
 (select count(1) from myview where switch >= 10 and switch < 20) "10-20 mins",
 (select count(1) from myview where switch >= 20 and switch < 30) "20-30 mins",
 (select count(1) from myview where switch >= 30 and switch < 60) "30-60 mins",
 (select count(1) from myview where switch >= 60) "1 hour+"
from myview
where  trunc(first_time) > trunc(sysdate - &&howManyDays)
and rownum < 2;

set verify on