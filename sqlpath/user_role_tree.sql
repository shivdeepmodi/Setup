REM
REM The script will print the roles granted to a user in hierarchical order
REM user<-role1<-role2 etc.
Prompt
Column grantee      heading Grantee        format a30
Column granted_role heading 'Granted Role' format a30
set verify off
Accept username char prompt 'Give the username whose roles you want :'
select distinct grantee,granted_role
from dba_role_privs
connect by prior granted_role = grantee
start with grantee = upper('&&username')
order by grantee
/

set verify on
clear columns
 
