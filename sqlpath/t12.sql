REM Tablespace report
REM User input required
prompt
Accept pct number prompt 'Give % threshold :' default 0
set termout off feedback off verify off

Column bigfile new_value bigfile
Column clause  new_value clause
column tablespace_name   heading 'Tablespace'					format a20
column status            heading 'Status'					format a7
column contents          heading 'Contents'					format a9
column extent_management heading 'Extent|Management'			format a10
column allocation_type   heading 'Alloc|Type'					format a7
column ssm               heading 'Segment|Space|Mgt'			format a7
column allocated_space          heading 'Allocated|(MB)'				format 9999999.9
column used_space          heading 'Used|(MB)'					format 9999999.9
column used_pct          heading 'Used|(%)'					format 999.9
column free_space          heading 'Free|(MB)'					format 9999999.9
column free_pct          heading 'Free|(%)'					format 999
column frags             heading 'Frags|(#)'					format 99999
column maxposs             heading 'Max PE(MB)'					format 9999
Column bigfile           heading 'Bigfile'					format a7


select case count(*)
       when 1 then 'bigfile'
       else ''''||'N.A.'||''''
        end bigfile
  from dba_tab_columns 
 where table_name = 'DBA_TABLESPACES' 
   and column_name = 'BIGFILE';

select case when &&pct = 0 then '1=1'
            when &&pct = 100 then 'used_pct=100'
            when &&pct > 100 then 'used_pct=100'
            else 'used_pct > &&pct'
        end clause
  from dual;

set termout on feedback on

set lines 150
Ttitle center "Tablespace report"  skip 2

break on report
compute sum label TOTAL of allocated_space used_space free_space on report 

select *
  from (
 select tbs.tablespace_name,tbs.status,tbs.contents,tbs.extent_management,tbs.ssm,tbs.allocation_type,
       dat.allocated_space,
       dat.allocated_space - free.free_space used_space,
       round((dat.allocated_space - free.free_space)/dat.allocated_space*100,2) used_pct,
       free.free_space free_space,
       round(free.free_space/dat.allocated_space*100,2) free_pct,free.frags frags,
       free.maxposs,tbs.bigfile
from   (
         select tablespace_name, contents, status,&&bigfile bigfile,extent_management,segment_space_management ssm,allocation_type
           from dba_tablespaces
       ) tbs,
       (
         select tablespace_name, sum(bytes)/1048576 allocated_space
           from dba_data_files
          group by tablespace_name
       ) dat,
       (
         select tbs.tablespace_name, nvl(sum(bytes)/1048576,0) free_space, round(nvl(max(bytes)/1048576,0),0) maxposs,
		        count(*) frags
           from dba_free_space free, dba_tablespaces tbs
          where tbs.tablespace_name = free.tablespace_name(+)
          group by tbs.tablespace_name
       ) free
 where tbs.tablespace_name = dat.tablespace_name
   and dat.tablespace_name = free.tablespace_name
 union all
select tbs.tablespace_name,tbs.status,tbs.contents,tbs.extent_management,tbs.ssm,tbs.allocation_type,
       temp.allocated_space,
       v.used_space,
       round(v.used_space/temp.allocated_space*100,0) used_pct,
       v.free_space,
       round(v.free_space/temp.allocated_space*100,0) free_pct,tbs.frags frags,
       v.maxposs maxposs,tbs.bigfile
  from (
         select tablespace_name,contents,status,&&bigfile bigfile,extent_management,segment_space_management ssm,allocation_type, 0 frags
           from dba_tablespaces
		  where contents = 'TEMPORARY'
       ) tbs,
       (
         select tablespace_name,sum(bytes)/1048576 allocated_space
           from dba_temp_files
          group by tablespace_name
       ) temp,
       (
         select tablespace_name,sum(bytes_used)/1048576 used_space, 
                sum(bytes_free)/1048576 free_space, sum(bytes_free)/1048576 maxposs
           from v$temp_space_header
          group by tablespace_name
       ) v
 where tbs.tablespace_name = temp.tablespace_name
   and temp.tablespace_name = v.tablespace_name
       )
 where &&clause
/

set lines 300 verify on
Ttitle off
clear breaks 
clear columns