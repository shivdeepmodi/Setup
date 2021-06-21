REM Space report for a filesystem
REM On database level only
REM User input required
set verify off

Accept file_name char Prompt 'Give the data file part :'

Ttitle left 'Space Report for file system &&file_name'  skip 2

Column tablespace_name heading 'Tablespace'                   format a15
Column file_name       heading 'Data File Name'               format a42
Column contents        heading 'Contents'                     format a9
Column status          heading 'Status'                       format a10
Column file_size       heading 'Allocated|File Size|(MB)'     format 9999999
Column free_space      heading 'Free Space|in File|(MB)'      format 9999999
Column used_space      heading 'Used Space|in File|(MB)'      format 9999999
Column free_pct        heading 'Free Space|in File|(%)'       format 999
Column largest_ext     heading 'Max PE (MB)' format 9999999
Column autoext         heading 'Auto|Ext'              format a4

break on report
compute sum label TOTAL of file_size free_space used_space on report

select /*choose */ tablespace_name,file_name,file_size,free_space,used_space,free_pct,largest_ext,autoext,contents,status
  from (
select c1.tablespace_name                      tablespace_name,
       c2.name                                 file_name,
       tbs.contents                            contents,
       c2.status                               status,
       c1.autoextensible                       autoext,
       ROUND(c2.bytes/1048576,0)               file_size, 
       ROUND(c1.free/1048576,0)                free_space,
       ROUND(((c2.bytes)-(c1.free))/1048576,0) used_space,
       ROUND(((c1.free/c2.bytes)*100),0)       free_pct,
       ROUND(c1.largeextent/1024/1024,0)       largest_ext
from   ( select d.tablespace_name, d.file_id, d.file_name,
                d.autoextensible, nvl(max(s.bytes),0) largeextent, nvl(sum(s.bytes),0) free
           from dba_free_space s, dba_data_files d                                                     
          where d.file_id = s.file_id (+)                                                              
	    and d.tablespace_name = s.tablespace_name(+)                                               
	  group by d.tablespace_name, d.file_id, d.file_name, d.autoextensible
	  order by d.tablespace_name, d.file_id) c1,
        (select file#, status,name,bytes
	   from v$datafile
        ) c2,
        dba_tablespaces tbs
 where c1.file_id = c2.file#
   and c1.file_name like '%&&file_name%'
   and tbs.tablespace_name = c1.tablespace_name
union
select v.tablespace_name                       tablespace_name,
       t.file_name                             file_name,
       tbs.contents                            contents,
       t.status                                status,
       t.autoextensible                        autoext,
       ROUND(t.bytes/1048576,0)                file_size,
       ROUND(v.bytes_free/1048576,0)           free_space,
       ROUND(v.bytes_used/1048576,0)           used_space,
       ROUND(v.bytes_free/t.bytes*100,0)       free_pct,
       ROUND(v.bytes_free/1048576,0)           largest_ext
  from dba_temp_files t, v$temp_space_header v, dba_tablespaces tbs
 where t.file_id = v.file_id
   and t.tablespace_name = v.tablespace_name
   and tbs.tablespace_name = t.tablespace_name
   and t.file_name like '%&&file_name%'
       )
 order by tablespace_name
/
Ttitle off
set verify on
clear columns
clear breaks