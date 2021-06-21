set verify off
@tp/ash/ashtop.sql event2,wait_class,username,sql_id "event='&event'" sysdate-5/60/24 sysdate
set verify on

