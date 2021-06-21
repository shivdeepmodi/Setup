set markup html preformat on
select plan_table_output from table(dbms_xplan.display(
table_name=>'PLAN_TABLE',
statement_id=>null,
format=>'ALLSTATS LAST ALL +PARTITION +OUTLINE +PEEKED_BINDS +PROJECTION +ALIAS +PREDICATE +COST +BYTES +PARTITION +NOTE')
)
/
set markup html off
