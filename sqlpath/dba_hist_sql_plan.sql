break on plan_hash_value skip 1 dup            
col operation format a90
col cost format 99999                         
col kbytes format 999999                      
col object format a25                         
select --plan_hash_value,                       
lpad(' ',2*depth)||operation||' '||options||decode(id, 0, substr(optimizer,1, 6)||' Cost='||to_char(cost)) operation,      
object_name object,                                                                                                        
cost,                                                                                                                      
cardinality,                                                                                                               
round(bytes / 1024) kbytes                                                                                                 
from DBA_HIST_SQL_PLAN  
where --sql_id = 'sql_id'
plan_hash_value=&plan_hash_value
/
clear columns breaks