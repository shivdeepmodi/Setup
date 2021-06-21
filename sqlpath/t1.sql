rem  tspstats.sql
rem  shows physical and freespace space in datafiles for 7.1+
rem  Steve Dodsworth - Version 1.0 - 25Jun96
rem  Steve Dodsworth - Version 2.0 - 06sep96 - added freespace outer join
rem  Steve Dodsworth - Version 3.0 - 09sep96 - added totals
rem  Steve Dodsworth - Version 4.0 - 06nov96 - correct no freespace prob
rem  Steve Dodsworth - Version 4.1 - 12dec96 - renamed
rem  Steve Dodsworth - Version 5.0 - 11mar97 - put pct free last
rem  Steve Dodsworth - Version 6.0 - 20may98 - added num files
rem  Steve Dodsworth - Version 6.1 - 10apr01 - added free space chunks
rem  Steve Dodsworth - Version 7.0 - 08nov01 - added tsp status
rem  Steve Dodsworth - Version 7.1 - 23jul02 - incr tspsize
rem  Steve Dodsworth - Version 8.0 - 03Feb04 - added 9i info
rem  Ian MacKenzie   - Version 8.1 - 23Mar04 - added more 9i info (temp files)
rem  Ian MacKenzie   - Version 8.1 - 16Apr04 - added more 9i info (extent allocation)

set feedback off verify off heading on linesize 110 pagesize 999 echo off
clear buffer breaks columns

accept tsname           prompt 'Enter Tablespace name: '
accept pctused def 0    prompt 'Enter Pctage Used [0]: '
accept xorder  def 1    prompt 'Enter Sort Order  [1]: '

col tsn format a20	 heading 'TableSpace Name'
col psm format 999990.99 heading 'Physical|Space (Mb)'
col nuf format 9990      heading '#|Dbf'
col fsm format 99990.99  heading 'Total Free|Space (Mb)'
col pcu format 990.99    heading 'Pct|Used'
col tfs format 9990      heading '# Fr|Spce'
col mfs format 99990.99  heading 'Max Free|Chunk (Mb)'
col sts format a4 heading 'Stat'
col con format a5 heading 'Conts'
col ext format a5 heading 'Ext.|Mgmnt'
col alc format a7 heading 'Ext.|Alloc'
col ini format 9999999990 heading 'Uniform|Size (Kb)'

break on report
compute sum of psm fsm nuf on report

select 	a.tablespace_name tsn, 
        a.sts, 
        a.physsp/(1024*1024) psm, 
	a.numfiles nuf,
        nvl(b.freesp,0)/(1024*1024) fsm,
        nvl(b.mfreecnk,0)/(1024*1024) mfs,
        b.totblks tfs,
        100-((100*nvl(b.freesp,0))/a.physsp) pcu,
	initcap(substr(a.con,1,5)) con, 
	initcap(substr(a.ext,1,5)) ext,
	initcap(substr(a.alc,1,7)) alc,
	decode(substr(a.alc,1,7),'UNIFORM',a.ini/1024,null) ini
from   (select b.tablespace_name, 
               sum(a.bytes) physsp, 
	       count(a.file_name) numfiles, 
	       initcap(substr(b.status,1,4)) sts,
	       b.contents con, 
	       b.EXTENT_MANAGEMENT ext,
	       b.ALLOCATION_TYPE alc,
	       b.INITIAL_EXTENT ini
        from   dba_data_files a, 
               dba_tablespaces b
	where  a.tablespace_name = b.tablespace_name
        group  by b.tablespace_name, 
                  initcap(substr(b.status,1,4)),
	          b.contents, 
	          b.EXTENT_MANAGEMENT,
	          b.ALLOCATION_TYPE,
	          b.INITIAL_EXTENT) a,
       (select tablespace_name, 
               sum(bytes) freesp, 
               max(bytes) mfreecnk,
	       count(bytes) totblks
        from   dba_free_space
        group  by tablespace_name ) b
where  b.tablespace_name (+) = a.tablespace_name
and    b.tablespace_name (+) like upper('&tsname%')
and    a.tablespace_name like upper('&tsname%')
and    100-((100*nvl(b.freesp,0))/a.physsp) >= &pctused +0
union
select 	a.tablespace_name tsn, 
        a.sts, 
        a.physsp/(1024*1024) psm, 
	a.numfiles nuf,
        nvl(b.freesp,0)/(1024*1024) fsm,
        nvl(b.mfreecnk,0)/(1024*1024) mfs,
        b.totblks tfs,
        100-((100*nvl(b.freesp,0))/a.physsp) pcu,
	initcap(substr(a.con,1,5)) con, 
	initcap(substr(a.ext,1,5)) ext,
	initcap(substr(a.alc,1,7)) alc,
	decode(substr(a.alc,1,7),'UNIFORM',a.ini/1024,null) ini	
from   (select b.tablespace_name, 
               sum(a.bytes) physsp, 
	       count(a.file_name) numfiles, 
	       initcap(substr(b.status,1,4)) sts,
	       b.contents con, 
	       b.EXTENT_MANAGEMENT ext,
	       b.ALLOCATION_TYPE alc,
	       b.INITIAL_EXTENT ini
        from   dba_temp_files a, 
               dba_tablespaces b
	where  a.tablespace_name = b.tablespace_name
        group  by b.tablespace_name, 
                  initcap(substr(b.status,1,4)),
	          b.contents, 
	          b.EXTENT_MANAGEMENT,
	          b.ALLOCATION_TYPE,
	          b.INITIAL_EXTENT) a,
       (select tablespace_name, 
               sum(bytes_free)   freesp,
               max(bytes_free)   mfreecnk,
               count(decode(bytes_free,0,null,1)) totblks
        from   v$temp_space_header
        group by tablespace_name) b
where  a.tablespace_name like upper('&tsname%')
order by &xorder
/


