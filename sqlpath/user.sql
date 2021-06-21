--Accept username char prompt 'Give username :'
define username=&1
set verify off serveroutput on

declare
  p_query         varchar2(1000):='select * from dba_users where username = upper('||''''||'&&username'||''''||')';
  l_theCursor     integer default dbms_sql.open_cursor;
  l_columnValue   varchar2(4000);
  l_status        integer;
  l_descTbl       dbms_sql.desc_tab;
  l_colCnt        number;
  l_row           varchar2(1000):='';
  l_counter       number;
  filler          number:=30;
  user_not_found  EXCEPTION;
begin
  select count(*)
   into l_counter
   from dba_users
  where username = upper('&&username');
  
  if(l_counter=0) then
    raise user_not_found;
  end if;

  dbms_output.put_line(chr(10));  
  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;
   
   l_status := dbms_sql.execute(l_theCursor);

   dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
   dbms_output.put_line('Details for user '||'&&username');
   dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
    
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )|| ': ' ||l_columnValue );
      end loop;
    end loop;
    dbms_output.put_line(rpad(' ',filler));

 -- System priviledges granted to user    
  p_query         :='select privilege, admin_option from dba_sys_privs where grantee = upper('||''''||'&&username'||''''||')';
  select count(*)
    into l_counter
    from dba_sys_privs
   where grantee = upper('&&username');

  if(l_counter=0) then
     dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
     dbms_output.put_line('The user '||'&&username'||' does not any system privileges');
     dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
  else
  
  dbms_output.put_line(chr(10));   
  dbms_output.put_line(rpad('System Privilege',filler)||rpad('Admin Option',filler));
  dbms_output.put_line(rpad('================',filler)||rpad('============',filler));


  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;
   
   l_status := dbms_sql.execute(l_theCursor);
    
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        --dbms_output.put_line( rpad( l_descTbl(i).col_name, filler)|| ': ' ||l_columnValue );
        l_row:=l_row||rpad(l_columnValue,30);
      end loop;
      dbms_output.put_line(l_row);
      l_row:='';
    end loop;
  end if;
  
  -- Roles granted to user

  p_query         :='select granted_role, admin_option, default_role from dba_role_privs where grantee = upper('||''''||'&&username'||''''||')';
  select count(*)
    into l_counter
    from dba_role_privs
   where grantee = upper('&&username');

  if(l_counter=0) then
     dbms_output.put_line(chr(10));
     dbms_output.put_line('The user '||'&&username'||' does not any roles');
  else
  
  dbms_output.put_line(chr(10));
  dbms_output.put_line(rpad('Granted Role',filler)||rpad('Admin Option',filler)||rpad('Default Role',filler));
  dbms_output.put_line(rpad('============',filler)||rpad('============',filler)||rpad('============',filler));


  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;
   
   l_status := dbms_sql.execute(l_theCursor);
    
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        --dbms_output.put_line( rpad( l_descTbl(i).col_name, filler)|| ': ' ||l_columnValue );
        l_row:=l_row||rpad(l_columnValue,30);
      end loop;
      dbms_output.put_line(l_row);
      l_row:='';
    end loop;    
   end if;        
    
exception
    when user_not_found then
     dbms_output.put_line(chr(10));
     dbms_output.put_line('The user '||'&&username'||' does not exist');
    when others then
      dbms_output.put_line(SQLERRM);
end;
/
 
set verify on
clear columns
