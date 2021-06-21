Accept fname char Prompt 'Give spool file: ' DEFAULT awr1.html
Accept days number Prompt 'List Snapshot for days ? n[2] :' DEFAULT 2
set termout off
column dbid new_value dbid
Column instance_number new_value instance_number
select dbid as dbid from v$database;
select instance_number as instance_number from v$instance;
set termout on verify off


select BEGIN_INTERVAL_TIME,SNAP_ID from dba_hist_snapshot
 where trunc(BEGIN_INTERVAL_TIME) >= sysdate - &days
 order by BEGIN_INTERVAL_TIME
/

Accept begi number Prompt 'Begin Snap ID  :'
Accept ends number Prompt 'Begin Snap ID  :'
set feedback off head off
spool &fname
SELECT output FROM TABLE(
   DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(
     &&dbid,  &instance_number, &begi, &ends,8) )
/
spool off
set verify on feedback on head on
