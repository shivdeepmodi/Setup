Column sid      format 99999
Column serial#  format 99999
Column username format a20
Column osuser   format a20
column active   format a9
Column status   format a8
undefine username
select sid,serial#,username,status,sql_id,sql_hash_value
       --,PREV_HASH_VALUE
	   ,osuser
  from gv$session
 where username = '&username'
   and sql_id is not null
/
--clear columns
undefine username