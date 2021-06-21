Accept owner char prompt 'Give the owner : '
set verify off
Column owner        heading 'Owner'        format a20
Column object_type  heading 'Object Type' format a30
Column count(*)     heading 'Count'        format 99999

break on owner

compute sum label 'Total Objects' of count(*) on owner

select a.owner, a.object_type,  count(*)
  from dba_objects a
 where a.owner = upper('&owner')
 group by a.owner,a.object_type
 union
select a.owner, 'Constraint-'||constraint_type object_type, count(*)
  from dba_constraints a
 where a.owner = upper('&owner')
 group by a.owner,a.constraint_type
/
set verify on
clear breaks
--clear columns
