REM Generic script to find details non-standard issues
REM Shivdeep Modi
REM
clear screen
store set tempcheck.out replace
set lines 300 pages 1000
set null ''

Column granted_role        heading 'Granted Role'       format a12
Column count(granted_role) heading 'Role Count'         format 999
Column grantee             heading 'Grantee'            format a25
Column owner               heading 'Owner'              format a25
Column table_name          heading 'Table Name'         format a30
Column count(privilege)    heading 'Privilege Count'    format 999
Column tablespace_name     heading 'Tablespace Name'    format a15
Column contents            heading 'Contents'           format a9
Column extent_management   heading 'Extent Mgmt'        format a11
Column file_name           heading 'File Name'          format a40
Column autoextensible      heading 'Autoextensible'     format a14
Column name                heading 'Parameter Name'     format a20
Column value               heading 'Value'              format a6
Column username            heading 'Username'           format a15
Column default_tablespace  heading 'Default Tablespace' format a18
Column profile             heading 'Profile'            format a7
Column count(status)       heading 'Invalid Count'      format 999
Column index_name          heading 'Index Name'         format a30
Column index_owner         heading 'Index Owner'        format a25
Column partition_name      heading 'Partition Name'     format a25
Column status              heading 'Status'             format a10
Column synonym_name        heading 'Synonym Name'       format a30
column table_owner         heading 'Table Owner'        format a15
Column trigger_type        heading 'Trigger Type'       format a15
Column db_link             heading 'Database Link'      format a13
Column constraint_name     heading 'Constraint Name'    format a30
Column ctype               heading 'Constraint Type'    format a15
Column version             heading 'Version'            format a10
Column compatible          heading 'Compatible'         format a10
Column db_name             heading 'Database Name'      format a13
Column db_domain           heading 'DB Domain'          format a10
Column global_name         heading 'Global Name'        format a13
Column object_name         heading 'Object Name'        format a30
Column object_type         heading 'Object Type'        format a17
Column created             heading 'Created'            format a11
Column last_ddl_time       heading 'Last DDL Time'      format a13
Column last_analyzed       heading 'Last Analyzed'      format a13

set head off feedback off termout off
column old_nls new_value old_nls
select value old_nls from nls_session_parameters where parameter = 'NLS_DATE_FORMAT';
alter session set nls_date_format='DD-MON-YYYY';
set head on feedback on termout on

spool check_detail_&&_connect_identifier..lst
Prompt =======================================================================
Prompt Beginning of Summary Report
Prompt =======================================================================
Prompt
Prompt =======================================================================
Prompt Checking for DBA role granted to non-admin users
Prompt =======================================================================

set head off feedback off

select case count(granted_role)
       when 0 then 'OK. No non admin user having DBA role'
       end
  from dba_role_privs
 where granted_role in ('DBA')
   and grantee not in ('SYS','SYSTEM','NCLDBA');

set head on feedback off

select grantee, granted_role
  from dba_role_privs
 where granted_role in ('DBA')
   and grantee not in ('SYS','SYSTEM','NCLDBA')
 order by grantee;

Prompt
Prompt =======================================================================
Prompt Checking for non-standard roles 
Prompt =======================================================================

set head off feedback off
select case count(granted_role)
       when 0 then 'OK. No non-standard roles granted to users'
       end
  from dba_role_privs
 where granted_role in ('CONNECT','RESOURCE')
   and grantee not in ('SYS','SYSTEM','NCLDBA','RMAN');

set head on
select grantee, granted_role
  from dba_role_privs
 where granted_role in ('CONNECT','RESOURCE')
   and grantee not in ('SYS','SYSTEM','NCLDBA','RMAN')
 order by grantee;
 
Prompt 
Prompt =======================================================================
Prompt Checking for grants to PUBLIC
Prompt =======================================================================

set head off
select case count(privilege)
       when 0 then 'OK. No grants to PUBLIC'
       end
  from dba_tab_privs
 where grantee = 'PUBLIC'
   and owner not in ('SYS','SYSTEM')
   and owner not like 'IMDD%';
 
set head on

select owner,table_name,count(privilege)
  from dba_tab_privs
 where grantee = 'PUBLIC'
   and owner not in ('SYS','SYSTEM')
   and owner not like 'IMDD%'
 group by owner,table_name
 order by table_name;

Prompt
Prompt =======================================================================
Prompt Checking for dictionary managed tablespaces excluding SYSTEM
Prompt =======================================================================

set head off
select case count(tablespace_name)
       when 0 then 'OK. No tablespaces are dictionary managed'
       end
  from dba_tablespaces
 where tablespace_name not in ('SYSTEM')
   and extent_management = 'DICTIONARY';

set head on
select tablespace_name,contents,extent_management
  from dba_tablespaces
 where tablespace_name not in ('SYSTEM')
   and extent_management = 'DICTIONARY'
 order by tablespace_name;

Prompt
Prompt =======================================================================
Prompt Checking for autoextensible datafiles/tempfiles
Prompt =======================================================================

set head off

select case count(autoextensible)
       when 0 then 'OK. No datafiles/tempfiles are autoextensible'
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

