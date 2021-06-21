--Assuming that backup happens once during a day
select backup_type,min(START_TIME),max(COMPLETION_TIME) ,round((max(COMPLETION_TIME)-MIN(START_TIME))*24*60,2) time_taken
  from V$backup_set  
 where backup_type = 'D'
  group by backup_type,trunc(start_time) order by 1
/

