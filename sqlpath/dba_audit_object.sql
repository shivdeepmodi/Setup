Column os_username format a20
Column username heading Username format a20
Column userhost heading UserHost format a10
Column terminal heading Terminal format a10

select os_username,username,userhost,terminal,owner,action_name,timestamp
  from dba_audit_object
 where obj_name = '&object_name'
 order by owner,timestamp
/