set head on
select *
  from (
select tablespace_name,file_name,autoextensible
  from dba_data_files
 where autoextensible = 'YES'
 union 
select tablespace_name,file_name,autoextensible
  from dba_temp_files
 where autoextensible = 'YES'
)
order by tablespace_name;

Prompt
Prompt =======================================================================
Prompt Checking for offline datafiles/tempfiles
Prompt =======================================================================

set head off
select case count(status)
       when 0 then 'OK. No datafiles/tempfiles are offline'
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

set head on
select *
  from (
select tablespace_name,file_name,status
  from dba_data_files
 where status != 'AVAILABLE'
 union
select tablespace_name,file_name,status
  from dba_temp_files
 where status != 'AVAILABLE'
)
 order by tablespace_name;

Prompt
Prompt =======================================================================
Prompt Checking for automatic undo management
Prompt =======================================================================

set head off
select case count(value)
       when 0 then 'OK. Automatic Undo Management'
       end
  from v$parameter
 where name = 'undo_management'
   and value = 'MANUAL';

set head on
select name,value
  from v$parameter
 where name = 'undo_management'
   and value = 'MANUAL';

Prompt
Prompt =======================================================================
Prompt Checking for job_queue_process if count(*) from dba_jobs > 0
Prompt =======================================================================

set head off
select case count(*) 
       when 0 then 'OK. job_queue_process has been setup for jobs'
       end
  from v$parameter 
 where name = 'job_queue_processes'
   and value = to_char(0)
   and exists(select job from dba_jobs)
/

set head on
select name,value
  from v$parameter 
 where name = 'job_queue_processes'
   and value = to_char(0)
   and exists(select job from dba_jobs)
/

Prompt
Prompt =======================================================================
Prompt Checking for non system segments in SYSTEM tablespace
Prompt =======================================================================

set head off
select case count(owner)
       when 0 then 'OK. No non system segments in SYSTEM tablespace'
       end
  from dba_segments
 where tablespace_name = 'SYSTEM'
   and owner not in ('SYS','SYSTEM','OUTLN');

set head on
select owner,count(owner)
  from dba_segments
 where tablespace_name = 'SYSTEM'
   and owner not in ('SYS','SYSTEM','OUTLN')
 group by owner
 order by owner;

Prompt
Prompt =======================================================================
Prompt Checking for users having SYSTEM as their default tablespace
Prompt =======================================================================

set head off
select case count(username)
       when 0 then 'OK. No non system users have SYSTEM as default tablespace'
       end
  from dba_users
 where default_tablespace = 'SYSTEM'
   and username not in ('SYS','SYSTEM','OUTLN');

set head on
select username,default_tablespace
  from dba_users
 where default_tablespace = 'SYSTEM'
   and username not in ('SYS','SYSTEM','OUTLN')
 order by username;

Prompt
Prompt =======================================================================
Prompt Checking for users having SYSTEM as their temp tablespace
Prompt =======================================================================

set head off
select case count(username)
       when 0 then 'OK. No users have SYSTEM as their temporary tablespace'
       end
  from dba_users
 where temporary_tablespace = 'SYSTEM'
   and username not in ('SYS','SYSTEM');

set head on
select username,temporary_tablespace
  from dba_users
 where temporary_tablespace = 'SYSTEM'
   and username not in ('SYS','SYSTEM')
 order by username;
 
Prompt
Prompt =======================================================================
Prompt Checking for users having DEFAULT profile
Prompt =======================================================================

set head off
select case count(username)
       when 0 then 'OK. No users have DEFAULT profile'
       end
  from dba_users
 where profile = 'DEFAULT'
   and username not in ('SYS','SYSTEM');

set head on
select username,profile
  from dba_users
 where profile = 'DEFAULT'
   and username not in ('SYS','SYSTEM')
 order by username;

Prompt
Prompt =======================================================================
Prompt Checking for datafile/tempfile not having tablespace name in their name
Prompt =======================================================================

set head off
select case when count(pos) = 0 then 'OK. All datafiles/tempfiles have tablespace name in their names'
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

set head on
select *
  from (
select tablespace_name,file_name
  from dba_data_files
 where instr(upper(file_name),upper(tablespace_name),1) = 0
 union 
select tablespace_name,file_name
  from dba_temp_files
 where instr(upper(file_name),upper(tablespace_name),1) = 0
)
 order by tablespace_name;

Prompt
Prompt =======================================================================
Prompt Checking for invalid objects
Prompt =======================================================================

set head off
select case count(*)
       when 0 then 'OK. No invalid objects'
       end
  from dba_objects
 where status = 'INVALID';

set head on
select owner,object_name,object_type,status,created,last_ddl_time
  from dba_objects
 where status = 'INVALID'
 order by owner;
 
Prompt
Prompt =======================================================================
Prompt Checking for UNUSABLE indexes
Prompt =======================================================================

set head off
select case count(*)
       when 0 then 'OK. No UNUSABLE indexes'
       end
  from dba_indexes
 where status = 'UNUSABLE';

set head on
select owner,table_name,index_name,status
 from dba_indexes
where status = 'UNUSABLE'
order by owner;

