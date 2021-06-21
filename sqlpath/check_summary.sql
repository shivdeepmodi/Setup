REM Generic script to find summary of non-standard issues
REM Shivdeep Modi
REM
clear screen
store set tempcheck.out replace
set lines 300 feedback off head off pages 120
set null ''

spool check_summary_&&_connect_identifier..lst
Prompt =======================================================================
Prompt Beginning of Summary Report
Prompt =======================================================================
Prompt
Prompt =======================================================================
Prompt Checking for DBA role granted to non-admin users
Prompt =======================================================================

select case 
       when count(granted_role) = 0 then 'OK. No non admin user having DBA role'
       when count(granted_role) > 0 then 'Non admin user having DBA role found. '||'Run detailed report'
       end
  from dba_role_privs
 where granted_role in ('DBA')
   and grantee not in ('SYS','SYSTEM','NCLDBA');

Prompt
Prompt =======================================================================
Prompt Checking for non-standard roles 
Prompt =======================================================================

select case 
       when count(granted_role) = 0 then 'OK. No non-standard roles granted to users'
       when count(granted_role) > 0 then 'Non-standard roles have been granted to users. '||'Run detailed report'
       end
  from dba_role_privs
 where granted_role in ('CONNECT','RESOURCE')
   and grantee not in ('SYS','SYSTEM','NCLDBA','RMAN');
 
Prompt 
Prompt =======================================================================
Prompt Checking for grants to PUBLIC
Prompt =======================================================================

select case 
       when count(privilege) = 0 then 'OK. No grants to PUBLIC'
       when count(privilege) > 0 then 'Grants to PUBLIC found. '||'Run detailed report'
       end
  from dba_tab_privs
 where grantee = 'PUBLIC'
   and owner not in ('SYS','SYSTEM')
   and owner not like 'IMDD%';
 
Prompt
Prompt =======================================================================
Prompt Checking for dictionary managed tablespaces excluding SYSTEM
Prompt =======================================================================

select case 
       when count(tablespace_name) = 0 then 'OK. No tablespaces are dictionary managed'
       when count(tablespace_name) > 0 then 'Dictionary managed tablespaces found. '||'Run detailed report'
       end
  from dba_tablespaces
 where tablespace_name not in ('SYSTEM')
   and extent_management = 'DICTIONARY';

Prompt
Prompt =======================================================================
Prompt Checking for autoextensible datafiles/tempfiles
Prompt =======================================================================

select case 
       when count(autoextensible) = 0 then 'OK. No datafiles/tempfiles are autoextensible'
       when count(autoextensible) > 0 then 'Autoextensible datafiles/tempfiles found. '||'Run detailed report'
       end
  from (
select tablespace_name,file_name,autoextensible
  from dba_data_files
 where autoextensible = 'YES'
 union 
select tablespace_name,file_name,autoextensible
  from dba_temp_files
 where autoextensible = 'YES'
 );

Prompt
Prompt =======================================================================
Prompt Checking for offline datafiles/tempfiles
Prompt =======================================================================

select case
       when count(status) = 0 then 'OK. No datafiles/tempfiles are offline'
       when count(status) > 0 then 'Offline datafiles/tempfiles found. '||'Run detailed report'
       end
  from (
select status
  from dba_data_files
 where status != 'AVAILABLE'
 union
select status
  from dba_temp_files
 where status != 'AVAILABLE'  
  );

Prompt
Prompt =======================================================================
Prompt Checking for automatic undo management
Prompt =======================================================================

select case
       when count(value) = 0 then 'OK. Automatic Undo Management'
       when count(value) > 0 then 'Manual Undo Management'
       end
  from v$parameter
 where name = 'undo_management'
   and value = 'MANUAL';

Prompt
Prompt =======================================================================
Prompt Checking for job_queue_process if count(*) from dba_jobs > 0
Prompt =======================================================================

select case
       when count(*) = 0 then 'OK. job_queue_process has been setup for jobs'
       when count(*) > 0 then 'job_queue_process = 0 but jobs have been setup. '||'Run detailed report'
       end
  from v$parameter 
 where name = 'job_queue_processes'
   and value = to_char(0)
   and exists(select job from dba_jobs)
/

Prompt
Prompt =======================================================================
Prompt Checking for non system segments in SYSTEM tablespace
Prompt =======================================================================

