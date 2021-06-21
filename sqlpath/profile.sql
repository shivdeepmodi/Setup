col profile for a30
col RESOURCE_NAME for a30
col LIMIT for a30
select * from dba_profiles where profile=upper('&1')
/
