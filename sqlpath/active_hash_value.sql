Column sid      format 99999
Column serial#  format 99999
Column username format a20
Column osuser   format a20
column active   format a9
Column status   format a8

select sid,serial#,username,status,sql_hash_value,PREV_HASH_VALUE,osuser
  from v$session
 where username is not null
   and status = 'ACTIVE'
/
clear columns