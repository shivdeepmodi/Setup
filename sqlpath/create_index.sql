rem
rem Script to create index creation DDL
rem
rem Biju Thomas
rem Shivdeep 10-Nov-2006 : Added upper and utl_file
rem Shivdeep 13-Dec-2006 : Removed utl_file and used long instead
rem Provide the owner name and table name along with the script with a space
rem
Accept username char prompt 'Enter Username :'
set verify off
declare
     l_str   long;
     l_piece long;
     n       number;
     /* Indexes */
     cursor cind is
     select owner, table_owner, table_name, index_name, ini_trans, max_trans,
            tablespace_name, initial_extent/1024 initial_extent, 
            next_extent/1024 next_extent, min_extents, max_extents, 
            pct_increase, decode(uniqueness,'UNIQUE','UNIQUE') unq
     from dba_indexes
     where table_owner like upper('&&username');
     /* Index columns */
     cursor ccol (o in varchar2, t in varchar2, i in varchar2) is
     select decode(column_position,1,'(',',')||
               rpad(column_name,40) cl
     from dba_ind_columns
     where table_name = upper(t) and
           index_name = upper(i) and
           index_owner = upper(o)
     order by column_position;
     wcount number := 0;
begin
    
  for rind in cind 
  loop
     wcount := wcount + 1;
       l_str:='create '||rind.unq||' index '|| rind.index_name||' on  '|| rind.table_name||chr(10);

       for rcol in ccol (rind.owner, rind.table_name, rind.index_name) loop
         l_str:=l_str||rcol.cl||chr(10);
       end loop;
     l_str:=l_str||chr(10)||')'||chr(10)||'/'||chr(10);  
           loop
        exit when l_str is null;
        n := instr( l_str, chr(10) );
        l_piece := substr( l_str, 1, n-1 );
        l_str   := substr( l_str, n+1 );
           loop
              exit when l_piece is null;
              dbms_output.put_line( substr( l_piece, 1, 250 ) );
              l_piece := substr( l_piece, 251 );
        end loop;
     end loop;
   end loop;
     
     
     
     if wcount =0 then
       dbms_output.put_line('******************************************************');
       dbms_output.put_line('*                                                    *');
       dbms_output.put_line('* Plese Verify Input Parameters... No Matches Found! *');
       dbms_output.put_line('*                                                    *');
       dbms_output.put_line('******************************************************');
     end if;
   end;
/
