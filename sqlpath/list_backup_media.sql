REM To be run connected as CATALOG owner.

SELECT  db.name "Database",
        bs.bs_key,
        bs.start_time "Backup Start Time",
        bs.completion_time "Backup End Time",
        round(bs.elapsed_seconds/60,1) "Duration(mins)",
        case when bpd.handle like '%auto_ctrl%'
                then 'Controlfile/spfile'
                else decode(bs.backup_type, 'D', 'Full DB', 'I', 'Incremental DB', 'L', 'Archivelog')
        end "Backup Type",bpd.piece#,
        round(bytes/1024/1024,0) "Size(MB)",
        bpd.media "Media",bpd.handle
FROM    rc_database db,
        rc_backup_set bs,
        rc_backup_piece bpd
WHERE   db.db_key = bs.db_key
AND     db.dbid = bs.db_id
AND     bs.bs_key = bpd.bs_key
AND     trunc(bs.start_time) >= trunc(to_date('07-JAN-2012','DD-MON-YYYY'))
AND     trunc(bs.completion_time) < trunc(to_date('08-JAN-2012','DD-MON-YYYY'))
--AND     db.name = upper('POLINK')
and     db.dbid = 2523948160
--and media='RVE820JB'
ORDER BY bs.start_time;
