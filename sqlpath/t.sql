set verify off trimspool on head off timing off feed off
col file_name for a70
col bytes_gb for 99999999.99
--select tablespace_name,file_name,ONLINE_STATUS,round(bytes/1048576/1024,2) bytes_gb from dba_data_files where tablespace_name = upper('&1') order by RELATIVE_FNO;
select 'Current datafiles in tablespace '||upper('&1')||':'||count(*) from dba_data_files where tablespace_name = upper('&1') ;

set head on 

Column group_number         heading 'ASM|Disk|Group|#'       format 999
Column name                 heading 'ASM|Disk Group Name'    format a15
Column state                heading 'State'                  format a10
Column type                 heading 'Redundancy|Type'        format a10
Column total_mb             heading 'Allocated Space|(MB)'   format 999999999999.99
Column free_mb              heading 'Free Space|(MB)'        format 999999999999.99
Column total_gb             format 999999999999.99
Column free_gb              format 999999999999.99
Column unbalanced           heading 'Unbalanced'             format a10
Column offline_disks        heading 'Disks|Offline(#)'       format 9999
Column allocation_unit_size heading 'Allocation|Unit Size|(Bytes)' format 9999999
Column fpct                 heading 'Free|(%)'               format 999.99
Column upct                 heading 'Used|(%)'               format 999.99
Column block_size           heading 'Block|Size'             format 99999999999
Column usable_file_mb       heading 'usable_file_mb'         format 99999999999
Prompt

select /* unnest(@subq1) */ 
           group_number
           ,name
           ,state
           ,type
           --,offline_disks,
       		--allocation_unit_size,
            --block_Size
           ,round(total_mb/1024,2) total_gb
           ,round(free_mb/1024,2) free_gb
           ,round(free_mb/total_mb*100,2) fpct
           ,round((total_mb-free_mb)/total_mb*100,2) upct
           ,usable_file_mb
           --,unbalanced
           --,voting_files
from v$asm_diskgroup_stat
where name in ( select /*+ qb_name(subq1) */ distinct substr(file_name,2,instr(file_name,'/')-2) from dba_data_files where tablespace_name = upper('&1'))
/
prompt
set heading off feedback off timing off verify off
--prompt Datafile addition for &1 statement
prompt
select 'alter tablespace '||upper('&1')||' add datafile '||''''||'+'||qr.dg||''''||' size 2g autoextend on maxsize 30g;' 
from (select distinct substr(file_name,2,instr(file_name,'/')-2) dg from dba_data_files where tablespace_name = upper('&1')) qr;
prompt
set heading on feedback on timing on verify on

--@tbs &1

