REM Script to find object privileges and system privileges granted to role/user
REM role and user to be passed as parameter on command line

Column grantee      heading 'Grantee'		format a21
Column privilege    heading 'Privilege'		format a30
Column admin_option heading 'Admin|Option'	format a6
Column default_role heading 'Default|Role'	format a7
Column granted_role heading 'Granted Role'	format a25
Column owner        heading 'Owner'			format a20
Column grantor      heading 'Grantor'		format a20
Column privilege    heading 'Privilege'		format a25
Column grantable    heading 'Grantable'		format a9
Column hierarchy    heading 'Hierarchy'		format a9
Column table_name   heading 'Table Name'		format a26
column role         heading 'Role'			format a20
column column_name  heading 'Column Name'		format a20
column is_role      new_value is_role
column is_user      new_value is_user
set verify off feedback off termout off head off

select count(*) is_role
  from dba_roles
 where role = upper('&&1');
    


select decode(&&is_role,1, upper('&&1')||' is a role')
  from dual;

select count(*) is_user
  from dba_users
 where username = upper('&&1');
set termout on head off

select decode(&&is_user,1, upper('&&1')||' is a user')
  from dual;

select upper('&&1')||' is neither a user nor a role'
  from dual
 where &&is_user = 0 
   and &&is_role = 0;
  
set head on
Ttitle  left "Roles granted to user &&1" skip 1

select grantee, granted_role,admin_option,default_role
  from dba_role_privs
 where grantee = upper('&&1')
   and &&is_user = 1;

Ttitle  left "System Privileges granted to user &&1" skip 1

select grantee, privilege,admin_option
  from dba_sys_privs
 where grantee = upper('&&1')
   and &&is_user = 1;

Ttitle  left "Object Privileges grante to user &&1" skip 2

select grantee,owner,table_name,grantor,privilege,grantable,hierarchy
  from dba_tab_privs 
 where grantee = upper('&&1')
   and &&is_user = 1;

Ttitle  left "System Privileges granted to role &&1" skip 1   

select * 
  from dba_sys_privs
 where grantee = upper('&&1')
   and &&is_role = 1;

Ttitle  left "Roles granted to role &&1" skip 1   

select * 
  from dba_role_privs 
 where grantee = upper('&&1')
   and &&is_role = 1;

Ttitle  left "Table privs granted to Role &&1" skip 2

select owner,table_name,privilege,grantable
  from dba_tab_privs
 where grantee = upper('&&1')
   and &&is_role = 1;

set verify on feedback on termout on
Ttitle off
prompt
--clear columns