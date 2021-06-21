----------------------------------------------------------------------------
--     http://www.oradba.ch/2013/07/query-alert-log-from-sqlplus/
----------------------------------------------------------------------------
col RECORD_ID for 9999999 head ID
col ORIGINATING_TIMESTAMP for a20 head Date
col MESSAGE_TEXT for a120 head Message

SET VERIFY OFF
SET TERMOUT OFF

column 1 new_value 1
SELECT '' "1" FROM dual WHERE ROWNUM = 0;
define ORA_ERROR = '&1'

SET TERMOUT ON

select 
    --record_id,
    to_date(to_char(originating_timestamp,'DD-MM-YYYY HH24:MI:SS'),'DD-MM-YYYY HH24:MI:SS') originating_timestamp,
    message_text 
from 
    x$dbgalertext 
where 
    lower(MESSAGE_TEXT) like lower(DECODE('&&ORA_ERROR', '', '%', '%&&ORA_ERROR%'))
order by 1;

SET HEAD OFF
select 'Filter on alert log message => '||NVL('&&ORA_ERROR','%') from dual;    
SET HEAD ON
undefine 1