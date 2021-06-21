set termout off
disconnect
set termout on
accept connect_string char Prompt 'Give connect string :' default 'Not connected'
set termout off
set instance &&connect_string

connect ncldba/ch33sy@&&connect_string
set verify off termout off head off feedback off
column PS1 new_value connect_string
select '/'||user||'/'||upper('&&_connect_identifier') PS1 from dual;
set termout on
set sqlprompt '&&connect_string > '
@date
set head off termout on feedback off

@ver
set head on feedback off termout on
prompt
@db.sql
set head off
@name
set verify on feedback on termout on head on
undefine connect_string
prompt