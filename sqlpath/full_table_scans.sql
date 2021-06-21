
 
set echo off
set feedback on
 
set pages 999;
column nbr_FTS  format 9,999,999
column num_rows format 999,999,999
column blocks   format 999,999
column owner    format a14;
column name     format a24;
column ch       format a1;
 
column object_owner heading "Owner"            format a12;
column ct           heading "# of SQL selects" format 999,999;
 
select
   object_owner,
   count(*)   ct
from
   v$sql_plan
where
   object_owner is not null
group by
   object_owner
order by
   ct desc
;
 
 
 
set heading on;
set feedback on;
 
ttitle 'full table scans and counts|  |The "K" indicates that the table is in the KEEP Pool (Oracle8).'
select 
   p.owner, 
   p.name, 
   t.num_rows,
--   ltrim(t.cache) ch,
   decode(t.buffer_pool,'KEEP','Y','DEFAULT','N') K,
   s.blocks blocks,
   sum(a.executions) nbr_FTS
from 
   dba_tables   t,
   dba_segments s,
   v$sqlarea    a,
   (select distinct 
     address,
     object_owner owner, 
     object_name name
   from 
      v$sql_plan
   where 
      operation = 'TABLE ACCESS'
      and
      options = 'FULL') p
where 
   a.address = p.address
   and
   t.owner = s.owner
   and
   t.table_name = s.segment_name
   and
   t.table_name = p.name
   and
   t.owner = p.owner
   and
   t.owner not in ('SYS','SYSTEM')
having
   sum(a.executions) > 1
group by 
   p.owner, p.name, t.num_rows, t.cache, t.buffer_pool, s.blocks
order by 
   sum(a.executions) desc;
 
 
column nbr_RID  format 999,999,999
column num_rows format 999,999,999
column owner    format a15;
column name     format a25;
 
ttitle 'Table access by ROWID and counts'
select 
   p.owner, 
   p.name, 
   t.num_rows,
   sum(s.executions) nbr_RID
from 
   dba_tables t,
   v$sqlarea s,
  (select distinct 
     address, 
     object_owner owner, 
     object_name name
   from 
      v$sql_plan
   where 
      operation = 'TABLE ACCESS'
      and
      options = 'BY ROWID') p
where 
   s.address = p.address
   and
   t.table_name = p.name
   and
   t.owner = p.owner
having
   sum(s.executions) > 9
group by 
   p.owner, p.name, t.num_rows
order by 
   sum(s.executions) desc;
 
--*************************************************
--  Index Report Section
--*************************************************
 
column nbr_scans  format 999,999,999
column num_rows   format 999,999,999
column tbl_blocks format 999,999,999
column owner      format a9;
column table_name format a20;
column index_name format a20;
 
ttitle 'Index full scans and counts'
select
   p.owner,
   d.table_name,
   p.name index_name,
   seg.blocks tbl_blocks,
   sum(s.executions) nbr_scans
from
   dba_segments seg,
   v$sqlarea s,
   dba_indexes d,
  (select distinct
     address, 
     object_owner owner,
     object_name name
   from
      v$sql_plan
   where
      operation = 'INDEX'
      and
      options = 'FULL SCAN') p
where
   d.index_name = p.name
   and
   s.address = p.address
   and
   d.table_name = seg.segment_name
   and
   seg.owner = p.owner
having
   sum(s.executions) > 9
group by
   p.owner, d.table_name, p.name, seg.blocks
order by
   sum(s.executions) desc;
 
 
ttitle 'Index range scans and counts'
select
   p.owner,
   d.table_name,
   p.name index_name,
   seg.blocks tbl_blocks,
   sum(s.executions) nbr_scans
from
   dba_segments seg,
   v$sqlarea s,
   dba_indexes d,
  (select distinct
     address, 
     object_owner owner,
     object_name name
   from
      v$sql_plan
   where
      operation = 'INDEX'
      and
      options = 'RANGE SCAN') p
where
   d.index_name = p.name
   and
   s.address = p.address
   and
   d.table_name = seg.segment_name
   and
   seg.owner = p.owner
having
   sum(s.executions) > 9
group by
   p.owner, d.table_name, p.name, seg.blocks
order by
   sum(s.executions) desc;
 
 
ttitle 'Index unique scans and counts'
select 
   p.owner, 
   d.table_name, 
   p.name index_name, 
   sum(s.executions) nbr_scans
from 
   v$sqlarea s,
   dba_indexes d,
  (select distinct 
     address, 
     object_owner owner, 
     object_name name
   from 
      v$sql_plan
   where 
      operation = 'INDEX'
      and
      options = 'UNIQUE SCAN') p
where 
   d.index_name = p.name
   and
   s.address = p.address
having
   sum(s.executions) > 9
group by 
   p.owner, d.table_name, p.name
order by 
   sum(s.executions) desc;