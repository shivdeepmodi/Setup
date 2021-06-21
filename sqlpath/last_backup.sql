
set feedback off verify off

rem Test #08 Backups
rem 
def backup_window   = 14
def backup_history  = 35 
def latest_bu_d     =  7           -- Max allowed days since last backup of database  
def latest_bu_l     =  2           -- Max allowed days since last backup of log files 


Column device_type     heading 'Device Type'     format a20
Column device_name     heading 'Device Name'     format a20
Column backup_type     heading 'Backup Type'     format a20
Column start_time      heading 'Start Time'      format a20
Column completion_time heading 'Completion Time' format a20

def backup_history  = 35

select device_type,device_name
  from v$backup_device;
  
select decode(backup_type,'D','FULL/LvL0','I','Incremental','L','Archive Log',backup_type)
      ,max(vs.completion_time)                                                               latest
from  v$backup_set    vs
     ,v$backup_piece  vp
where vs.recid           = vp.recid
  and vs.completion_time > sysdate - &backup_window
group by  decode(backup_type,'D','FULL/LvL0','I','Incremental','L','Archive Log',backup_type)
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
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'SU','Z',' ') Z
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'MO','M',' ') M
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'TU','T',' ') T
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'WE','W',' ') W
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'TH','J',' ') J
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'FR','F',' ') F
       ,decode(substr(to_char(sysdate,'DAY'),1,2),'SA','S',' ') S
  from dual
union
select distinct 
       cal.id
      ,-cal.week
      ,''                                                                                                filler
      ,to_char(greatest
      (max(decode(t_dy,'SU',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'SU',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) Z
      ,to_char(greatest
      (max(decode(t_dy,'MO',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'MO',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) M
      ,to_char(greatest
      (max(decode(t_dy,'TU',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'TU',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) T
      ,to_char(greatest
      (max(decode(t_dy,'WE',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'WE',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) W
      ,to_char(greatest
      (max(decode(t_dy,'TH',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'TH',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) J
      ,to_char(greatest
      (max(decode(t_dy,'FR',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'FR',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) F
      ,to_char(greatest
      (max(decode(t_dy,'SA',pieces,0)) over (partition by full.id,cal.week order by full.id, cal.week)
      ,max(decode(t_dy,'SA',0  ,null)) over (partition by  cal.id          order by  cal.id          ))) S
from
(
select  BACKUP_TYPE                                           id
       ,substr(to_char(completion_time,'DAY'),1,2)            t_dy
       ,trunc((trunc(sysdate) - trunc(bs.completion_time)	
                              + (instr('SUMOTUWETHFRSA',substr(to_char(completion_time,'DAY'),1,2))+1)/2
              )/7
             )                                                t_wk
       ,pieces
from v$backup_set bs
where completion_time > sysdate - &backup_history
) full
,
(
select week, id
from
(
  select 0 week  from dual 
  union 
  select 1 from dual 
  union 
  select 2 from dual 
  union
  select 3 from dual 
  union 
  select 4 from dual
) weeks
,
(
  select 'D'     id from dual 
  union
  select 'L'     id from dual
--  union 
--  select 'I'     id from dual
) typ
) cal
where full.t_wk (+)  = cal.week
  and full.id   (+)  = cal.id
order by 1,2 
/
set feedback on verify on 
clear columns