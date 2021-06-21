undefine tablespace_name
col free heading "Free Space" format 9999999
col freepct heading "%Free" format 999.99
select d.file_name,nvl(f.bytes,0)/1048576 free,d.bytes/1048576 alloc,(nvl(f.bytes,0)/d.bytes)*100 freepct
  from dba_data_files d, dba_free_space f
 where d.tablespace_name = f.tablespace_name(+)
   and d.file_id = f.file_id(+)
   and d.tablespace_name = '&tablespace_name'
/