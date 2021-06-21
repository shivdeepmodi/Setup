/* Comments Purpose: metric extension to return free space for each tablespace 
Logic: for each tablespace obtain the following. 
1. size that the tablespace is currently (ts_details.tablespace_size) 
2. amount of free space if any (free_space.free_bytes) 
3. size tablespace could grow to allowing for autoextend, but NOT disk space (ts_details.tablespace_max_size) Total free space is nvl(free_space.free_bytes,0) + (ts_details.tablespace_max_size - ts_details.tablespace_size) i.e any free space, plus any potential file growth Total Used space is current_size minus current free space in files. PCT Used is however expressed as used space as a percentage of the total possible size of the tablespace this can result in very low figures for big file tablespaces. */
 WITH 
 free_space AS ( SELECT f.tablespace_name , SUM(bytes) free_bytes FROM dba_free_space f group by f.TABLESPACE_NAME ) , 
 ts_details AS ( SELECT t.tablespace_name , SUM( CASE WHEN autoextensible = 'YES' THEN maxbytes ELSE bytes END ) tablespace_max_size ,
                 sum(bytes) tablespace_size FROM dba_data_files t GROUP BY tablespace_name 
				) , 
 m AS ( SELECT ts_details.tablespace_name , ts_details.tablespace_max_size , (ts_details.tablespace_size - NVL(free_space.free_bytes, 0)) used_bytes , nvl(free_space.free_bytes,0) +
      (ts_details.tablespace_max_size - ts_details.tablespace_size) free_bytes , 
	  100*(((ts_details.tablespace_max_size - NVL(free_space.free_bytes, 0)) - (ts_details.tablespace_max_size - ts_details.tablespace_size))/ts_details.tablespace_max_size) used_percent FROM ts_details LEFT OUTER JOIN free_space ON (ts_details.tablespace_name = free_space.tablespace_name) )
 SELECT m.tablespace_name , bigfile,
 CASE WHEN m.used_percent > 90 
      THEN CASE /* check free space < 30gb ie one datafile */ WHEN m.free_bytes/power(1024, 3) > 30 
	       THEN 'WARNING' ELSE 'CRITICAL' END
      WHEN m.used_percent > 80 
	  THEN 'WARNING' /* always warn < 20 free */
	  WHEN m.used_percent <= 80 THEN '' /* in case nagios needs this */ 
 END ALERT , 
 ROUND(m.used_bytes /power(1024, 3), 2) AS used_gb , 
 ROUND(m.tablespace_max_size/power(1024, 3), 2) AS size_gb , 
 ROUND(m.used_percent, 2) pct_used , 
 ROUND(m.free_bytes/power(1024, 3), 2) free_gb 
 FROM m ,  dba_tablespaces t  -- v$parameter p
 WHERE m.tablespace_name = t.tablespace_name 
   and t.contents not in ('UNDO','TEMPORARY') 
   --AND p.name = 'cluster_database' 
   --AND upper(p.value) = 'TRUE' 
   ORDER BY ALERT ASC;

