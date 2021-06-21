set doc off
/*
To find difference between two date in hours,minutes or seconds
*/
set doc on verify off
Prompt Script to print difference between two date in seconds[ss], minutes[mi], hours[hh], days[dd]
Prompt
Prompt Enter date in format DD-MON-YYYY
Prompt
Accept p_d1 date prompt 'Give the beginning date      : '
Accept p_d2 date prompt 'Give the end date            : '
Accept p_what    prompt 'Give precesion [ss|mi|hh|dd] : ' default DD
select (to_date('&&p_d2')-to_date('&&p_d1')) * decode( upper('&&p_what'),  
       'SS', 24*60*60, 'MI', 24*60, 'HH', 24,'DD',1, NULL  ) as "Diff in &&p_what"
  from dual; 
set verify on