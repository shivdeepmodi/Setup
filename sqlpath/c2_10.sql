set feedback off verify off termout off

col priv new_value priv
select decode('&&_privilege',null,'AS NORMAL','&&_privilege') priv from dual;
set sqlprompt '&&_user &&priv ON &&_connect_identifier > '

set termout on feedback on verify on
