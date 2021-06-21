set verify off termout off timing off
col passwd new_value passwd 
dbms_output.put_line(chr(10));
select chr(trunc(dbms_random.value(65,91))) || DBMS_RANDOM.string('a',12)||
       trunc(dbms_random.value(1,9))||DBMS_RANDOM.string('a',5)||trunc(dbms_random.value(1,9))||'#'  passwd 
from dual;
set termout on feedback off
declare
passwd varchar2(100);
begin
select '&&passwd' into passwd from dual;
dbms_output.put_line(chr(10));
dbms_output.put_line('Password is '||length(passwd)||' chars :'||passwd);
execute immediate 'alter user smodi identified by '||passwd;
end;
/
set termout off
spool /tmp/&&passwd..out
begin
dbms_output.put_line('connect smodi/'||'&&passwd');
end;
/
set termout on

spool off
@/tmp/&&passwd..out
!rm /tmp/&&passwd..out
set verify on timing on feedback on
