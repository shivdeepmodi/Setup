col owner for a10
col object_name for a40
col tablespace_name for a10
col STATISTIC_NAME for a30
col value for 99999999999
col rnum for 999 noprint

select * from
(
select owner,object_name,tablespace_name,STATISTIC_NAME,value, row_number() over ( partition by STATISTIC_NAME order by value desc) rnum
from v$segment_statistics
where statistic_name  in (
'logical reads',
'physical reads',
'physical reads direct',
'physical writes',
'physical writes direct'
)
and owner not in ('SYS','SYSTEM','PERFSTAT','NCLDBA','OUTLN')
 order by STATISTIC_NAME, value desc
)
where rnum <=20
/
