set verify off
Column owner           heading 'Owner'        format a20
Column segment_name    heading 'Segment Name' format a20
Column segment_type    heading 'Segment Type' format a20
Column tablespace_name heading 'Tablespace'   format a15

select owner,segment_name,segment_type,tablespace_name,round(bytes/1048576) MB
  from dba_segments
 where segment_name = upper('&segment_name')
 order by owner
/
set verify on
clear columns