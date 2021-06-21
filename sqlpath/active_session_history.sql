/*
For a long time, the only way DBAs could get SQL statement information correlated with wait events was through Oracle's 
extended 10046 trace. The new Oracle 10g V$ACTIVE_SESSION_HISTORY view now makes it possible to get this type of data 
past and present through queries alone. Suppose you have identified a session that is experiencing delays or "hangs" 
and you want to see  what SQL statement(s) the session is issuing, along with the wait events being experienced for a 
particular time period. 

Want the actual objects involved in the waits or database files? You can join the CURRENT_OBJ# column in 
V$ACTIVE_SESSION_HISTORY to DBA_OBJECTS to get the objects or CURRENT_FILE# to DBA_DATA_FILES to get the files. 

*/

SELECT  B.NAME,
        COUNT(*),
        SUM(TIME_WAITED),current_obj#,current_file#,
        C.SQL_TEXT
FROM    V$ACTIVE_SESSION_HISTORY A,
        V$EVENT_NAME B,
        V$SQLAREA C
WHERE   --A.SAMPLE_TIME BETWEEN '29-JAN-04 02:57:00 PM' AND  '29-JAN-04 02:59:00 PM' AND
        A.EVENT# = B.EVENT# AND
        A.SESSION_ID= '&sid' AND
        A.SESSION_SERIAL# = '&serial' AND
        A.SQL_ID = C.SQL_ID
GROUP BY C.SQL_TEXT, B.NAME,current_obj#,current_file#
/