select case
       when count(owner) = 0 then 'OK. No non system segments in SYSTEM tablespace'
       when count(owner) > 0 then 'Non system segments found in SYSTEM tablespace. '||'Run detailed report'
       end
  from dba_segments
 where tablespace_name = 'SYSTEM'
   and owner not in ('SYS','SYSTEM','OUTLN');

Prompt
Prompt =======================================================================
Prompt Checking for users having SYSTEM as their default tablespace
Prompt =======================================================================

select case
       when count(username) = 0 then 'OK. No non system users have SYSTEM as default tablespace'
       when count(username) > 0 then 'Non system users have SYSTEM as default tablespace. '||'Run detailed report'
       end
  from dba_users
 where default_tablespace = 'SYSTEM'
   and username not in ('SYS','SYSTEM','OUTLN');

Prompt
Prompt =======================================================================
Prompt Checking for users having SYSTEM as their temp tablespace
Prompt =======================================================================

select case
       when count(username) = 0 then 'OK. No users have SYSTEM as their temporary tablespace'
       when count(username) > 0 then 'Users found having SYSTEM as their temporary tablespace. '||'Run detailed report'
       end
  from dba_users
 where temporary_tablespace = 'SYSTEM'
   and username not in ('SYS','SYSTEM');
 
Prompt
Prompt =======================================================================
Prompt Checking for users having DEFAULT profile
Prompt =======================================================================

select case
       when count(username) = 0 then 'OK. No users have DEFAULT profile'
       when count(username) > 0 then 'Users found having DEFAULT profile. '||'Run detailed report'
       end
  from dba_users
 where profile = 'DEFAULT'
   and username not in ('SYS','SYSTEM');

Prompt
Prompt =======================================================================
Prompt Checking for datafile/tempfile not having tablespace name in their name
Prompt =======================================================================

select case 
       when count(pos) = 0 then 'OK. All datafiles/tempfiles have tablespace name in their names'
       when count(pos) > 0 then 'Datafiles/tempfiles not having tablespace name in their names found. '||'Run detailed report'
       end
 from  (
select instr(upper(file_name),upper(tablespace_name),1) pos 
  from dba_data_files
 where instr(upper(file_name),upper(tablespace_name),1) = 0
 union
select instr(upper(file_name),upper(tablespace_name),1) pos 
  from dba_temp_files
 where instr(upper(file_name),upper(tablespace_name),1) = 0 
);

Prompt
Prompt =======================================================================
Prompt Checking for invalid objects
Prompt =======================================================================

select case
       when count(*) = 0 then 'OK. No invalid objects'
       when count(*) > 0 then 'Invalid objects found. '||'Run detailed report'
       end
  from dba_objects
 where status = 'INVALID';

Prompt
Prompt =======================================================================
Prompt Checking for UNUSABLE indexes
Prompt =======================================================================

select case
       when count(*) = 0 then 'OK. No UNUSABLE indexes'
       when count(*) > 0 then 'UNUSABLE indexes found. '||'Run detailed report'
       end
  from dba_indexes
 where status = 'UNUSABLE';

Prompt
Prompt =======================================================================
Prompt Checking for UNUSABLE index partitions
Prompt =======================================================================

select case
       when count(*) = 0 then 'OK. No UNUSABLE index partitions'
       when count(*) > 0 then 'UNUSABLE index partitions found. '||'Run detailed report'
       end
  from dba_ind_partitions
 where status = 'UNUSABLE';

Prompt
Prompt =======================================================================
Prompt Checking for DISABLED constraints
Prompt =======================================================================

select case 
       when count(status) = 0 then 'OK. No DISABLED constraints'
       when count(status) > 0 then 'DISABLED constraints found. '||'Run detailed report'
       end
  from dba_constraints
 where status = 'DISABLED';

Prompt
Prompt =======================================================================
Prompt Checking for DISABLED triggers
Prompt =======================================================================

select case
       when count(status) = 0 then 'OK. No DISABLED triggers'
       when count(status) > 0 then 'DISABLED triggers found. '||'Run detailed report'
       end
  from dba_triggers
 where status = 'DISABLED';

Prompt
Prompt =======================================================================
Prompt Checking for PUBLIC synonyms pointing to non-existent objects
Prompt =======================================================================

