Column username     format a10
Column osuser       format a10
Column opname       format a33
Column sid          format 9999
Column serial#      format 999999
Column sofar        format 9999999999999
Column totalwork    format 9999999999999
Column "% Complete" format 999.99
Col INPUT_TYPE for a10
col program for a21
col INPUT_BYTES_DISPLAY heading INPUT_BYTES for a15
col INPUT_BYTES_PER_SEC_DISPLAY heading INPUT_BYTES_PER_SEC for a20
col TIME_TAKEN_DISPLAY for a20
set verify off timing off
col status for a12 trunc
/*
select i.inst_id,i.sid,s.serial#,logon_time,sysdate,last_call_et,s.status,block_gets,consistent_gets ,PHYSICAL_READS
  from gv$session s, gv$sess_io i
 where s.program like 'rman%'
   and s.inst_id = i.inst_id
   and s.sid = i.sid
and 1=2
order by 1,2
/
*/
SELECT l.inst_id,l.SID, l.SERIAL#, l.OPNAME, s.username, substr(s.program,1,21) program,l.SOFAR, l.TOTALWORK, ROUND(SOFAR/TOTALWORK*100,2) "% Complete"
  FROM GV$SESSION_LONGOPS l, GV$session s
 WHERE l.inst_id = s.inst_id
   and s.sid=l.sid
   and s.serial#=l.serial#
   AND l.OPNAME  LIKE 'RMAN%'
   AND l.TOTALWORK != 0
   AND l.SOFAR <> l.TOTALWORK
--   AND S.status='ACTIVE'
order by 1
/

col dbsize new_value dbsize
select sum(bytes)/1048576 dbsize from dba_data_files; 


select * From (
select start_time,end_time,round(input_bytes/1048576/1024,2) input_files_gb,
round(output_bytes/1048576/1024,2) output_pieces_gb,status,INPUT_TYPE,ELAPSED_SECONDS
from V$RMAN_BACKUP_JOB_DETAILS
where input_type like 'DB%'
and status <> 'FAILED'
order by 1 desc 
)
where rownum <4
/

--select &&dbsize/1024 from dual;

select start_time,end_time,round(sysdate-start_time,2) days,
--round(input_bytes/1048576/1024,2) input_bytes_gb,
--round(INPUT_BYTES_PER_SEC/1048576,2)INPUT_MB_SEC,
--round(output_bytes/1048576/1024,2) output_pieces_gb,
status,
INPUT_TYPE,
INPUT_BYTES_DISPLAY,INPUT_BYTES_PER_SEC_DISPLAY,
--round((&&dbsize-round(input_bytes/1048576,2))/1024,2) remain_gb,
--round((&&dbsize-round(input_bytes/1048576,2))/1,2) remain_mb,
round( ( (&&dbsize-input_bytes/1048576) / (INPUT_BYTES_PER_SEC/1048576 ) )/3600 ,2)  eta_hh,
--round( round( ( (&&dbsize-input_bytes/1048576) / (INPUT_BYTES_PER_SEC/1048576 ) )/3600 ,2)/24, 2)  eta_dd,
TIME_TAKEN_DISPLAY,
round(ELAPSED_SECONDS/60/60/24,2) ELA_DD
from V$RMAN_BACKUP_JOB_DETAILS
where status = 'RUNNING'
order by 1
/

set timing on verify on
