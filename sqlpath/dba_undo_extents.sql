REM Describes all undo extents in system managed undo tablespaces

select tablespace_name, status, count(*) Count
  from dba_undo_extents
 group by tablespace_name, status
/
