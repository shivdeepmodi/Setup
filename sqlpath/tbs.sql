set verify off
define tablespace_name=&1
 WITH 
 free_space AS ( SELECT f.tablespace_name , SUM(bytes) free_bytes FROM dba_free_space f where tablespace_name = upper('&tablespace_name') 
                 group by f.TABLESPACE_NAME ) , 
 ts_details AS ( SELECT t.tablespace_name , SUM( CASE WHEN autoextensible = 'YES' THEN maxbytes ELSE bytes END ) tablespace_max_size ,
                 sum(bytes) tablespace_size FROM dba_data_files t where tablespace_name = upper('&tablespace_name') GROUP BY tablespace_name 
				) , 
 m AS ( SELECT ts_details.tablespace_name , ts_details.tablespace_max_size , (ts_details.tablespace_size - NVL(free_space.free_bytes, 0)) used_bytes , nvl(free_space.free_bytes,0) +
      (ts_details.tablespace_max_size - ts_details.tablespace_size) free_bytes , 
	  100*(((ts_details.tablespace_max_size - NVL(free_space.free_bytes, 0)) - (ts_details.tablespace_max_size - ts_details.tablespace_size))/ts_details.tablespace_max_size) used_percent FROM ts_details LEFT OUTER JOIN free_space ON (ts_details.tablespace_name = free_space.tablespace_name) )
select tablespace_name,bigfile,total_gb,used_gb,free_gb,pct_used
from
(
 SELECT m.tablespace_name , bigfile,
 CASE WHEN ROUND(m.tablespace_max_size/power(1024, 3), 2) >= 10000 THEN
           CASE WHEN m.used_percent > 90 AND ROUND(m.free_bytes/power(1024, 3), 2) < 1000 /* free space for 10TB is LT 1TB */
                THEN 'CRITICAL' END
      WHEN ROUND(m.tablespace_max_size/power(1024, 3), 2) < 10000 THEN
           CASE WHEN ROUND(m.used_percent, 2) > 90
                THEN 'CRITICAL' END
      ELSE 'N/A'
 END ALERT ,
 ROUND(m.tablespace_max_size/power(1024, 3), 2) AS total_gb , 
 ROUND(m.used_bytes /power(1024, 3), 2) AS used_gb , 
 ROUND(m.free_bytes/power(1024, 3), 2) free_gb ,
 ROUND(m.used_percent, 2) pct_used 
 FROM m ,  dba_tablespaces t 
 WHERE m.tablespace_name = t.tablespace_name 
   and t.contents not in ('UNDO','TEMPORARY') 
)
/
undefine tablespace_name
set verify on
