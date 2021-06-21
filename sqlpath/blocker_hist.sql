select * from (
SELECT a.sql_id ,
COUNT(*) OVER (PARTITION BY a.blocking_session,a.user_id ,a.program) cpt,
ROW_NUMBER() OVER (PARTITION BY a.blocking_session,a.user_id ,a.program
order by blocking_session,a.user_id ,a.program ) rn,
a.blocking_session,a.user_id ,a.program, s.sql_text
FROM sys.WRH$_ACTIVE_SESSION_HISTORY a ,sys.wrh$_sqltext s
where a.sql_id=s.sql_id
and blocking_session_serial# <> 0
and a.user_id <> 0
and trunc(a.sample_time) = trunc(sysdate)
) where rn = 1


SELECT  distinct to_char(a.sample_time,'DD-MON-YY HH24:MI') sample_time, 
a.sql_id ,a.inst_id,a.blocking_session,a.blocking_session_serial#,a.user_id,a.module,substr(s.sql_text,1,100) sql_text
FROM  GV$ACTIVE_SESSION_HISTORY a  ,gv$sql s
where a.sql_id=s.sql_id
and blocking_session is not null
and a.user_id <> 0 —-  exclude SYS user 
and trunc(a.sample_time) = trunc(sysdate)
and s.sql_text like '%ORG%LIQUIDITY%'
--and a.sql_id='d9sj72nsqknyt'
order by 1;

SELECT *
  FROM (  SELECT a.sql_id,
                 a.sample_time,
                 COUNT (*)
                 OVER (PARTITION BY a.blocking_session, a.user_id, a.program)
                    cpt,
                 ROW_NUMBER ()
                 OVER (PARTITION BY a.blocking_session, a.user_id, a.program
                       ORDER BY blocking_session, a.user_id, a.program)
                    rn,
                 a.blocking_session,
                 a.user_id,
                 a.program,
                 s.sql_text
            FROM sys.WRH$_ACTIVE_SESSION_HISTORY a, sys.wrh$_sqltext s
           WHERE     a.sql_id = s.sql_id
                 AND blocking_session_serial# <> 0
                 AND a.user_id <> 0
                 AND trunc(a.sample_time) = trunc(SYSDATE)
        ORDER BY a.sample_time)
 WHERE rn = 1;