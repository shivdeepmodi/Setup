set head off feedback off verify off termout off
connect n101869/airways8@uvprd_app
--connect ncldba/ch33sy@uvprd
col PS1 new_value service
select  'SYMPHONY' PS1 from dual;

prompt
@ver.sql
prompt
set verify on feedback on head on termout on
set sqlprompt '&&service > '

