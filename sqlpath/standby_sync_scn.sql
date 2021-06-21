select min (checkpoint_change#) 
  from v$datafile_header ;
 --where status in (select status from dba_tablespaces where status <> 'READ ONLY') order by 1;

