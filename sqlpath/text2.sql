set head off feedback off lines 300 verify off
spool d:\shivdeep\work\spool\&1._&2..sql
select text
 from dba_source
where name = upper('&&2')
  and owner = upper('&&1')
/
spool off
set head on feedback on lines 300 verify on