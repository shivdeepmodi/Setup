col BackupDate format a20
col BackupTime format a16

break on BackupType skip 2 on BackupDate

select a.object_type  BackupType, a.end_time BackupDate,
       round(a.output_bytes/1073741824) "GBytes Processed",
       round((a.end_time - a.start_time) * 60 * 24) "Minutes Taken"
  from v$rman_status a
where a.object_type in ('ARCHIVELOG','DATAFILE FULL','DB FULL','CONTROLFILE')
   and a.status='COMPLETED'
   and a.operation='BACKUP'
 order by 1,2
/

clear breaks;