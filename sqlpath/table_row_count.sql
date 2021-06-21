Accept owner char prompt 'Give owner of the table :'
select 'SELECT '''||owner||'.'||table_name||''' tab_name, COUNT(*) num_rows
	FROM '||owner||'."'||table_name|| '";' 
  from dba_tables
 where owner = upper('&&owner')
order by 1
/