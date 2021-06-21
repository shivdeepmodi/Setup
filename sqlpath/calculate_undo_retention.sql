set head off feedback off verify off
select 'Current Undo Retention is : '||value ||' seconds'
  from v$parameter
 where name = 'undo_retention'
/

Accept newundo number prompt 'Give a value for undo retention : '

--select value from v$parameter where name = 'db_block_size'
--/

select 'Undo Tablespace Size is : '||
       &&newundo*undoblks/((end_time-begin_time)*3600*24)*(select value from v$parameter where name = 'db_block_size')/1048576 ||' MB'
  from v$undostat
 where maxquerylen = (select max(maxquerylen) from v$undostat)
/
set head on feedback on verify on