
set feedback off verify off

rem 
def backup_window   = 14
def backup_history  =  35
def database_name   = '&1'

Column device_type     heading 'Device Type'     format a20
Column device_name     heading 'Device Name'     format a20
Column backup_type     heading 'Backup Type'     format a20
Column start_time      heading 'Start Time'      format a20
Column completion_time heading 'Completion Time' format a20

def backup_history  = 35

select name from rc_database where name = '&database_name';

select name ,value device_type 
  from RC_RMAN_CONFIGURATION 
 where db_unique_name = '&database_name' 
   and name ='DEFAULT DEVICE TYPE TO';
  
select decode(vs.backup_type,'D','FULL/LvL0','I','Incremental','L','Archive Log',vs.backup_type) backup_type
      ,max(vs.completion_time) latest
from  rc_backup_set vs,rc_backup_piece vp, rc_database vd
where vs.recid           = vp.recid
  and vs.db_id = vp.db_id
  and vd.dbid = vs.db_id
  and vd.name = upper('&database_name')
  and vs.completion_time > sysdate - &backup_window
group by decode(vs.backup_type,'D','FULL/LvL0','I','Incremental','L','Archive Log',vs.backup_type)
/


prompt ============================================================================
prompt Backup Events by relative calendar (week 0 is current, week 1 previous etc.)
prompt ============================================================================
col id      format a14    heading 'Backup Type'
col week    format 99     heading 'Relative Week'
col filler  format a7     heading 'Days =>'
col Z       format a1     heading 'Z'
col M       format a1     heading 'M'
col T       format a1     heading 'T'
col W       format a1     heading 'W'
col J       format a1     heading 'J'
col F       format a1     heading 'F'
col S       format a1     heading 'S'

select 'TODAY=>'                                                id
       ,null                                                    week
       ,'NOW ==>'                                               filler
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'SU','Z',' ') Z
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'MO','M',' ') M
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'TU','T',' ') T
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'WE','W',' ') W
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'TH','J',' ') J
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'FR','F',' ') F
       ,decode(substr(to_char(trunc(sysdate,'DD'),'DAY'),1,2),'SA','S',' ') S
  from dual
union
select --distinct 
       cal.id
      ,-cal.week
      ,''                                                                                               filler
      ,max(decode(t_dy,'SU',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) Z
	  ,max(decode(t_dy,'MO',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) M
	  ,max(decode(t_dy,'TU',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) T
	  ,max(decode(t_dy,'WE',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) W
	  ,max(decode(t_dy,'TH',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) J
	  ,max(decode(t_dy,'FR',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) F
	  ,max(decode(t_dy,'SA',case when pieces >0 then '1'  end,0)) over (partition by full.id,cal.week order by full.id, cal.week) S
from
(
select  BACKUP_TYPE                                           id
       ,trunc(completion_time) c_T
       ,substr(to_char(completion_time,'DAY'),1,2)            t_dy
	   ,trunc((trunc(sysdate) - trunc(bs.completion_time)	
                              + (instr('SUMOTUWETHFRSA',substr(to_char(trunc(completion_time,'DD'),'DAY'),1,2))+1)/2
              )/7
             ) t_wk	   
       ,count(pieces) pieces
 from rc_backup_set bs,rc_database rc
where completion_time > sysdate - &backup_history
  and bs.db_id=rc.dbid
  and rc.name =  '&database_name'
group by BACKUP_TYPE,trunc(completion_time) ,substr(to_char(completion_time,'DAY'),1,2)
      ,trunc((trunc(sysdate) - trunc(bs.completion_time)	
                              + (instr('SUMOTUWETHFRSA',substr(to_char(trunc(completion_time,'DD'),'DAY'),1,2))+1)/2
              )/7
             )
--order by 2	  
) full
,
(
select week, id
from
(
  select 0 week from dual 
  union 
  select 1 week from dual 
  union 
  select 2 week from dual 
  union
  select 3 week from dual 
  union 
  select 4 week from dual
) weeks
,
(
  select 'D'     id from dual 
  union
  select 'L'     id from dual
) typ
) cal
where full.t_wk   = cal.week
  and full.id     = cal.id
order by 1,2 
/
set feedback on verify on 
clear columns