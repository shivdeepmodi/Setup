REM ===================================================================
REM Use the PL/SQL to find estimate the shared pool size
REM ===================================================================
DECLARE
v_total_plsql_mem	number:=0;
v_total_sql_mem		number:=0;
v_total_sharable_mem	number:=0;
BEGIN

SELECT sum(sharable_mem)
  INTO v_total_plsql_mem
  FROM v$db_object_cache;
  
SELECT sum(sharable_mem)
  INTO v_total_sql_mem
  FROM v$sqlarea;

v_total_sharable_mem:= ROUND((v_total_plsql_mem + v_total_sql_mem)/1048576);

DBMS_OUTPUT.PUT_LINE('Estimated Shared Pool size is: '||v_total_sharable_mem||' MB');
DBMS_OUTPUT.PUT_LINE('Add additional 250 bytes to the Shared Pool size estimate for every expected concurrent user session');
END;
/

REM ===================================================================
REM Use SQL below to determine if the SHARED_POOL_SIZE id set correctly
REM ===================================================================

col value for 999,999,999,999 heading "Shared Pool Size"
col bytes for 999,999,999,999 heading "Free Bytes"

SELECT to_number(v$parameter.value) value, v$sgastat.bytes,
       (v$sgastat.bytes/v$parameter.value)*100 "Percent Free"
  FROM v$sgastat, v$parameter
 WHERE v$sgastat.name = 'free memory'
   AND v$parameter.name = 'shared_pool_size'
   AND v$sgastat.pool = 'shared pool';