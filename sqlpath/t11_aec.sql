column db_unique_name new_value db_unique_name
column host_name new_value host_name
col DB_NAME for a20
column host_name for a20
column database_role new_value database_role
set termout off timing on
select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name
from gv$instance;
select database_role from v$database;
set verify off termout on
 WITH 
 free_space AS ( SELECT /*+ materialize */ f.tablespace_name , SUM(bytes) free_bytes FROM dba_free_space f group by f.TABLESPACE_NAME ) , 
 ts_details AS ( SELECT /*+ materialize */ t.tablespace_name , SUM( CASE WHEN autoextensible = 'YES' THEN maxbytes ELSE bytes END ) tablespace_max_size ,
                 sum(bytes) tablespace_size FROM dba_data_files t GROUP BY tablespace_name 
				) , 
 m AS ( SELECT /*+ materialize use_hash(free_space,ts_details) */ 
            ts_details.tablespace_name , ts_details.tablespace_max_size , 
            (ts_details.tablespace_size - NVL(free_space.free_bytes, 0)) used_bytes , nvl(free_space.free_bytes,0) +
            (ts_details.tablespace_max_size - ts_details.tablespace_size) free_bytes , 
	         100*(((ts_details.tablespace_max_size - NVL(free_space.free_bytes, 0)) - (ts_details.tablespace_max_size - ts_details.tablespace_size))/ts_details.tablespace_max_size) used_percent 
      FROM ts_details LEFT OUTER JOIN free_space ON (ts_details.tablespace_name = free_space.tablespace_name) )
select '&&db_unique_name' db_name,'&&database_role' database_role,'&&host_name' host_name,
       tablespace_name,bigfile,total_gb,used_gb,free_gb,pct_used
from
(
 SELECT /*+ use_hash(m,t) */ m.tablespace_name , bigfile,
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
ORDER BY tablespace_name;
