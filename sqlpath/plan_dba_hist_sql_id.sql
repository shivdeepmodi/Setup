undefine sql_id
SELECT * FROM table(DBMS_XPLAN.DISPLAY_AWR('&&sql_id'));
 