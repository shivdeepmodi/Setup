REM Tablespace report
REM User input required
prompt
Accept pct number prompt 'Give % threshold :' default 0
set termout off feedback off verify off
Column clause  new_value clause
column tablespace_name   heading 'Tablespace'					format a20
column status            heading 'Status'					format a7
column contents          heading 'Contents'					format a9
column extent_management heading 'Extent|Management'			format a10
column allocation_type   heading 'Alloc|Type'					format a7
column ssm               heading 'Segment|Space|Mgt'			format a7
column bytesize          heading 'Allocated|(MB)'				format 9999999.9
column byteused          heading 'Used|(MB)'					format 9999999.9
column used_pct          heading 'Used|(%)'					format 999.9
column bytefree          heading 'Free|(MB)'					format 9999999.9
column free_pct          heading 'Free|(%)'					format 999
column frags             heading 'Frags|(#)'					format 99999
column avail             heading 'Max PE(MB)'					format 9999999


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
compute sum label TOTAL of bytesize byteused bytefree on report 

select *
  from (
select datatemp.tablespace_name,
       tbs.status,
       contents,
       extent_management,
       segment_space_management ssm,
       allocation_type,       
       sum(byte)/1048576 bytesize, 
       (sum(byte)/1048576)- (sum(fbyte)/1048576) byteused,
       round((1-sum(fbyte)/sum(byte))*100,0) used_pct,
       sum(fbyte)/1048576 bytefree, 
       round((sum(fbyte)/sum(byte))*100,0) free_pct,
       sum(frags) frags, 
       sum(largest)/1048576 avail       
  from (select tablespace_name,
               0 byte, 
               sum(bytes) fbyte,
               count(*) frags,
               max(bytes) largest
          from dba_free_space 
         group by tablespace_name
         union
	     select tablespace_name,
		         sum(bytes) byte,
		         0 fbyte,
		         0 frags,
		         0 largest
	       from dba_data_files 
	      group by tablespace_name
	      union all
	     select tablespace_name, 
		         0 byte,
		         0 fbyte,
		         0 frags,
		         0 largest
	       from dba_tablespaces
	      union all
	     select tablespace_name,
		         sum(bytes) byte,
		         0 fbyte,
		         0 frags,
		         0 largest
	       from dba_temp_files
	      group by tablespace_name
	      union all
	     select tablespace_name,
		         0 byte,
		         nvl(bytes_free,0) fbyte,
		         0 frags,
		         0 largest
          from v$temp_space_header
       )  datatemp, dba_tablespaces tbs
 where datatemp.tablespace_name = tbs.tablespace_name
 group by datatemp.tablespace_name,status,contents,extent_management,segment_space_management,allocation_type
 order by datatemp.tablespace_name
       )
  where contents='PERMANENT'
/

set lines 300 verify on
Ttitle off
clear breaks 
clear columns