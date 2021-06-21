----------------------------------------------------------------------------
--     $Id: $
----------------------------------------------------------------------------
--     Trivadis AG, Infrastructure Managed Services
--     Europa-Strasse 5, 8152 Glattbrugg, Switzerland
----------------------------------------------------------------------------
--     File-Name........:  taln.sql
--     Author...........:  Stefan Oehrli (oes) stefan.oehrli@trivadis.com
--     Editor...........:  $LastChangedBy:   $
--     Date.............:  $LastChangedDate: $
--     Revision.........:  $LastChangedRevision: $
--     Purpose..........:  List/query alert log
--     Usage............:  @taln <NUMBER>
--     Group/Privileges.:  SYS (or grant manually to a DBA)
--     Input parameters.:  System privilege or part of
--     Called by........:  as DBA or user with access to x$dbgalertext
--     Restrictions.....:  unknown
--     Notes............:  --
----------------------------------------------------------------------------
--     Revision history.:  
----------------------------------------------------------------------------
col RECORD_ID for 9999999 head ID
col ORIGINATING_TIMESTAMP for a20 head Date
col MESSAGE_TEXT for a120 head Message

SET VERIFY OFF
SET TERMOUT OFF

column 1 new_value 1
column 2 new_value 2
SELECT '' "1" FROM dual WHERE ROWNUM = 0;
define ORA_ERROR = '&1'
SELECT '' "2" FROM dual WHERE ROWNUM = 0;
define number = '&2'

SET TERMOUT ON FEED OFF HEAD OFF TIMING OFF TRIMSPOOL ON PAGES 0

select 
    * 
from (select 
        cast(originating_timestamp as date) originating_timestamp,
        message_text
    from 
        x$dbgalertext
    order by RECORD_ID desc) 
where 
    --rownum <= DECODE('&&number', '', '10', '&&number')
    rownum=1
    and lower(MESSAGE_TEXT) like lower(DECODE('&&ORA_ERROR', '', '%', '&&ORA_ERROR%'))
order by 1 asc;

undefine 1
undefine 2
set FEED ON HEAD ON TIMING ON 
