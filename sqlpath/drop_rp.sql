@fra
select 'drop restore point '||name||';' from v$restore_point;
