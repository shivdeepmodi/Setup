undefine sql_id
set markup html preformat on
select plan_table_output from table(dbms_xplan.display_cursor(
sql_id=>'&sql_id',
cursor_child_no=>&child_number,
format=>'ALLSTATS LAST ALL +PARTITION +OUTLINE +PEEKED_BINDS +PROJECTION +ALIAS +PREDICATE +COST +BYTES +PARTITION +NOTE'
)
)
/
set markup html off
