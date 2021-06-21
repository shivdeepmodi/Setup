select tablespace_name,sum(obj_cnt)
  from (
                select tablespace_name, count(*) obj_cnt from dba_segments group by tablespace_name
                union
                select tablespace_name, 0 obj_cnt from dba_tablespaces
                )
 group by tablespace_name
 order by tablespace_name
/
