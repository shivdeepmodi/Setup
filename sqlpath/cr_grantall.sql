rem cr_grantall.sql
rem script to build grant select stmts for specified owners objects
rem S Dodsworth - Version 1.0 - 07feb00

set echo off verify off heading off feedback off

accept towner	prompt 'Enter value for object owner : '
accept tgrantee	prompt 'Enter value for grantee      : '
accept grtype	prompt 'Selects only [Y]/N           : '

--spool cr_grantall.out

select	'grant '||decode(nvl(upper('&grtype'),'Y'),'Y','select',
		'select'||','||'insert'||','||'update'||','||'delete')
		||' on '||owner ||'.'||object_name||' to &tgrantee;'
from	dba_objects
where	owner = upper('&towner')
and	object_type in ('TABLE','VIEW')
-- ignore underlying replication objects
and	object_name not like 'MVIEW$_%'
and	object_name not like 'SNAP$_%'
union all
select	'grant select'
		||' on '||sequence_owner||'.'||sequence_name||' to &tgrantee;'
from	dba_sequences
where	sequence_owner = upper('&towner')
and decode(nvl(upper('&grtype'),'Y'),'Y','Y','N') = 'Y'
union all
select	'grant execute on '||owner ||'.'||object_name||' to &tgrantee;'
from	dba_objects
where	owner = upper('&towner')
and	object_type in ('PROCEDURE','FUNCTION','PACKAGE')
and decode(nvl(upper('&grtype'),'Y'),'Y','Y','N') = 'N'
order by 1
/

--spool off

set heading on echo on feedback on echo off
