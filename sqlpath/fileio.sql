--  fileio.sql
--  Show datafile and tempfile access
rem  Steve Dodsworth - Version 1.0 - 31May95
rem  Steve Dodsworth - Version 2.0 - 25Jul96 - added extra cols
rem  Steve Dodsworth - Version 2.1 - 30Jul96 - added sums
rem  Steve Dodsworth - Version 2.2 - 13Jun00 - renamed, increased length
rem  Steve Dodsworth - Version 3.0 - 23Nov00 - added sub filename
rem  Steve Dodsworth - Version 4.0 - 05Dec00 - added tot io
rem  Steve Dodsworth - Version 5.0 - 18may04 - added tempfile info 

--@sh_log 'DBA'

accept tsname prompt 'Enter tablespace name     : '
accept xpctc prompt  'Percentage read/write > x : ' default -9999999999999999999999999

--spool fileio.out
--@dbname
prompt

prompt Judge whether the datafiles need to be separated onto different disks
prompt by using this output with o/s file structure
prompt Note - figures are physical reads, not cached in memory

--set pagesize 999 verify off linesize 120
set verify off feedback off
clear breaks columns buffer

col ts_name 	format a25 heading 'TableSpace'
col file_id	format 90 heading 'FileID'
col filen	format a50 heading 'File Name'
col fsize	format 999990 heading 'File|Size(M)'
col phyrds	format 9999999990 heading 'Reads'
col phywrts	format 9999999990 heading 'Writes'
col wp		format 990	heading 'Write|%'
col rp		format 990	heading 'Read|%'
col ip		format 990	heading 'I/O|%'
col readtim	format 99990	heading 'Read Tm|Milli'
col writetim	format 9999990	heading 'Wrte Tm|Milli'

-- get totals ready for %
--col tr noprint new_value rtot
--col tw noprint new_value wtot
col tr  new_value rtot
col tw  new_value wtot

set feedback off
select sum(phyrds)/100 tr, sum(phywrts)/100 tw
from   v$filestat fs
/
set feedback on

break on report
compute sum label 'Totals:' of phywrts phyrds phyblkrd phyblkwrt on report
-- compute sum label 'Totals:' of readtim writetim on report
select * from(
select	df.tablespace_name ts_name, df.file_id,
	file_name filen, df.bytes/(1024*1024) fsize,
	phyrds, phywrts,phyrds/&rtot rp, phywrts/&wtot wp,
	(phyrds+phywrts)/(&rtot+&wtot) ip
from  	v$filestat fs, dba_data_files df
where 	fs.file# = df.file_id
and   	df.tablespace_name like upper('&tsname%')
and	(phyrds+phywrts)/(&rtot+&wtot) > &xpctc
union all
-- temp file info
select	df2.tablespace_name ts_name, df2.file_id,
	file_name  filen, df2.bytes/(1024*1024) fsize,
	phyrds, phywrts,phyrds/&rtot rp, phywrts/&wtot wp,
	(phyrds+phywrts)/(&rtot+&wtot) ip
from  	v$filestat fs, dba_temp_files df2
where 	fs.file# = df2.file_id
and   	df2.tablespace_name like upper('&tsname%')
and	(phyrds+phywrts)/(&rtot+&wtot) > &xpctc
union all
select distinct 'REDO' ts_name , null file_id, 
	b.member filen, a.bytes/(1024*1024)fsize,
	null,null,null,null,null
from   v$log a, v$logfile b
where  a.group#=b.group#
)
order by 1
/
set feedback on verify on
--spool off
