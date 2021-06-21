set head off pages 0 feedback off

select files from (
select name   as files from v$datafile
union all
select name   as files from v$controlfile
union all
select member as files from v$logfile
union all
select name   as files from v$tempfile
)
/
set head on pages 10000 feedback on