Prompt
Prompt =======================================================================
Prompt Checking for UNUSABLE index partitions
Prompt =======================================================================

set head off
select case count(*)
       when 0 then 'OK. No UNUSABLE index partitions'
       end
  from dba_ind_partitions
 where status = 'UNUSABLE';

set head on
select index_owner,index_name,partition_name,status
 from dba_ind_partitions
where status = 'UNUSABLE'
order by index_owner;

Prompt
Prompt =======================================================================
Prompt Checking for DISABLED constraints
Prompt =======================================================================

set head off
select case count(status)
       when 0 then 'OK. No DISABLED constraints'
       end
  from dba_constraints
 where status = 'DISABLED';

set head on
select owner,table_name,constraint_name,decode(constraint_type,'P','Primary Key',
                                                   'R','Foreign Key',
                                                   'C','Check Constraints',
                                                   'U','Unique Key',
                                                   'O','Read Only View',
                                                   'V','Check Option on View',
                                                   constraint_type) ctype,
       status
  from dba_constraints
 where status = 'DISABLED'
 order by owner;
 
Prompt
Prompt =======================================================================
Prompt Checking for DISABLED triggers
Prompt =======================================================================

set head off
select case count(*)
       when 0 then 'OK. No DISABLED triggers'
       end
  from dba_triggers
 where status = 'DISABLED';

set head on
select owner,table_owner,table_name,trigger_type
  from dba_triggers
 where status = 'DISABLED'
 order by owner;

Prompt
Prompt =======================================================================
Prompt Checking for PUBLIC synonyms pointing to non-existent objects
Prompt =======================================================================

set head off
select case count(*)
      when 0 then 'OK. No PUBLIC synonyms pointing to non-existent objects'
      end
 from dba_synonyms s
where s.owner = 'PUBLIC'
  and not exists (select object_name from dba_objects o where o.object_name = s.table_name and s.table_owner = o.owner);

set head on
select synonym_name,table_owner,table_name,db_link	
  from dba_synonyms s
 where s.owner = 'PUBLIC'
   and not exists (select object_name from dba_objects o where o.object_name = s.table_name and s.table_owner = o.owner)
 order by synonym_name;

Prompt
Prompt =======================================================================
Prompt Checking for version v/s COMPATIBLE parameter
Prompt =======================================================================

set head off
select case instr(version,value,1)
       when 1 then 'OK. No compatiblity mismatch'
       end
  from (select value from v$parameter where name = 'compatible'),
       (select version from v$instance)
/

set head on
select version , value compatible
  from (select value from v$parameter where name = 'compatible'),
       (select version from v$instance)
 where instr(version,value,1) != 1
/
Prompt
Prompt =======================================================================
Prompt Checking for global_name matching to db_name.db_domain
Prompt =======================================================================
set head off

select case 
       when count(*) = 1 then 'OK. global_name matches db_name.db_domain'
       end
  from (select value from v$parameter where name = 'db_name') name,
       (select value from v$parameter where name = 'db_domain') domain,
       (select global_name from global_name) global_name
 where global_name = name.value||'.'||domain.value
/

set head on
select name.value db_name ,domain.value db_domain,global_name
  from (select value from v$parameter where name = 'db_name') name,
       (select nvl(value,' ') value from v$parameter where name = 'db_domain') domain,
       (select global_name from global_name) global_name
 where global_name != name.value||'.'||domain.value
/

Prompt
Prompt =======================================================================
Prompt Checking for archive directory naming convention
Prompt =======================================================================

set head off
select 'OK. Archive destination naming is ok'
  from v$parameter
 where instr(lower(value),'arch',1) > 0
   and name = 'log_archive_dest'
/
select case log_mode
       when 'NOARCHIVELOG' then 'Database in in NOARCHIVELOG mode'
       end
  from v$database
/

set head on
select name,value
  from v$parameter
 where instr(lower(value),'arch',1) = 0
   and name = 'log_archive_dest'
/

Prompt
Prompt =======================================================================
Prompt Checking whether spfile is being used
Prompt =======================================================================

set head off
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

set head off
select case 
       when count(*) = 0 then 'OK. No case of partially analyzed tables'
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

set head on
select owner,table_name,case 
                        when last_analyzed is null then 'Not Analyzed' 
                        when last_analyzed is not null then to_char(last_analyzed)
                        end last_analyzed
  from dba_tables
 where owner in (
select distinct owner 
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
)
/

Prompt
Prompt =======================================================================
Prompt Checking for the case where only some indexes are analyzed
Prompt =======================================================================

set head off
select case 
       when count(*) = 0 then 'OK. No case of partially analyzed indexes'
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

set head on
select owner,index_name,case 
                        when last_analyzed is null then 'Not Analyzed' 
                        when last_analyzed is not null then to_char(last_analyzed)
                        end last_analyzed
  from dba_indexes
 where owner in (
select distinct owner 
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
)
/

Prompt
Prompt =======================================================================
Prompt End of Summary Report
Prompt =======================================================================
spool off
clear columns
set verify off feedback off
alter session set nls_date_format='&&old_nls';
set feedback on heading on verify on
@tempcheck.out