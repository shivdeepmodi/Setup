rem -----------------------------------------------------------------------
rem Filename:   nls_lang.sql
rem Purpose:    Script to print NLS_LANG environment variable before export
rem             to avoid possible character set conversion while importing.
rem Date:       02-Nov-2006
rem Author:     Shivdeep Modi
rem -----------------------------------------------------------------------

Column nls_lang format a60
select 'export NLS_LANG='||l.value||'_'||t.value||'.'||c.value as nls_lang
from 
(select value from nls_database_parameters where parameter = 'NLS_LANGUAGE') l,
(select value from nls_database_parameters where parameter = 'NLS_TERRITORY') t,
(select value from nls_database_parameters where parameter = 'NLS_CHARACTERSET') c
/