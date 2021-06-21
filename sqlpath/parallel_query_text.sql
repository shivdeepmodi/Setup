select sess.sid,sess.username,q.slaves,sql.sql_text
  from 
(
select decode(px.qcinst_id, NULL ,s.sid ,px.qcsid) SID, 
       count(decode(px.qcinst_id, NULL ,s.sid ,px.qcsid)) slaves
  from v$px_session px,  v$session s 
 where px.sid=s.sid (+) 
   and px.serial#=s.serial# 
   and px.server_set is not null
 group by decode(px.qcinst_id, NULL ,s.sid ,px.qcsid) 
     ) q, v$session sess, v$sql sql
 where q.sid = sess.sid
   and sess.sql_hash_value = sql.hash_value
   and sess.sql_address  = sql.address
/