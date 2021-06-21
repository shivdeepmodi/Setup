set head off feedback off verify off
Accept drop_user char prompt 'Give User to clean:'
Accept 10db      char prompt 'Is a 10g database?:' default 'Y'

spool drop_objects_&&_CONNECT_IDENTIFIER._&&drop_user..sql
prompt spool drop_objects_&&_CONNECT_IDENTIFIER._&&drop_user..lst

REM Script to generate ddl to drop all the owner objects

select 'alter table '||owner||'.'||table_name||' drop constraint '||constraint_name||' cascade;'
from dba_constraints
where owner = upper('&&drop_user')
  and status = 'ENABLED'
  and constraint_type = 'R';

select 'drop '|| decode(object_type,'UNDEFINED','MATERIALIZED VIEW',object_type)||' '||owner||'.'||''||object_name||''||decode(object_type,'TABLE',decode(upper('&&10db'),'Y',' PURGE'))||';'
from dba_objects
where owner = upper('&&drop_user')
 and object_type not in ('INDEX','DATABASE LINK','TRIGGER','LOB','TABLE PARTITION','PACKAGE','PACKAGE BODY','TYPE');


select Statement from (
select 'drop '||object_type||' '||owner||'.'||object_name||';' Statement,
       object_name,
       object_type,
       rank() over (partition by object_name order by object_type) as rank
  from dba_objects
 where object_type like 'PACKAGE%'
   and owner = upper('&&drop_user')
   ) where rank = 1
/

select 'drop '|| object_type||' '||owner||'.'||'"'||object_name||'" force;'
from dba_objects
where owner = upper('&&drop_user')
 and object_type ='TYPE';
 
prompt spool off
spool off

set head on feedback on verify on
prompt
prompt The Script created is drop_objects_&&_CONNECT_IDENTIFIER._&&drop_user..sql
prompt