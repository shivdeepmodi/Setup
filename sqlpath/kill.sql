set head off feedback off

select 'alter /*+ &comment */ system kill session '||''''||sid||','||serial#||''''||' immediate;' from v$session where sid=&1;

set head on feedback on

