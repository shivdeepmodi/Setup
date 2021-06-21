rem -----------------------------------------------------------------------
rem Filename:   cr8like.sql
rem Purpose:    Script to create a new user (with privs) like an existing
rem             database user. User data will not be copied.
rem Date:       02-Nov-1998
rem Author:     Frank Naude, Oracle FAQ
rem Updated:    Konstantin Krivosheyev - 7 Dec 2002
rem Updated:    Frank Naude - 18 Dec 2003, 2 Dec 2004
rem Updated:	Kaushik Basu - 20 May 2005
rem Updated:    Shivdeep Modi - 10 Oct 2006
rem -----------------------------------------------------------------------


set pages 0 feed off veri off

accept oldname prompt "Enter user to model new user to: "
accept newname prompt "Enter new user name: "
accept psw     prompt "Enter new user's password: "
spool cr8like8_&&newname._&&_connect_identifier..sql
prompt spool cr8like8_&&newname._&&_connect_identifier..lst

-- Create user...
--select 'create user &&newname identified by values '''||password||''''||
select 'create user &&newname identified by &psw'||
       ' default tablespace '||default_tablespace||
       ' temporary tablespace '||temporary_tablespace||' profile '||
       profile||
       ' password expire;'
from   sys.dba_users 
where  username = upper('&&oldname');

-- Added by Shivdeep
-- This will search for role granted to roles.
-- This did not work for 8.1.7.4
select 'grant '||granted_role||' to '||'&&newname'||decode(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION')||';'
from my_role_privs
connect by prior granted_role = grantee
start with grantee = upper('&&oldname');

-- Grant System Privs...
select 'grant '||privilege||' to &&newname'||
       decode(ADMIN_OPTION, 'YES', ' WITH ADMIN OPTION')||';'
from   sys.dba_sys_privs
where  grantee = upper('&&oldname');  

-- Grant Table Privs...
select 'grant '||privilege||' on '||owner||'.'||table_name||' to &&newname;'
from   sys.dba_tab_privs
where  grantee = upper('&&oldname');  

-- Grant Column Privs...
select 'grant '||privilege||' on '||owner||'.'||table_name||
       '('||column_name||') to &&newname;'
from   sys.dba_col_privs
where  grantee = upper('&&oldname');  

-- Tablespace Quotas...
select 'alter user '||username||' quota '||
       decode(max_bytes, -1, 'UNLIMITED', max_bytes)||
       ' on '||tablespace_name||';'
from   sys.dba_ts_quotas
where  username = upper('&&oldname'); 

-- Set Default Role...
--set serveroutput on
declare
  defroles varchar2(4000);
begin
  for c1 in (select * from sys.dba_role_privs 
              where grantee = upper('&&oldname')
                and default_role = 'YES'
  ) loop
      if length(defroles) > 0 then
         defroles := defroles||','||c1.granted_role;
      else
         defroles := defroles||c1.granted_role;
      end if;
  end loop;
  dbms_output.put_line('alter user &&newname default role '||defroles||';');
end;
/
prompt spool off
spool off
set verify on feedback on head on

prompt 
prompt The SQL File to run is cr8like8_&&newname._&&_connect_identifier..sql
prompt
