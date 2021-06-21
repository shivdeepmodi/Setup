Accept table_name char prompt 'Give Table Name: '
Accept owner      char prompt 'Give Owner     : '
set verify off feedback off head off

Prompt Table Definition
select dbms_metadata.get_ddl('TABLE',table_name,owner)||';'
  from dba_tables
 where table_name = upper('&table_name')
   and owner = upper('&owner')
/

Prompt Index Definition  
select dbms_metadata.get_ddl('INDEX',index_name,owner)||';'
  from dba_indexes
 where table_name = upper('&table_name')
   and table_owner = upper('&owner')
   and index_name != (select index_name 
                        from dba_constraints 
                       where constraint_type = 'P'
                         and table_name = upper('&table_name')
                         and owner = upper('&owner')
                     )  
/
Prompt Constraint Definition  
select dbms_metadata.get_ddl('CONSTRAINT',constraint_name,owner)||';'
  from dba_constraints
 where table_name = upper('&table_name')
   and owner = upper('&owner')
   and constraint_type != 'P'
/

Prompt Trigger Definition  
select dbms_metadata.get_ddl('TRIGGER',trigger_name,owner)
  from dba_triggers
 where table_name = upper('&table_name')
   and table_owner = upper('&owner')
/

set verify on feedback on head on