REM -- input query as : select text from dba_views where view_name = ''DBA_SOURCE''

Accept p_query char prompt 'Give query :'
declare
  v_cursor         integer default dbms_sql.open_cursor;
  i                number;
  v_temp           varchar2(250);
  v_returned_size  number;
  v_buffer_size    number := 250;
  v_marker         number := 0;
begin
  dbms_sql.parse( v_cursor, '&&p_query', dbms_sql.native );
  dbms_sql.define_column_long(v_cursor, 1);
  i := dbms_sql.execute(v_cursor);
  if (dbms_sql.fetch_rows(v_cursor)>0) then
    loop
      dbms_sql.column_value_long(v_cursor, 1, v_buffer_size, v_marker , v_temp, v_returned_size );
      v_marker := v_marker + v_returned_size;
      exit when v_returned_size = 0;
    end loop;
  end if;
  dbms_output.put_line( v_marker);
end;
