COLUMN EXECUTIONS FORMAT 999,999,999;
COLUMN Mem_used   FORMAT 999,999,999;
column owner format a20
column name format a30
SELECT owner,
       type,
       name,
       executions,
       sharable_mem       Mem_used,
       kept               "Kept?"
 FROM v$db_object_cache
 WHERE TYPE IN ('TRIGGER','PROCEDURE','PACKAGE BODY','PACKAGE')
   and owner not in ('SYS','IMDD_AUDIT_RSCE','XDB','DBSNMP','SYSTEM')
 ORDER BY EXECUTIONS DESC;