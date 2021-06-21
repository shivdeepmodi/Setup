set timing off
col inst_id heading INST for 99
col dest_id heading DEST for 99
col status for a20
col destination for a20
col gap_status for a30
col dest_name for a20
col status for a9
col destination for a25
col error for a30
col STANDBY_LOGFILE_COUNT heading 'STDBY|LOG|CNT' for 999
col STANDBY_LOGFILE_ACTIVE heading 'STDBY|LOG|ACTIVE' for 999
col ARCHIVED_THREAD# heading 'ARCH|THRD#' for 999
col ARCHIVED_SEQ# heading 'ARCH|SEQ#' for 9999999
col APPLIED_THREAD# heading 'APPL|THRD#' for 999
col APPLIED_SEQ# heading 'APPL|SEQ#' for 9999999

Prompt
Prompt =====================================================================================================================================
Prompt ARCHIVE_DEST_STATUS
Prompt =====================================================================================================================================
prompt
prompt CHECK CONFIGURATION - Synchronization with this destination is not possible because
prompt                      this database is either not in MAXIMUM PROTECTION or MAXIMUM AVAIALBILITY data protection mode, or
prompt                      the LOG_ARCHIVE_DEST_n parameter associated with this destination has not been configured with
prompt                      the SYNC and AFFIRM attributes.
prompt
prompt SRL : Indicates whether standby redo logfiles are used on the standby database (YES) or not (NO)
prompt

select inst_id,dest_name,destination,type,status,SRL, DATABASE_MODE, RECOVERY_MODE,PROTECTION_MODE from gv$archive_dest_status where destination is not null;

select inst_id,dest_name,destination,DB_UNIQUE_NAME, STANDBY_LOGFILE_COUNT,STANDBY_LOGFILE_ACTIVE,
       ARCHIVED_THREAD# ,ARCHIVED_SEQ#,APPLIED_THREAD#,APPLIED_SEQ#, gap_status
from gv$archive_dest_status where destination is not null;

select inst_id,dest_name, destination,error, SYNCHRONIZATION_STATUS, SYNCHRONIZED
from gv$archive_dest_status where destination is not null;



Prompt
Prompt =====================================================================================================================================
Prompt ARCHIVE_DEST
Prompt =====================================================================================================================================

col target for a7
col DB_UNIQUE_NAME for a15
SELECT INST_ID,DEST_ID,DESTINATION,DB_UNIQUE_NAME,target,ARCHIVER, STATUS,LOG_SEQUENCE, REGISTER
  FROM GV$ARCHIVE_DEST
 WHERE destination is not null;
 
 SELECT INST_ID,DEST_ID,DB_UNIQUE_NAME,target,TRANSMIT_MODE,VALID_NOW,VALID_TYPE,VALID_ROLE
  FROM GV$ARCHIVE_DEST
 WHERE destination is not null;

 SELECT INST_ID,DEST_ID,DB_UNIQUE_NAME,target,DELAY_MINS,FAIL_DATE,FAIL_SEQUENCE,FAIL_BLOCK,FAILURE_COUNT,ERROR
  FROM GV$ARCHIVE_DEST
 WHERE destination is not null;

/*
column group#        heading 'Group#'        format 99
column thread#       heading 'Thread#'       format 99
column sequence#     heading 'Sequence#'     format 9999999
column member        heading 'Member'        format a40
column archived      heading 'Archived'      format a8
column bytes         heading 'Bytes|(MB)'    format 9999
column status        heading 'Status'        format a8
column instance_name heading 'Instance|Name' format a8

select i.instance_name,l.group#,l.sequence#,l.thread#,f.member,l.archived,l.bytes/1078576 bytes,l.status,f.type, l.first_change#,l.first_time
  from gv$log l, gv$logfile f, gv$instance i
 where l.group# = f.group#
   and l.inst_id = f.inst_id
   and i.inst_id = l.inst_id
   and l.inst_id = l.thread#
   and l.status = 'CURRENT'
 order by i.instance_name,l.thread#,l.group#
/
*/  
--select max(sequence#), thread#, applied from v$archived_log group by thread#, applied order by thread#;
set timing on
