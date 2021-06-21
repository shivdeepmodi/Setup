column group#        heading 'Group#'        format 99
column thread#       heading 'Thread#'       format 99
column sequence#     heading 'Sequence#'     format 9999999
column member        heading 'Member'        format a45
column archived      heading 'Archived'      format a8
column bytes         heading 'Bytes|(MB)'    format 9999
column status        heading 'Status'        format a8
column instance_name heading 'Instance|Name' format a8

select i.instance_name,l.group#,l.sequence#,l.thread#,f.member,l.archived,l.bytes/1078576 bytes,l.status, l.first_change#,l.first_time
  from gv$log l, gv$logfile f, gv$instance i
 where l.group# = f.group#
   and l.inst_id = f.inst_id
   and i.inst_id = l.inst_id
 order by i.instance_name,l.thread#
/