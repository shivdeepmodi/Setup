select  A.SID,
        B.USERNAME,
        A.STAT_NAME,
        ROUND((A.VALUE / 1000000),3) TIME_SECS
from    V$SESS_TIME_MODEL A,
        V$SESSION B
where   A.SID = B.SID and
        B.SID = '&sid'
order by 4 DESC
/