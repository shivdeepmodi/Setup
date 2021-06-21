col tablespace_name heading 'Tablespace' format a30 truncate
col total_maxspace_mb heading 'MB|Max Size' format 999G999G999
col total_allocspace_mb heading 'MB|Allocated' format 999G999G999
col used_space_mb heading 'MB|Used' format 999G999G999D99
col free_space_mb heading 'MB|Free with|Autoextend' like used_space_mb
col free_space_ext_mb heading 'MB|Free in|Allocated' like used_space_mb
col pct_used heading '%|Used' format 999D99
col pct_free heading '%|Free' like pct_used

break on report
compute sum label "Total Size:" of total_maxspace_mb total_allocspace_mb used_space_mb - free_space_mb (used_space_mb/total_maxspace_mb)*100 on report

select /*+ALL_ROWS */ alloc.tablespace_name,alloc.total_maxspace_mb,
alloc.total_allocspace_mb,(alloc.total_allocspace_mb - free.free_space_mb) used_space_mb,
free.free_space_mb+(alloc.total_maxspace_mb-alloc.total_allocspace_mb) free_space_mb,
free.free_space_mb free_space_ext_mb,
((alloc.total_allocspace_mb - free.free_space_mb)/alloc.total_maxspace_mb)*100 pct_used,
((free.free_space_mb+(alloc.total_maxspace_mb-alloc.total_allocspace_mb))/alloc.total_maxspace_mb)*100 pct_free 
FROM (SELECT tablespace_name, ROUND(SUM(CASE WHEN maxbytes = 0 THEN bytes ELSE maxbytes END)/1048576) total_maxspace_mb,
ROUND(SUM(bytes)/1048576) total_allocspace_mb FROM dba_data_files
WHERE file_id NOT IN (SELECT FILE# FROM v$recover_file) GROUP BY tablespace_name) alloc,
(SELECT tablespace_name,SUM(bytes)/1048576 free_space_mb FROM dba_free_space WHERE file_id NOT IN (SELECT FILE# FROM v$recover_file) GROUP BY tablespace_name) free
WHERE alloc.tablespace_name = free.tablespace_name (+) 
and alloc.tablespace_name in ('SYSTEM')
ORDER BY pct_used DESC
/
