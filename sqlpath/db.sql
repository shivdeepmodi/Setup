column host_name        format a35
column status           format a10
column logins           format a10
column startup_time     format a20
column platform_name    format a23
column flashback_on     format a22
column created          format a20
column resetlogs_time   format a20
column log_mode         format a12
column name             format a33
column value            format a90

set termout off

/*select decode(max(column_name),'PLATFORM_NAME','PLATFORM_NAME',NULL,''''||'Unable to determine platform'||'''') as platform
from dba_tab_columns
where table_name = 'V_$DATABASE'
  and column_name = 'PLATFORM_NAME'
/

select decode(max(column_name),'FLASHBACK_ON','FLASHBACK_ON',NULL,''''||'Not Possible'||'''') as flashback
from dba_tab_columns
where table_name = 'V_$DATABASE'
  and column_name = 'FLASHBACK_ON'; */

set termout on

select host_name,log_mode,platform_name,flashback_on,resetlogs_time,status,created
  from v$instance, v$database;

select name,value
  from v$parameter
 where name in ('cluster_database','compatible',
--'cursor_sharing','workarea_size_policy','pga_aggregate_target',
--                'optimizer_mode',
'db_unique_name',
--'diagnostic_dest',
'db_recovery_file_dest','db_recovery_file_dest_size','log_archive_config',
                'local_listener', 'remote_listener')
 order by name
/

