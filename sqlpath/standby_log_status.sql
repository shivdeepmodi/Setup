--select max(sequence#) from v$archived_log;
SELECT THREAD#, MAX(SEQUENCE#) AS "LAST_APPLIED_LOG"
  FROM V$LOG_HISTORY
 GROUP BY THREAD#;

Prompt Activities performed by both log transport and log apply processes in a Data Guard environment. 
Prompt The CLIENT_P column in the output of the following query identifies the corresponding primary database process.
select process,CLIENT_PROCESS,SEQUENCE#,BLOCKS,status from v$managed_standby
/