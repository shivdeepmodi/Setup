--Script to find empty datafiles
set verify off
Column tablespace_name heading 'Tablespace'     format a30
Column file_name       heading 'File Name'      format a40
Column file_id         heading 'File ID#'       format 99999
Column segstat         heading 'Segment Status' format a30

Accept tablespace_name char prompt 'Give tablespace name:'

select distinct d.tablespace_name,d.file_id,
       file_name, case when s.header_file is null then 'No Segment in this file'
                  else 'Segment exist'
                  end segstat
  from dba_segments s,dba_data_files d
 where d.file_id = s.header_file(+)
   and d.tablespace_name = upper('&tablespace_name')
/
set verify on