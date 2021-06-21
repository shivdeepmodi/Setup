prompt
prompt Tablespace is auto extend with    GB available for allocation
prompt
select ts.tablespace_name table_space,
       round(ts.total_GB) TOTAL_GB,
       round(nvl(us.used_GB,0)) USED_GB,
       round(ts.total_GB - nvl(us.used_GB,0)) FREE_GB,
       round(nvl(us.used_GB,0)/ts.total_GB * 100) PCT_USED from  (select distinct tablespace_name, sum(total_bytes/1024/1024/1024) total_GB
       from (select tablespace_name,file_id, sum(bytes) total_bytes
             from dba_data_files
              where autoextensible='NO' or (bytes >maxbytes and autoextensible='YES')
               group by tablespace_name, file_id
               union all
               select tablespace_name,file_id,sum(maxbytes) total_bytes
               from dba_data_files
               where autoextensible='YES' and maxbytes>=bytes
              group by tablespace_name, file_id)
        group by tablespace_name) ts,
      (select  distinct tablespace_name,sum(bytes/1024/1024/1024) used_GB
      from  dba_segments
      group by tablespace_name) us
where ts.tablespace_name= us.tablespace_name (+) 
and ts.tablespace_name=upper('&1')
order by 5 desc;

