select  A.SID,
        B.USERNAME,
        A.SEQ#,
        A.EVENT,
        A.WAIT_TIME
from    V$SESSION_WAIT_HISTORY A,
        V$SESSION B
where   A.SID = B.SID and
        B.USERNAME IS NOT NULL 
order by 1,3
/