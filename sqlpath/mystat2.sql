---------------- mystat2.sql --------------
set echo off
set verify off
select a.name, b.value V, b.value-&V diff
from v$statname a, v$mystat b
where a.statistic# = b.statistic#
and lower(a.name) like '%' || lower('&S')||'%'
/
set echo on
