--get sql hash for session and pass it to sql_text_from_hash.sql to get sql text

SELECT username,SID,serial#,ROUND(last_call_et/60) time_taken_in_Min,sql_hash_value,status
  FROM v$session
 WHERE sql_hash_value<>0  
   and username is not null
/
