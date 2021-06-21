select * from (
select 'DB_ROLE' name,database_role value from v$database
union
select * from (
select name,value from v$parameter where name in (
'db_name',
'db_unique_name',
'cluster_database',
'spfile',
'compatible',
'log_mode',
'optimizer_adaptive_features',
'optimizer_features_enable',
'sec_case_sensitive_logon',
'inmemory_force',
' timezone version'
))
union
Select 'timezone version' as name, to_char(version) as value from v$timezone_file
)
order by name;