select case
       when count(synonym_name) = 0 then 'OK. No PUBLIC synonyms pointing to non-existent objects'
       when count(synonym_name) > 0 then 'PUBLIC synonyms found pointing to non-existent objects. '||'Run detailed report'
       end
  from dba_synonyms s
 where s.owner = 'PUBLIC'
   and not exists (select object_name from dba_objects o where o.object_name = s.table_name and s.table_owner = o.owner);

Prompt
Prompt =======================================================================
Prompt Checking for version v/s COMPATIBLE parameter
Prompt =======================================================================

select case 
       when instr(version,value,1) = 1 then 'OK. No compatiblity mismatch'
       when instr(version,value,1) = 0 then 'Compatiblity mismatch. '||'Run detailed report'
       end
  from
       (select value from v$parameter where name = 'compatible'),
       (select version from v$instance)
/

Prompt
Prompt =======================================================================
Prompt Checking for global_name matching to db_name.db_domain
Prompt =======================================================================

select case
       when count(*) = 0 then 'global_name does not match db_name.db_domain. '||'Run detailed report'
       when count(*) = 1 then 'OK. global_name matches db_name.db_domain'
       end
  from (select value from v$parameter where name = 'db_name') name,
       (select nvl(value,'dummy') value from v$parameter where name = 'db_domain') domain,
       (select global_name from global_name) global_name
 where global_name = name.value||'.'||domain.value
/

Prompt
Prompt =======================================================================
Prompt Checking for archive directory naming convention
Prompt =======================================================================

select case 
       when count(*) = 1 then 'OK. Archive destination naming is ok'
       when count(*) = 0 then 'Archive destination naming is not ok or database is in NOARCHIVELOG'
       end
  from v$parameter
 where instr(lower(value),'arch',1) > 0
   and name = 'log_archive_dest'
/
select case log_mode
       when 'NOARCHIVELOG' then 'Database in in NOARCHIVELOG mode'
       end
  from v$database
/

Prompt
Prompt =======================================================================
Prompt Checking whether spfile is being used
Prompt =======================================================================

select case count(*)
       when 0 then 'SPFILE is not being used'
       when 1 then 'OK. SPFILE is being used'
       end
  from v$parameter
 where name = 'spfile'
   and value is not null
/

Prompt
Prompt =======================================================================
Prompt Checking if max_enabled_roles < 50
Prompt =======================================================================

select case 
       when value < 50 then 'Initialization parameter MAX_ENABLE_ROLES is set < 50'
       when value > 50 then 'OK. Initialization parameter MAX_ENABLE_ROLES is set above the threshold'
       end
  from v$parameter
 where name = 'max_enabled_roles'
/

Prompt
Prompt =======================================================================
Prompt Checking for the case where only some tables are analyzed
Prompt =======================================================================

select case 
       when count(*) = 0 then 'OK. No case of partially analyzed tables'
       when count(*) > 0 then 'Partially analyzed tables found. '||'Run detailed report'
       end
  from (
         select owner,lt,row_number() over (partition by owner order by owner) in_list_rank,count(lt) tab_ct
           from (
                  select owner,case when last_analyzed is null then 0
                         when last_analyzed is not null then 1
                         end lt
                    from dba_tables
                   where owner not in ('SYS','SYSTEM','PERFSTAT','DBM_USER','OUTLN','DBSNMP')
                     and owner not like 'IMDD%'
                )
          group by owner,lt
       )
 where in_list_rank = 2
/

Prompt
Prompt =======================================================================
Prompt Checking for the case where only some indexes are analyzed
Prompt =======================================================================

select case 
       when count(*) = 0 then 'OK. No case of partially analyzed indexes'
       when count(*) > 0 then 'Partially analyzed indexes found. '||'Run detailed report'
       end
  from (
         select owner,lt,row_number() over (partition by owner order by owner) in_list_rank,count(lt) tab_ct
           from (
                  select owner,case when last_analyzed is null then 0
                         when last_analyzed is not null then 1
                         end lt
                    from dba_indexes
                   where owner not in ('SYS','SYSTEM','PERFSTAT','DBM_USER','OUTLN','DBSNMP')
                     and owner not like 'IMDD%'
                )
          group by owner,lt
       )
 where in_list_rank = 2
/

Prompt
Prompt =======================================================================
Prompt End of Summary Report
Prompt =======================================================================
spool off
clear columns
set feedback on heading on
@tempcheck.out