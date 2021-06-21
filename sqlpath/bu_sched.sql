-- BU_Sched
-- Access the backup schedule database and give schedule information for it
-- B Davies 	- 25May06 - Initial Version
-- S Dodsworth 	- 26May06 - compressed format
--conn jqsuppdba/sm3gh3ad@JQ03
set sqlprompt 'Backup Info >'

set verify off

Column jobname	heading 'Job Name'        format a10 
Column tblname	heading 'Table Name'      format a20 
Column descr	heading 'Job Description' format a50 
Column odate	heading 'Runs On'         format a20
Column window	heading 'Backup Window'   format a20 
Column cyc	heading 'Cyclic'          format a6

prompt ***********************************************************************
prompt NOTE - this script has a password in it - DO NOT send to anyone else
prompt ***********************************************************************

accept db prompt   "Enter Database Name like [%]: "
accept bkp prompt  "Enter Type of Backup [%]    : "
accept xtbl prompt "Enter Part of group name    : "


--spool BU_sched.out

select job_name jobname,
       decode(nvl(w_day_str,'x'),'ALL','Every Day',
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
	group_name tblname,
	decode (cyclic,0,'NO',1,'YES') cyc,
	description descr
  from emuser.def_job
 where upper(description) like upper('%&bkp%')
   and upper(job_name) like upper('%&db%')
   and upper(group_name) like upper('%&xtbl%')
/


--spool off

set verify on