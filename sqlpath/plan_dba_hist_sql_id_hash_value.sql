undefine sql_id
undefine plan_hash_value
SELECT * FROM table(DBMS_XPLAN.DISPLAY_AWR('&&sql_id',&&plan_hash_value));