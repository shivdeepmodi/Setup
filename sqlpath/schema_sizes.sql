Column owner                  heading 'Schema'    format a20
Column trunc(sum(bytes)/1024) heading 'Size (KB)' format 9999999999

break on report
Compute sum label 'Total Schema size' of size_mb on report
Compute sum label 'Total Schema size' of size_gb on report
select owner,
--round(sum(bytes)/1024,0) size_kb,
round(sum(bytes)/1048576,0) size_mb,round(sum(bytes)/1048576/1024,0) size_gb
 from dba_segments
group by owner
having round(sum(bytes)/1048576/1024,0)>=1
 order by owner
/
clear columns
