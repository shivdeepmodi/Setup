accept connect_string char Prompt 'Give connect string :' default 'Not connected'
set termout off verify off
disconnect


set termout on
set termout off feedback off
set instance &&connect_string
connect ncldba/appl3s@&&connect_string
col instance_name new_value instance_name
select instance_name as instance_name from v$instance;
col priv new_value priv
select decode('&&_privilege',null,'AS NORMAL','&&_privilege') priv from dual;
set sqlprompt '&&_user &&priv ON &&instance_name > '

@date
set head off termout on feedback off

@ver
set head on feedback off termout on
prompt
@db.sql
set head off
@name
exec dbms_application_info.set_module('SQLPLUS-SDM','DBA');
alter session enable resumable;
set verify on feedback on termout on head on
undefine connect_string
prompt
