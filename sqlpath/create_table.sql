rem create table creation script
rem
rem Biju Thomas
rem Shivdeep 10-Nov-2006 : Added upper and utl_file
rem Shivdeep 12-Dec-2006 : Removed utl_file and used long instead
rem Pass owner name s parameters
rem
set heading off verify off feedback on
Accept username char prompt 'Enter Username :'

declare
   l_str   long;
   l_piece long;
   n       number;
     /*  Tables */
     cursor ctabs is select table_name, owner, tablespace_name,
          initial_extent/1024 initial_extent, pct_free, ini_trans, 
          next_extent/1024 next_extent, pct_increase, pct_used, max_trans,
          min_extents, max_extents
     from dba_tables where
     owner = upper('&&username');
     /* Columns */
     cursor ccols (o in varchar2, t in varchar2)
     is select decode(column_id,1,'(',',')
          ||rpad(column_name,40)
          ||rpad(data_type,10)
          ||rpad(
            decode(data_type,'DATE'    ,' '
                            ,'LONG'    ,' '
                            ,'LONG RAW',' '
                            ,'RAW'     ,decode(data_length,null,null
                                                    ,'('||data_length||')')
                            ,'CHAR'    ,decode(data_length,null,null
                                                    ,'('||data_length||')')
                            ,'VARCHAR' ,decode(data_length,null,null
                                                    ,'('||data_length||')')
                            ,'VARCHAR2',decode(data_length,null,null
                                                    ,'('||data_length||')')
                            ,'NUMBER'  ,decode(data_precision,null,'   '
                                                ,'('||data_precision||
     decode(data_scale,null,null,','||data_scale)||')'),' '),8,' ') cstr
     from dba_tab_columns
     where table_name = upper(t)
     and   owner = upper(o)
     order by column_id;
     wcount number := 0;
  begin
  
    for rtabs in ctabs loop
      wcount := wcount + 1;
      l_str:='create table '|| rtabs.owner || '.' || rtabs.table_name||chr(10);
      
      for rcols  in ccols (rtabs.owner, rtabs.table_name) 
      loop
         l_str:=l_str||rcols.cstr||chr(10);
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
    if wcount = 0 then
      dbms_output.put_line('No tables for user '||'&&username');
    end if;
          
  exception
   when others then 
      DBMS_OUTPUT.put_line('error code: ' || SQLCODE);
   DBMS_OUTPUT.put_line('error message: ' || SQLERRM(SQLCODE));
  end;
/
prompt
set heading on verify on feedback on


