REM Setup for alert_log.sql
REM column value new_val BDD
REM select value
REM  from v$parameter
REM where upper(name) like 'BACKGROUND_DUMP_DEST';
REM 
REM CREATE OR REPLACE DIRECTORY DBM_ALERT AS '&BDD';
REM
REM CREATE TABLE     dbm_user.alert_log (eachrow VARCHAR2(1000))
REM ORGANIZATION EXTERNAL (
REM TYPE                     oracle_loader
REM DEFAULT DIRECTORY        dbm_alert
REM ACCESS PARAMETERS (
REM RECORDS DELIMITED BY NEWLINE
REM NOBADFILE NODISCARDFILE NOLOGFILE)
REM Location             ('alert_&DBID..log'))
REM REJECT LIMIT unlimited;
REM 
REM 

prompt ==========================================================
prompt Recent Alert Log entries satisfying qualification criteria
prompt ==========================================================
prompt
set verify off
def AlertRecent=10000              -- For speed, only check most recent rows in alert log
def AlertStep=100000               -- Approaching AlertSize by steps of this value for scores
rem def AlertTime=.2                   -- To only check recent entries (in units of days)
def alert_ok = 1 

col cntrows       format 9999999999       heading 'Alert Log entries'          
col msg           format a100             heading 'Alert Log message'          
col summ          format a6               heading 'Status#011:Alert Log entries'  new_value sc11


select count(*)                                                    cntrows
      ,substr(eachrow,1,80)                                        msg
from 
(
select max(decode(rowkey
                 ,NULL,SYSDATE+NULL
                 ,to_date(substr(rowkey,21,4) || substr(rowkey, 5,3)
                                              || substr(rowkey, 9,3)
                                              || substr(rowkey,12,8)
                         ,'YYYYMONDD HH24:MI:SS'
                         )
                 )) over (order by rnum range unbounded preceding) dttm_from
      ,min(decode(rowkey
                 ,NULL,SYSDATE+NULL
                 ,to_date(substr(rowkey,21,4) || substr(rowkey, 5,3)
                                              || substr(rowkey, 9,3)
                                              || substr(rowkey,12,8)
                         ,'YYYYMONDD HH24:MI:SS'
                         )
                 )) over (order by rnum range between 0 preceding and unbounded following) dttm_to 
      ,to_number(decode(substr(eachrow,1,4)
                       ,'ORA-'  ,substr(eachrow,5,least(instr(eachrow,' ')
                                                       ,instr(eachrow,':')
                                                       )  -5)
                       ,NULL
                       )
                ) oraerr
      ,eachrow       
      ,maxrnum
from
(
select eachrow
      ,decode(Translate(substr(eachrow,1,24)
                       ,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz '
                       ,'++++++++++@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+'
                       )
             ,'@@@+@@@++++++:++:+++++++'   ,substr(eachrow,1,24)
             ,''
             )  rowkey      
      ,rownum rnum
      ,max(rownum) over (order by rownum range between unbounded preceding and unbounded following) maxrnum 
from dbm_user.alert_log
where &alert_ok = 1
)
where rnum + &AlertRecent > maxrnum
)
where dttm_from    >  sysdate - (select case when t< 8 then (t+ 6)/24
                                             when t<20 then      2/24
                                                       else (t-18)/24
                                        end                              alert_prd
                                 from (select  24*(sysdate-trunc(sysdate)) t
                                       from    dual
                                      )
                                )
  and eachrow   like  '%ORA-%' 
group by eachrow;
set verify on