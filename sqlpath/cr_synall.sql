rem cr_synall.sql
rem script to build private synonyms for specified owners objects
rem S Dodsworth - Version 1.0 - 07feb00
rem S Dodsworth - Version 2.0 - 26feb01 - added function
rem S Dodsworth - Version 3.0 - 08aug05 - added syn owner in

set echo off verify off heading off feedback off
set linesize 120

col sort noprint

prompt
accept towner	prompt 'Enter value for object owner   : '
accept pquest	prompt 'Synonyms public y/n [N]        : ' default 'N'
accept sowner	prompt 'If private, synonym owner      : ' default '_'
prompt

--spool cr_synall.out

select	'create or replace '||decode(upper('&pquest'),'Y','public','') 
	||' synonym '
       	||decode(upper('&sowner'),'_','',' &sowner'||'.') 
	||object_name||' for '
	||owner||'.'||OBJECT_NAME||';'
from	dba_objects
where	owner = upper('&towner')
and	object_type in ('TABLE','SEQUENCE','VIEW','PACKAGE',
			'FUNCTION','PROCEDURE')
order by object_type,object_name
/


--spool off

set heading on feedback on echo on
