col host_name for a30
col dataguard_broker heading BROKER
select substr(host_name,1,instr(host_name,'.')-1) host_name,instance_name,startup_time,status, 
database_role,dataguard_broker,open_mode,logins 
from gv$database d, gv$instance i where i.inst_id=d.inst_id;
