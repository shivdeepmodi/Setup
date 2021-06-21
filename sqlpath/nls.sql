col dl heading 'Database Level' format a40
col il heading 'Instance Level' format a40
select d.parameter, d.value dl,i.value il
  from (select parameter, value from nls_database_parameters) d
       full outer join
       (select parameter, value from nls_instance_parameters) i
 on d.parameter = i.parameter
 order by d.parameter
/
 
