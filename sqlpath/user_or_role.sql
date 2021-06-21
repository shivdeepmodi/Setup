set head off feedback off verify off termout off
col usr new_value usr
col rle new_value rle

select count(*)usr from dba_users where username = upper('&&1');
select count(*)rle from dba_roles where role     = upper('&&1');

set termout on 

select case 
       when &&usr = 0 AND &&rle = 0 then 'NONE: ' ||'&&1 is neither is user nor a role'
       when &&rle = 0 AND &&usr = 1 then 'USER: ' ||'&&1 is a user' 
       when &&usr = 0 AND &&rle = 1 then 'ROLE: ' ||'&&1 is a role' 
       end
  from dual
/
prompt
set head on feedback on verify on
