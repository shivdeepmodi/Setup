col "File Name" for a30
col Dir for a18
col tablespace for a20
col Redo for a20
col Temp_Tablespace heading Temp for a20
break on Temp_Tablespace skip 1
break on tablespace skip 1
compute sum of bytes on tablespace
compute sum of bytes on Temp_Tablespace
spool &&_CONNECT_IDENTIFIER

select tablespace_name Tablespace,
       substr(file_name,1,16) Dir, 
       substr(file_name,17) "File Name",
       bytes/1024/1024 bytes 
  from dba_data_files
 order by 1,2,3;


select tablespace_name Temp_Tablespace,
       substr(file_name,1,16) Dir, 
       substr(file_name,17) "File Name",
       bytes/1024/1024 bytes from dba_temp_files
ORDER BY 1,2,3;

break on Redo skip 1
compute sum of bytes on Redo

select substr(f.member,1,16) Redo,
       substr(f.member,1,16) Dir,
       substr(f.member,17) "File Name",   
       l.bytes/1024/1024 bytes
  from v$logfile f, v$log l
 where l.group#=f.group#
 order by 1,2,3;

spool off
clear computes
clear breaks
clear columns