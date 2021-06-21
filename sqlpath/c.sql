disconnect
--clear screen
set termout off verify off
define connect_string=&1
define username=&2
define passoword=&3
prompt
prompt

prompt commenting set_color.bat
--host set_title.bat &1
host title  &1

--set termout on
--Get the connect string from command line
--accept connect_string char Prompt 'Give connect string :' default 'Not connected'
--set termout off feedback off
set instance &&connect_string
--connect &&username@&&connect_string
set termout on
connect &&username/&&passoword@&&connect_string
set termout off
--connect &&username@&&connect_string
col instance_name new_value instance_name
select instance_name as instance_name from v$instance;
--col priv new_value priv
--select decode('&&_privilege',null,'AS NORMAL','&&_privilege') priv from dual;
col prompt_p new_value prompt_p
select '&&username'||':-'||'&&instance_name'||'>' as prompt_p from dual;
set sqlprompt &&prompt_p

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
