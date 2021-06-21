col backup_server for a30
with rc_data as
(
select * from (
select DB_KEY,DBID,name,RESETLOGS_TIME, row_number() over (partition by name order by resetlogs_time desc ) rnum
  from firman.rc_Database
 order by name,RESETLOGS_TIME desc
)
where rnum=1
)
select rc_data.name INSTANCE, 
       substr(value,instr(conf.value,'=',1,2)+1, instr(conf.value,',',1,1) - instr(conf.value,'=',1,2)-1) backup_server
  from rc_data , firman.rc_rman_configuration conf
 where rc_data.db_key = conf.db_key
   and rc_data.name=conf.db_unique_name
   and value like '%NSR_SERVER%'
   --and (value like '%NSR_SERVER%' or value like '%NB_ORA%')
/