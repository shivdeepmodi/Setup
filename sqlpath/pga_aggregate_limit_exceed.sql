/*
It appears that some sessions have died, but the process related to them still exists and is still using PGA. This can be seen from the following query: 
*/
 select spid os_pid, round(PGA_ALLOC_MEM/(1024*1024),0) PGA_MB from 
 v$process where addr not in ( select paddr from v$session ) and pname is null and spid is not null order by 2; 