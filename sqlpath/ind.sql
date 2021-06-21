Accept index_name char prompt 'Give index name              : '
Accept owner      char prompt 'Give the owner[default user] : '
Column index_name      heading 'Index Name'      format a20
Column owner           heading 'Owner'           format a15
Column table_name      heading 'Table Name'      format a20
Column last_analyzed   heading 'Last Analyzed'   format a20
Column distinct_keys   heading 'Distinct Keys'   format 9999
Column status          heading 'Status'          format a7
Column num_rows        heading 'Rows'            format 9999999
Column index_owner     heading 'Index Owner'     format a20
Column table_owner     heading 'Table Owner'     format a20
Column column_name     heading 'Column Name'     format a15
Column column_position heading 'Column|Position' format 9999
Column partitioned     heading 'Partitioned'     format a11
Column index_type      heading 'Index Type'      format a10

set verify off

set termout off
col owner new_value owner
select decode('&&owner',null,user,'&&owner') owner 
  from dual;
set termout on
Prompt ===========================================================================================================================
Prompt General Index info
select index_name,owner,table_name,status,last_analyzed,distinct_keys,status,num_rows
  from dba_indexes
 where index_name = upper('&&index_name')
   and owner = upper('&&owner');

Prompt
select index_name,owner,partitioned,index_type,tablespace_name
  from dba_indexes
 where index_name = upper('&&index_name')
   and owner = upper('&&owner');
   
Prompt
Prompt Index Detailed info
select index_owner,index_name,table_owner,table_name,column_name,column_position
  from dba_ind_columns
 where index_name = '&&index_name'
   and index_owner = upper('&&owner');
Prompt ===========================================================================================================================	
undefine index_name
set verify on
clear columns