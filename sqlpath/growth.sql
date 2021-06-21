Column tablespace_name   heading 'Tablespace'    format a20
Column allocated         heading 'Allocated[MB]' format 999999
Column used              heading 'Used[MB]'      format 999999
Column free              heading 'Free[MB]'      format 999999

set termout off
alter session set nls_Date_format='DD-MON-YY';
column sysdate new_value sysdate
select sysdate from dual;
break on report
compute sum label &sysdate of allocated used free on report
set termout on

select name.tablespace_name,alloc.bytes/1048576 allocated,(alloc.bytes-free.bytes)/1048576 used, free.bytes/1048576 free
  from (select tablespace_name
         from dba_tablespaces
        where contents = 'PERMANENT') name,
       (select tablespace_name,sum(bytes) bytes, 0 free, 0 used   
         from dba_data_files
        group by tablespace_name) alloc,
       (select tablespace_name,0 allocated, sum(bytes) bytes, 0 used
         from dba_free_space
        group by tablespace_name) free
 where name.tablespace_name = alloc.tablespace_name
   and alloc.tablespace_name = free.tablespace_name(+)
/
clear breaks
set termout off
@date
set termout on