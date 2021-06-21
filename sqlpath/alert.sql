def alert_ok = 1 
col p_alert  format a20        heading 'Using alert log suffix'   new_value p_alert_log

select 'dbm_user.alert_log'||decode(substr(instance_name,-2,1),'R',substr(instance_name,-1,1),'') p_alert
from v$instance
/

select substr(eachrow,1,80) msg
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
from &p_alert_log 
) 
  and eachrow   like  '%alter database%' 
/