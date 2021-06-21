set verify off termout off timing off
col passwd new_value passwd format a20
select chr(trunc(dbms_random.value(65,91))) || DBMS_RANDOM.string('a',9)||
       trunc(dbms_random.value(1,9))||DBMS_RANDOM.string('a',9)||trunc(dbms_random.value(1,9))  passwd
from dual;
set termout on feedback off
declare
passwd varchar2(30);
begin
select '&&passwd' into passwd from dual;
dbms_output.put_line(chr(10));
dbms_output.put_line('Password is '||length(passwd)||' chars :'||passwd);
end;
/
col username for a20
select username ,account_status from dba_users where username = upper('&1');
prompt
prompt alter user &1 identified by &passwd;;
prompt
set verify on timing on feedback on

