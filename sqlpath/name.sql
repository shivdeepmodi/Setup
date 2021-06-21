select 'You are connected to instance ' ||instance_name||' of database '||name
  from v$database, v$instance
/
