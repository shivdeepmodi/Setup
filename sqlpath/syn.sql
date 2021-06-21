set verify off
Column owner        heading Owner           format a19
Column synonym_name heading 'Synonym Name'  format a30
Column table_owner  heading 'Table Owner'   format a15
Column table_name   heading 'Table Name'    format a30
Column db_link      heading 'Database Link' format a13
select *
  from dba_synonyms
   where synonym_name like upper('&&1')
/
set verify on
--clear columns