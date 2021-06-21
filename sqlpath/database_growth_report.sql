--clear scre
REM desc tsreport 
REM Name           Null? Type        
REM -------------- ----- ------------
REM TABLESPACE           VARCHAR2(30)
REM ALLOCATED            NUMBER
REM USED                 NUMBER
REM FREE                 NUMBER
REM REPORT_DATE          DATE

set verify off

accept begin_date   char prompt 'Enter begin date:'
accept end_date     char prompt 'Enter end   date:'
accept current_date char prompt 'Use current date as end date(y/n)?' default N

column def_begin_date new_value def_begin_date
column begin_date     new_value begin_date
column def_end_date   new_value def_end_date
column end_date       new_value end_date
column current_date   new_value current_date
column title          new_value title
set termout off feedback off
alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';
select distinct min(report_date) as def_begin_date from tsreport;
select decode('&&begin_date',NULL,'&&def_begin_date','&&begin_date') as begin_date from dual;

select distinct max(report_date) as def_end_date from tsreport;
select decode('&&end_date',NULL,'&&def_end_date','&&end_date') as end_date from dual;


select decode(upper('&&current_date'),'Y','Y','N') as current_date from dual;

set termout on


break on report
compute sum label Total of prev_allocated curr_allocated growth on report

col tablespace heading Tablespace for a30
col growth_period                    format a41
col prev_allocated                   format 999999
col curr_allocated                   format 999999
col growth                           format 999999
col pct            heading '%Growth' format a7

set head off
select 'Report Period '||'&&begin_date'||' to '|| '&&end_date' as title from dual;
set head on
select *
  from (
select --b.tablespace,
       decode(e.tablespace,NULL,b.tablespace||'(Dropped wrt to report)',e.tablespace)||
       decode(b.allocated,NULL,'(New addition)',NULL) as tablespace,
       nvl(b.allocated,0) prev_allocated, 
       --b.used      prev_used_size,
       --b.free      prev_free_size,
       nvl(e.allocated,0) curr_allocated,
       --e.used      curr_used_size,
       --e.free      curr_free_size,
       ( nvl(e.allocated,0) - nvl(b.allocated,0) ) growth,
       case when (nvl(e.allocated,0) - nvl(b.allocated,0)) = 0 then to_char(0)
            when (nvl(e.allocated,0) - nvl(b.allocated,0)) < 0 then 'N.A.'
            when ((nvl(e.allocated,0) - nvl(b.allocated,0)) > 0) 
             and nvl(b.allocated,0) > 0 
            then to_char(round(((nvl(e.allocated,0) - nvl(b.allocated,0))/nvl(b.allocated,0))*100,2))
            when ((nvl(e.allocated,0) - nvl(b.allocated,0)) > 0) 
             and nvl(b.allocated,0) = 0 
            then to_char(100)            
        end pct
  from
(
select tablespace,allocated,used,free,report_date
  from tsreport
 where report_date = '&&begin_date'
) b full outer join
(
select tablespace,allocated,used,free,report_date
  from tsreport
 where report_date = '&&end_date'
) e
    on b.tablespace = e.tablespace
       )
 where '&&current_date' = 'N'
 order by tablespace  
 
/


select tablespace,prev_allocated,curr_allocated,growth,pct
  from (
select --b.tablespace,
       decode(e.tablespace,NULL,b.tablespace||'(Dropped wrt to report)',e.tablespace)||
       decode(b.allocated,NULL,'(New addition)',NULL) as tablespace,
       nvl(b.allocated,0) prev_allocated, 
       --b.used      prev_used_size,
       --b.free      prev_free_size,
       nvl(e.allocated,0) curr_allocated,
       --e.used      curr_used_size,
       --e.free      curr_free_size,
       ( nvl(e.allocated,0) - nvl(b.allocated,0) ) growth,
       case when (nvl(e.allocated,0) - nvl(b.allocated,0)) = 0 then to_char(0)
            when (nvl(e.allocated,0) - nvl(b.allocated,0)) < 0 then 'N.A.'
            when ((nvl(e.allocated,0) - nvl(b.allocated,0)) > 0) 
             and nvl(b.allocated,0) > 0 
            then to_char(round(((nvl(e.allocated,0) - nvl(b.allocated,0))/nvl(b.allocated,0))*100,2))
            when ((nvl(e.allocated,0) - nvl(b.allocated,0)) > 0) 
             and nvl(b.allocated,0) = 0 
            then to_char(100)            
        end pct
  from
(
select tablespace,allocated,used,free,report_date
  from tsreport
 where report_date = '&&begin_date'
)    b full outer join
(
select name.tablespace_name tablespace,alloc.bytes/1048576 allocated,(alloc.bytes-free.bytes)/1048576 used, free.bytes/1048576 free
  from (select tablespace_name
         from dba_tablespaces
        --where contents = 'PERMANENT'
        ) name,
       (select tablespace_name,sum(bytes) bytes, 0 free, 0 used   
         from dba_data_files
        group by tablespace_name) alloc,
       (select tablespace_name,0 allocated, sum(bytes) bytes, 0 used
         from dba_free_space
        group by tablespace_name) free
 where name.tablespace_name = alloc.tablespace_name
   and alloc.tablespace_name = free.tablespace_name(+)
) e
    on b.tablespace = e.tablespace
     )
 where '&&current_date' = 'Y'
 order by tablespace
/

clear computes
clear breaks
set feedback on verify on
