set verify off termout off timing off
col passwd new_value passwd 
select chr(trunc(dbms_random.value(65,91))) || DBMS_RANDOM.string('a',12)||
       trunc(dbms_random.value(1,9))||DBMS_RANDOM.string('a',5)||trunc(dbms_random.value(1,9))||'#'  passwd 
from dual;
set termout on feedback off
declare
passwd varchar2(50);
begin
select '&&passwd' into passwd from dual;
dbms_output.put_line(chr(10));
dbms_output.put_line('Password is '||length(passwd)||' chars :'||passwd);
dbms_output.put_line(chr(10));
end;
/

set verify on timing on feedback on
