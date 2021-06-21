-- BU_Sched
-- Access the backup schedule database and give schedule information for it
-- B Davies 	- 25May06 - Initial Version
-- S Dodsworth 	- 26May06 - compressed format

set verify off linesize 120 pages 100

col jobname	format a30 heading 'Job Name'
col tblname	format a20 heading 'Table Name'
col descr	format a50 heading 'Job Description' newline
col odate	heading "Runs On" format a30
col window	format a30 heading 'Backup Window'
col cyc		format a3 heading 'Clc'

accept db prompt  "Enter Database Name like [%]: "

accept bkp prompt "Enter Type of Backup [%]    : "

spool BU_sched.out

select	job_name jobname,
	'Runs '||decode(nvl(w_day_str,'x'),'ALL','Every Day',
			'x','Not Scheduled or Cycl',
			decode(sign(instr(w_day_str ,'1')),1,'Mo ') ||
			decode(sign(instr(w_day_str ,'2')),1,'Tu ') ||
			decode(sign(instr(w_day_str ,'3')),1,'We ') ||
			decode(sign(instr(w_day_str ,'4')),1,'Th ') ||
			decode(sign(instr(w_day_str ,'5')),1,'Fr ') ||
			decode(sign(instr(w_day_str ,'6')),1,'Sa ') ||
			decode(sign(instr(w_day_str ,'0')),1,'Su') 
			) odate,
	'between '||from_time||' to '||to_time window,
	description descr,
	group_name tblname,
	decode (cyclic,0,'NO',1,'YES') cyc
from	emuser.def_job
where	upper(description) like upper('%&bkp%')
and	upper(job_name) like upper('%&db%')
/


spool off

