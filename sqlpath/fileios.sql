rem  fileios.sql
rem  Show disk datafile access on a disk basis
rem  Steve Dodsworth - Version 1.0 - 14feb02
rem  Steve Dodsworth - Version 2.0 - 01jun05 - renamed from diskio.sql, incl tempfiles

--@sh_log 'DBA'

accept tsname prompt 'Enter tablespace name : '
accept iochoi prompt 'Minimum I/O required  : ' default -9999999999999999

--spool fileios.out
--@dbname

prompt
prompt Note - figures are physical reads, not cached in memory

--set pagesize 999 
set feedback off verify off

clear breaks columns buffer

col filen	format a15 heading 'File Name(sub)'
col prds	format 9999999990 heading 'Reads'
col pwrts	format 9999999990 heading 'Writes'
col wp		format	990	heading 'Write|%'
col rp		format 990	heading 'Read|%'
col ip		format 990	heading 'I/O|%'

-- get totals ready for %
col tr noprint new_value rtot
col tw noprint new_value wtot

select sum(phyrds)/100 tr, sum(phywrts)/100 tw
from   v$filestat fs
/

break on report
compute sum label 'Totals:' of pwrts prds on report

select	
substr(file_name,1,instr(file_name,'/',1,3)) filen,
	sum(phyrds) prds, sum(phywrts) pwrts,
	sum(phyrds)/&rtot rp, sum(phywrts)/&wtot wp,
       	sum(phyrds+phywrts)/(&rtot+&wtot) ip
from  	v$filestat fs, dba_data_files df
where 	fs.file# = df.file_id
and   	df.tablespace_name like upper('&tsname%')
group by substr(file_name,1,instr(file_name,'/',1,3))
--having	sum(phyrds+phywrts)/(&rtot+&wtot) > &iochoi
union
select
-- tempfile info
substr(file_name,1,instr(file_name,'/',1,3)) filen,
	sum(phyrds) prds, sum(phywrts) pwrts,
	sum(phyrds)/&rtot rp, sum(phywrts)/&wtot wp,
       	sum(phyrds+phywrts)/(&rtot+&wtot) ip
from  	v$filestat fs, dba_temp_files df
where 	fs.file# = df.file_id
and   	df.tablespace_name like upper('&tsname%')
group by substr(file_name,1,instr(file_name,'/',1,3))
--having	sum(phyrds+phywrts)/(&rtot+&wtot) > &iochoi
order by 1,2
/

--spool off
set feedback on verify on