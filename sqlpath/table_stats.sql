select owner,table_name,num_rows,round(num_rows*avg_row_len/1048576,2) size_mb,last_analyzed
  from dba_tables
 where table_name = '&1'
/