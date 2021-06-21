column username heading Username format a10
column sql_text format a90 newline
column error_msg format a90 newline
column name format a20
select r.name ,u.username,session_id,
       instance_name,
       r.status,timeout,start_time,suspend_time,resume_time,sql_text,error_msg
  from dba_resumable r, dba_users u, gv$instance i
 where r.user_id = u.user_id
   and r.instance_id = i.inst_id
   and error_msg is not null
/
 
