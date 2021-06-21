REM Tablespace report
REM User input required
prompt
Accept pct number prompt 'Give % threshold :' default 0
set termout off feedback off verify off

Column clause  new_value clause
column tablespace_name   heading 'Tablespace'					format a14
column status            heading 'Status'					format a7
column contents          heading 'Contents'					format a9
column extent_management heading 'Extent|Management'			format a10
column allocation_type   heading 'Alloc|Type'					format a7
column ssm               heading 'Segment|Space|Management'	format a7
column Files             heading 'File|(#)'					format 999
column object_count      heading 'Objects|(#)'				format 9999
column init_ext          heading 'Initial|(KB)'				format 99999
column next_ext          heading 'Next|(KB)'					format 99999
column bytesize          heading 'Size|(MB)'					format 999999
column byteused          heading 'Used|(MB)'					format 999999
column used_pct          heading 'Used|(%)'					format 999.9
column bytefree          heading 'Free|(MB)'					format 9999999
column free_pct          heading 'Free|(%)'					format 999
column frags             heading 'Frags|(#)'					format 99999
column avail             heading 'Max PE(MB)'					format 9999

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
compute sum label TOTAL of files object_count bytesize byteused bytefree on report 

select *
  from (
select /*+CHOOSE*/datatemp.tablespace_name,
       tbs.status,
       contents,
       extent_management,
       segment_space_management ssm,
       allocation_type,       
       sum(FILES) as files,
       sum(obj_cnt) object_count,
       sum(ini_ext) init_ext,
       sum(nex_ext) next_ext,
       sum(byte)/1048576 bytesize, 
       (sum(byte)/1048576)- (sum(fbyte)/1048576) byteused,
       round((1-sum(fbyte)/sum(byte))*100,0) used_pct,
       sum(fbyte)/1048576 bytefree, 
       round((sum(fbyte)/sum(byte))*100,0) free_pct,
       sum(frags) frags, 
       sum(largest)/1048576 avail
  from (select tablespace_name,
               0 obj_cnt,
               0 ini_ext,
               0 nex_ext, 
               0 byte, 
               sum(bytes) fbyte,
               count(*) frags,
               max(bytes) largest,
               0 FILES
          from dba_free_space 
         group by tablespace_name
         union
	     select tablespace_name,
		         0 obj_cnt,
		         0 ini_ext,
		         0 nex_ext,
		         sum(bytes) byte,
		         0 fbyte,
		         0 frags,
		         0 largest,
		         count(file_name) FILES
	       from dba_data_files 
	      group by tablespace_name
	      union 
	     select tablespace_name, 
	            0 obj_cnt,
		         initial_extent/1024 ini_ext,
		         next_extent/1024 nex_ext,
		         0 byte,
		         0 fbyte,
		         0 frags,
		         0 largest,
		         0 FILES
	       from dba_tablespaces
	      union
	     select tablespace_name,
		         0 obj_cnt,
		         0 ini_ext,
		         0 nex_ext,
		         sum(bytes) byte,
		         0 fbyte,
		         0 frags,
		         0 largest,
		         count(file_name) FILES
	       from dba_temp_files
	      group by tablespace_name
	      union
	     select tablespace_name,
		         count(*) obj_cnt,
		         0 ini_ext,
	             0 nex_ext,
		         0 byte,
		         0 fbyte,
		         0 frags,
		         0 largest,
		         0 FILES
          from dba_segments
	      group by tablespace_name
	      union
	     select tablespace_name,
		         0 obj_cnt,
		         0 ini_ext,
		         0 nex_ext,
		         0 byte,
		         nvl(bytes_free,0) fbyte,
		         0 frags,
		         0 largest,
		         0 FILES
          from v$temp_space_header
       )  datatemp, dba_tablespaces tbs
 where datatemp.tablespace_name = tbs.tablespace_name
 group by datatemp.tablespace_name,status,contents,extent_management,segment_space_management,allocation_type
 order by datatemp.tablespace_name
       )
  where &&clause
     
/

set lines 300 verify on
Ttitle off
clear breaks 
--clear columns