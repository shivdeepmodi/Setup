set head off feedback off lines 300 verify off
spool d:\shivdeep\spool\&1..sql
select text
 from dba_source
where name = upper('&&1')
/
spool off
set head on feedback on lines 300 verify on
exit