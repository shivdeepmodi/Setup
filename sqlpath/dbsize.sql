set serverout on
declare

data number;
temp number;
redo number;
total number;

begin

select sum(bytes/1048576) into data from dba_data_files ;
select nvl(sum(bytes/1048576),0) into temp from dba_temp_files ;
select sum(bytes/1048576) into redo from v$log ;

total := data + temp + redo;
total := total/1024;

dbms_output.put_line('The size of the datafiles is :' || round(data/1024)||' GB');
dbms_output.put_line('The size of the tempfiles is :' || round(temp/1024)||' GB');
dbms_output.put_line('The size of the database is  :' || round(total)||' GB');

end;
/