REM Tablespace and the corresponding datafile/tempfile report
REM No user input required
set lines 140
Ttitle center "Tablespace and the corresponding datafile/tempfile report"  skip 2

break on report

Column tablespace    heading "Tablespace"                   format a17
Column file_name     heading "Data File Name"               format a43
Column status        heading "File|Status"                       format a10
Column file_size     heading "Allocated|File Size|(MB)"     format 9999999
Column free_space    heading "Free Space|in File|(MB)"      format 99999
Column used_space    heading "Used Space|in File|(MB)"      format 9999999
Column free_pct      heading "Free Space|in File|(%)"       format 999.9
Column largest_ext   heading "Largest|Avail Extent|(MB)"    format 99999.9
Column autoext       heading "Auto|Extensible"              format a10

Compute sum label Total of file_size free_space used_space on report
select * from (
select c1.tablespace_name                      tablespace,
       c2.file_name                            file_name,
       c2.status                               status,
       c2.autoextensible                       autoext, 
       ROUND(c2.bytes/1048576,0)               file_size, 
       ROUND(c1.free/1048576,0)                free_space,
       ROUND(((c2.bytes)-(c1.free))/1048576,0) used_space,
       ROUND(((c1.free/c2.bytes)*100),0)       free_pct,
       ROUND(c1.largeextent/1024/1024,0)       largest_ext
from   ( select d.tablespace_name, d.file_id, nvl(max(s.bytes),0) largeextent, nvl(sum(s.bytes),0) free
           from dba_free_space s, dba_data_files d                                                     
          where d.file_id = s.file_id (+)                                                              
            and d.tablespace_name = s.tablespace_name(+)                                               
          group by d.tablespace_name, d.file_id                                                        
          order by d.tablespace_name, d.file_id) c1,
        (select file_id,file_name,status,bytes,autoextensible
           from dba_data_files
        ) c2
 where c1.file_id = c2.file_id
union
select c1.tablespace_name                                             tablespace_name,
       c2.file_name                                                   file_name,
       c2.status                                                      status,
       c2.autoextensible                                              autoext,
       ROUND((c1.bytes_free + c1.bytes_used)/1048576,0)               file_size,
       ROUND(c1.bytes_free/1048576,0)                                 free_space,
       ROUND(c1.bytes_used/1048576,0)                                 used_space,
       ROUND(c1.bytes_free/(c1.bytes_free + c1.bytes_used)/1048576,0) free_pct,
       0                                                              largest_ext
  from v$temp_space_header c1, dba_temp_files c2
 where c1.file_id = c2.file_id
)
where tablespace=upper('&1')
/
Ttitle off
set lines 300
clear columns
clear breaks
