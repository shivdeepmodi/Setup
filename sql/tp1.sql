set verify off
col EVENT2 for a50
col FIRST_SEEN for a20
col LAST_SEEN for a20
@tp/ash/ashtop.sql session_state,event 1=1 sysdate-&1/60/24 sysdate
set verify on

