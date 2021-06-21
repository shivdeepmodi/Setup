set verify off
declare
runsql varchar2(1000);
defroles varchar2(4000);
begin
for ii in (select distinct grantee from dba_role_privs where grantee = upper ('&user') )
loop
  runsql:='alter user '||ii.grantee||' default role ';
  defroles:='';
  for jj in (select granted_role from dba_role_privs where grantee = ii.grantee)
  loop
      if length(defroles) > 0 then
         defroles := defroles||','||jj.granted_role;
      else
         defroles := defroles||jj.granted_role;
      end if;
  end loop;
  dbms_output.put_Line(runsql||defroles||';');
end loop;
end;
/

set verify on