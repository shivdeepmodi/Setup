col username for a15
col module for a15 trunc
set verify off
@tp/ash/ashtop.sql username,module,event2,wait_class,sql_id "wait_class='&wait_class'" sysdate-5/60/24 sysdate
set verify on

