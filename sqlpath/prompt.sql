set termout off
col database_role new_value database_role
select decode(database_role,'PRIMARY','PRI','PHYSICAL STANDBY','DR','SNAPSHOT STANDBY','SS') database_role from v$database;
col instance_name new_value instance_name
select instance_name as instance_name from v$instance;
col db_unique_name new_value db_unique_name
select value as db_unique_name from v$parameter where name = 'db_unique_name';
col sqlprompt new_value sqlprompt
select '&&database_role'||':'||'&&db_unique_name'||':'||'&&_user'||':-'||'&&instance_name'||'>' as sqlprompt from dual;
set sqlprompt &&sqlprompt

set termout on
