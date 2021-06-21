Column username     heading Username  format a10
Column osuser       heading Osuser    format a10
Column opname       heading Operation format a33
Column sid          heading SID       format 9999
Column serial#      heading SERIAL#   format 999999
Column sofar        heading Sofar     format 9999999999
Column totalwork    heading TotalWork format 99999999
Column "% Complete"                   format 999.99

SELECT l.SID, l.SERIAL#, s.sql_id,l.OPNAME, s.osuser,s.username, s.program,l.SOFAR, l.TOTALWORK, ROUND(SOFAR/TOTALWORK*100,2) "% Complete" 
  FROM GV$SESSION_LONGOPS l, GV$session s
 WHERE l.inst_id = s.inst_id
   and s.sid=l.sid
   and s.serial#=l.serial#
   AND l.OPNAME NOT LIKE '%aggregate%'
   AND l.TOTALWORK != 0
   AND l.SOFAR <> l.TOTALWORK
   AND S.status='ACTIVE'
/
