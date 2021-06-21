--SET PAGESIZE 0 LINESiZE 300 FEEDBACK OFF TERMOUT OFF TRIMSPOOL ON VERIFY OFF
--SPOOL /oracle9i/app/product/9.2.0/sqlplus/admin/work/refresh.sql
SELECT 'PROMPT Refreshing snapshots at '||to_char(sysdate, 'DD-MM-YYYY HH24:MI:SS')
  FROM dual;
SELECT 'PROMPT Refreshing '||name||chr(10)||'EXECUTE DBMS_SNAPSHOT.REFRESH('''||owner||'.'||name||''',''F'');'
  FROM all_refresh_children
 ORDER BY owner, name;
--SPOOL OFF
--SET TERMOUT ON
--@@ /oracle9i/app/product/9.2.0/sqlplus/admin/work/refresh.sql
