col INPUT_TYPE for a20
col STATUS format a9
col hrs format 999.99
select
SESSION_KEY, INPUT_TYPE, STATUS,
START_TIME,
END_TIME,
elapsed_seconds/3600 hrs
from V$RMAN_BACKUP_JOB_DETAILS
--where input_type='ARCHIVELOG'
where trunc(START_TIME) >= trunc(sysdate -3)
order by INPUT_TYPE,START_TIME;