select STAT_NAME,
        ROUND((VALUE / 1000000),3) TIME_SECS
from    V$SYS_TIME_MODEL
order by 2 DESC
/