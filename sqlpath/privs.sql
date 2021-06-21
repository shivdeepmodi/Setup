set verify off
Column grantee    heading Grantee      format a21
Column owner      heading Owner        format a20
Column table_name heading 'Table Name' format a22
Column grantor    heading Grantor      format a20
Column privilege  heading Privilege    format a17
Column grantable  heading Grantable    format a9
Column hierarchy  heading Hierarchy    format a9


select grantee,owner,table_name,grantor,privilege,grantable,hierarchy
  from dba_tab_privs 
  where upper(table_name) = upper('&&1')
/
set verify on
--clear columns