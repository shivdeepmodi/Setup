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

Prompt
Prompt General Table info
Prompt
declare
  p_query         varchar2(1000):='select * from dba_tables where table_name=upper('||''''||'&&table_name'||''''||') and owner='||'decode('||''''||'&&owner'||''''||',null,user,upper('||''''||'&&owner'||''''||'))'; 
  l_theCursor     integer default dbms_sql.open_cursor;
  l_columnValue   varchar2(4000);
  l_status        integer;
  l_descTbl       dbms_sql.desc_tab;
  l_colCnt        number;
begin
  execute immediate 'alter session set nls_date_format=''DD-MON-YYYY HH24:MI:SS'' ';

  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )|| ': ' ||l_columnValue );
      end loop;
      dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
    end loop;
    execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
exception
    when others then
      execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
      raise;
end;
/
--SELECT table_name, owner, temporary,partitioned,last_analyzed, num_rows,avg_row_len,nvl(avg_row_len,0)*nvl(num_rows,0) as table_size ,tablespace_name
--  FROM dba_tables
-- WHERE table_name = upper('&&table_name')
--   AND owner = decode('&&owner',null,user,upper('&&owner'));

Prompt
Prompt Partition info
Prompt
select partition_name,
       --subpartition_count,
       high_value,
       --high_value_length,
       --partition_position,
       NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_SPACE,CHAIN_CNT,AVG_ROW_LEN,SAMPLE_SIZE,LAST_ANALYZED,GLOBAL_STATS,
       tablespace_name,
       composite
  from dba_tab_partitions
 where table_name = upper('&&table_name')
   and table_owner = decode('&&owner',null,user,upper('&&owner')) and 1 =2
/

Prompt
Prompt Finding Constraints for &&table_name 
select table_name,owner,constraint_name,DECODE(constraint_type,'C','Check Constraint'
                      ,'P','Primary key'
                      ,'U','Unique key'
                      ,'R','Foreign Key'
                      ,'V','With Check Option'
                      ,'O','With Read Only'
                      ,constraint_type
       ) "Constraint Type",search_condition
  from dba_constraints
 where table_name = upper('&&table_name')
   and owner = upper('&&owner');

Prompt
Prompt Listing columns for the constraints
Prompt
 break on constraint_name
select constraint_name,column_name,position
  from dba_cons_columns
 where table_name = upper('&&table_name')
   and owner = upper('&&owner')
 order by constraint_name;

Prompt
break on index_name
Prompt Finding Indexes for &&table_name 
SELECT index_name, column_name
  FROM dba_ind_columns
 WHERE table_name = upper('&table_name')
   AND table_owner = decode('&&owner',null,user,upper('&&owner'));
Prompt

Prompt
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
