set verify off
accept getit prompt 'Purge recyclebin[Y|N] default N: '
col selected new_value selected
set termout off
select decode('&&getit',null,'N','n','N','y','Y','Y','Y','&&getit') selected from dual;
set termout on
declare
ct number;
begin
if ('&&selected' = 'Y') then
dbms_output.put_line(' ');
dbms_output.put_line('YES');
select count(*) into ct from dba_recyclebin;
dbms_output.put_line('Recyclebin count :'||ct);
EXECUTE IMMEDIATE 'purge dba_recyclebin';
else
dbms_output.put_line(' ');
dbms_output.put_line('NO');
end if;
end;
/
set verify on
