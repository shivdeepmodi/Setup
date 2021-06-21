set feedback off serverout on

Prompt
begin
    dbms_output.put_line('Port String');
    dbms_output.put_line('-----------');
    dbms_output.put_line(dbms_utility.port_string);
end;
/

Column parameter heading 'Installed Options' format a35

select parameter
from   v$option
where  value = 'TRUE';

Column parameter heading 'Non Installed Options' format a35

select parameter
from  v$option
where  value <> 'TRUE';

Prompt
set feedback on
clear columns