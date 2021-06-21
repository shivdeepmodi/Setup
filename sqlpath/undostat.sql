select MAXQUERYID,begin_time, end_time, 
undoblks, txncount, maxconcurrency as maxcon,nospaceerrcnt from V$UNDOSTAT
where begin_time = sysdate - 1/24
/
