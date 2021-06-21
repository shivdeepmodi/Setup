col archive_dest for a50
col error for a60
SELECT DEST_ID, STATUS DB_STATUS,DESTINATION ARCHIVE_DEST,ERROR ERROR
  FROM V$ARCHIVE_DEST 
 WHERE DEST_ID <=3;


column group#        heading 'Group#'        format 99
column thread#       heading 'Thread#'       format 99
column sequence#     heading 'Sequence#'     format 9999999
column member        heading 'Member'        format a40
column archived      heading 'Archived'      format a8
column bytes         heading 'Bytes|(MB)'    format 9999
column status        heading 'Status'        format a8
column instance_name heading 'Instance|Name' format a8

select i.instance_name,l.group#,l.sequence#,l.thread#,f.member,l.archived,l.bytes/1078576 bytes,l.status,f.type, l.first_change#,l.first_time
  from v$log l, v$logfile f, v$instance i
 where l.group# = f.group#
--   and l.inst_id = f.inst_id
--   and i.inst_id = l.inst_id
 --  and l.inst_id = l.thread#
   and l.status = 'CURRENT'
 order by i.instance_name,l.thread#,l.group#
/
   
select max(sequence#), thread#, applied from v$archived_log group by thread#, applied order by thread#;
