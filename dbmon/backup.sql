set lines 300 colsep '|' termout off
col STATUS format a30  
define backup_days=14

column db_unique_name new_value db_unique_name
column host_name new_value host_name
column database_role new_value database_role format a20
col DB_NAME for a20
column host_name for a20
set timing on echo off termout off 
select value as db_unique_name  from v$parameter where name = 'db_unique_name';
select decode(substr(min(host_name),1,instr(min(host_name),'.')-1),NULL,min(host_name),substr(min(host_name),1,instr(min(host_name),'.')-1)) host_name 
from gv$instance;
select database_role from v$database;
set verify off termout &1
spool &2 replace
select * from (
select '&&db_unique_name' db_name,'&&database_role' database_role,'&&host_name' host_name,
       decode(ctl.INPUT_TYPE,NULL,ph.input_type,ctl.INPUT_TYPE) INPUT_TYPE,
       decode(ctl.STATUS,NULL,ph.STATUS,ctl.STATUS) STATUS,
       decode(ctl.END_TIME,NULL,ph.END_TIME,ctl.END_TIME) END_TIME
  from (
         --select INPUT_TYPE,STATUS,START_TIME,END_TIME,rank() over (partition by INPUT_TYPE order by START_TIME desc) as myrank
		 select INPUT_TYPE,
		        CASE WHEN trunc(END_TIME) < (trunc(sysdate) - &&backup_days) THEN STATUS
				     WHEN trunc(END_TIME) > (trunc(sysdate) - &&backup_days) AND (STATUS not like 'COMPLETED%') THEN STATUS
					 WHEN trunc(END_TIME) > (trunc(sysdate) - &&backup_days) AND (STATUS like 'COMPLETED%') THEN STATUS
					 END STATUS,
		        CASE WHEN trunc(END_TIME) < (trunc(sysdate) - &&backup_days) THEN END_TIME
				     WHEN trunc(END_TIME) > (trunc(sysdate) - &&backup_days) AND (STATUS <> 'COMPLETED') THEN END_TIME
					 WHEN trunc(END_TIME) > (trunc(sysdate) - &&backup_days) AND (STATUS like 'COMPLETED%') THEN END_TIME
				END END_TIME,
		        rank() over (partition by INPUT_TYPE order by START_TIME desc) as myrank
          from (
                 select INPUT_TYPE, STATUS, max(START_TIME) START_TIME,max(END_TIME) END_TIME
				 from V$RMAN_BACKUP_JOB_DETAILS
                -- where status <> 'COMPLETED WITH WARNINGS'
                  group by INPUT_TYPE,STATUS
                  order by 1,3
              )
      ) ctl,
      (
         select input_type,'NOT AVAILABLE' status,'NA' end_time, rank() over (partition by input_type order by input_type) myrank
           from
           (
             --select 'DB FULL' as input_type from dual
             --union all
             select 'DB INCR' as input_type from dual
             union all
             select 'ARCHIVELOG' as input_type from dual
            )
      ) ph
where ctl.myrank(+)=ph.myrank and
      ctl.input_type(+)=ph.input_type
)
where status not like 'COMPLETED%'
and database_role||input_type <> 'PHYSICAL STANDBY'||'DB INCR'
/
spool off
set termout on
