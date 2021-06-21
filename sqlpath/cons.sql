set verify off feed off
Accept table_name char prompt 'Give the table name :'
Accept owner char prompt 'Give the owner[default user] :' 

Column table_name          heading 'Table Name'         format a30
Column owner               heading 'Owner'              format a15
Column partitioned         heading 'Partitioned'        format a11
Column last_analyzed       heading 'Last Analyzed'      format a20
Column num_rows            heading 'Rows'               format 99999999999
Column table_size          heading 'Table Size'         format 99999999999
Column avg_row_len         heading 'Avg Row Length'     format 99999999999
Column tablespace_name     heading 'Tablespace'         format a15
Column constraint_name     heading 'Constraint Name'    format a25
Column constraint_type     heading 'Constraint Type'    format a17
Column search_condition    heading 'Search Condition'   format a40
Column column_name         heading 'Column Name'        format a30
Column position            heading 'Position'           format 99

column high_value  heading 'High|Value' format a17
column partition_name heading 'Partition Name' format a20
column subpartition_count heading 'Subpart|Count' format 999
column high_value_length heading 'High|Value|Length' format 999
column partition_position heading 'Part|Pos' format 999
column tablespace_name heading 'Tablespace' format a20
column num_rows        heading 'Rows'   format 999999
column blocks           heading 'Blocks' format 999999
column empty_blocks    heading 'Empty|Blocks' format 999999
column chain_cnt       heading 'Chain|count' format 999
column avg_space       heading 'Avg|Space'   format 99999
column avg_row_len     heading 'Average|Row|Lenght' format 9999999
column sample_size     heading 'Sample|Size' format 99999
column last_analyzed   heading 'Last Analyzed' format a13
column global_stats    heading 'Global|Stats' format a6

Prompt Listing Parent tables for &&table_name

select p.table_name "Parent Table", p.owner "Parent Owner",p.constraint_name "Parent Cons",c.constraint_name "Child Cons"
  from dba_constraints c, dba_constraints p
 where c.r_constraint_name = p.constraint_name
   and c.r_owner = p.owner
   and c.constraint_type = 'R'
   and c.table_name = upper('&table_name')
   and c.owner = decode('&&owner',null,user,upper('&&owner'));

Prompt
Prompt Listing Child tables for &&table_name

select c.table_name "Child Table", c.owner "Child Owner",c.constraint_name "Child Cons",p.constraint_name "Parent cons"
 from dba_constraints c, dba_constraints p
 where c.r_constraint_name = p.constraint_name
   and (p.constraint_type = 'P' or p.constraint_type = 'U')
   and c.constraint_type = 'R'
   and c.r_owner = p.owner
   and p.table_name = upper('&table_name')
   and p.owner = decode('&&owner',null,user,upper('&&owner'));

Prompt
undefine table_name
set verify on feedback on
clear columns