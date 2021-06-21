SELECT PLAN_TABLE_OUTPUT
FROM   GV$SQL s, DBA_SQL_PLAN_BASELINES b, 
       TABLE(
       DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(b.sql_handle,b.plan_name,'basic') 
       ) t
WHERE  s.EXACT_MATCHING_SIGNATURE=b.SIGNATURE
AND    b.PLAN_NAME=s.SQL_PLAN_BASELINE
AND    s.SQL_ID='9wf5gpkn961bg';

DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache(
    sql_id => '9wf5gpkn961bg ',plan_hash_value=>250386346);
dbms_output.put_line('loaded ->'|| l_plans_loaded);
END;
/
1m7ypsfc7hgn2

select *  from table(dbms_xplan.display_sql_plan_baseline(sql_handle =>'&handle'));
