column day           heading 'Day'           format a16
column d_0           heading '00'            format a3
column d_1           heading '01'            format a3
column d_2           heading '02'            format a3
column d_3           heading '03'            format a3
column d_4           heading '04'            format a3
column d_5           heading '05'            format a3
column d_6           heading '06'            format a3
column d_7           heading '07'            format a3
column d_8           heading '08'            format a3
column d_9           heading '09'            format a3
column d_10          heading '10'            format a3
column d_11          heading '11'            format a3
column d_12          heading '12'            format a3
column d_13          heading '13'            format a3
column d_14          heading '14'            format a3
column d_15          heading '15'            format a3
column d_16          heading '16'            format a3
column d_17          heading '17'            format a3
column d_18          heading '18'            format a3
column d_19          heading '19'            format a3
column d_20          heading '20'            format a3
column d_21          heading '21'            format a3
column d_22          heading '22'            format a3
column d_23          heading '23'            format a3
column total         heading 'Total'         format 999999
column thread#       heading 'Thread#'       format 99 noprint
column instance      heading 'Instance'      format a13

prompt
Accept iscurrinst char prompt 'Log Switch Info All Instances (Y/N) Default(Y):' default Y
prompt
set termout off verify off heading off feedback off
column current_thread new_value current_thread
select value as current_thread
  from v$parameter
 where name = 'thread'
/
set termout on

prompt =========================================================================================================================
select decode('&iscurrinst','Y','Log Switch on hour basis for ALL instances','Log Switch on hour basis for CURRENT instance')
  from dual;

set heading on feedback on
select l.thread#,
       t.instance,
       to_char(trunc(FIRST_TIME,'HH24'),'DY, DD-MON-YYYY') day,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'00',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'00',1,0))) d_0,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'01',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'01',1,0))) d_1,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'02',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'02',1,0))) d_2,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'03',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'03',1,0))) d_3,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'04',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'04',1,0))) d_4,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'05',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'05',1,0))) d_5,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'06',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'06',1,0))) d_6,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'07',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'07',1,0))) d_7,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'08',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'08',1,0))) d_8,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'09',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'09',1,0))) d_9,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'10',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'10',1,0))) d_10,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'11',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'11',1,0))) d_11,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'12',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'12',1,0))) d_12,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'13',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'13',1,0))) d_13,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'14',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'14',1,0))) d_14,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'15',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'15',1,0))) d_15,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'16',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'16',1,0))) d_16,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'17',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'17',1,0))) d_17,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'18',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'18',1,0))) d_18,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'19',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'19',1,0))) d_19,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'20',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'20',1,0))) d_20,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'21',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'21',1,0))) d_21,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'22',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'22',1,0))) d_22,
       decode(sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'23',1,0)),0,'-',sum(decode(substr(to_char(trunc(FIRST_TIME,'HH24'),'HH24'),1,2),'23',1,0))) d_23,
       count(trunc(trunc(FIRST_TIME,'HH24'))) total
  from gv$log_history l, gv$thread t
 where l.thread# like decode(upper('&iscurrinst'),'Y','%','&current_thread')
   and l.thread# = t.thread#
 group by l.thread#,t.instance,to_char(trunc(FIRST_TIME,'HH24'),'DY, DD-MON-YYYY')
 order by thread#,to_date(substr(to_char(trunc(FIRST_TIME,'HH24'),'DY, DD-MON-YYYY'),5,15) )
/
prompt 